import importlib.util
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts/check_release_commit.py"
spec = importlib.util.spec_from_file_location("release_check", SCRIPT)
release_check = importlib.util.module_from_spec(spec)
spec.loader.exec_module(release_check)


def package(version="1.0.0-alpha.11", checksum="a", companion_version=None):
    return "\n".join(
        f'.binaryTarget(name: "{name}", '
        f'url: "https://github.com/example/sdk/releases/download/{tag}/{name}.xcframework.zip", '
        f'checksum: "{checksum * 64}")'
        for name, tag in [("Primordial", version), ("Companion", companion_version or version)]
    )


class MessageTests(unittest.TestCase):
    def test_exact_versions_and_body_are_allowed(self):
        for version in ["1.0.0-alpha.12", "1.0.0", "2.0.0-rc.1"]:
            with self.subTest(version=version):
                release_check.check(package(), package(version), f"Release {version}\n\nRelease details.")

    def test_wrong_release_subjects_print_expected_subject(self):
        for subject in ["Fix license activation", "Release 1.0.0.12", "Release 1.0.0-alpha.11", ""]:
            with self.subTest(subject=subject), self.assertRaisesRegex(ValueError, "Expected commit subject: Release 1.0.0-alpha.12"):
                release_check.check(package(), package("1.0.0-alpha.12"), subject)

    def test_checksum_changes_are_release_changes(self):
        with self.assertRaisesRegex(ValueError, "Expected commit subject"):
            release_check.check(package(), package(checksum="b"), "Update artifacts")
        release_check.check(package(), package(checksum="b"), "Release 1.0.0-alpha.11")

    def test_nonrelease_changes_allow_descriptive_subjects(self):
        original = package()
        for updated in [original, original.replace(", ", ",\n    "), "// Notes\n" + original,
                        "\n".join(reversed(original.splitlines())), "// platforms changed\n" + original]:
            with self.subTest(updated=updated):
                release_check.check(original, updated, "Improve package documentation")
        release_check.check("", "// No binary targets yet", "Initialize repository")

    def test_invalid_metadata_is_rejected(self):
        malformed = [
            (package(companion_version="1.0.0-alpha.12"), "same exact release version"),
            (package().replace('checksum: "' + "a" * 64 + '"', "checksum: checksum"), "literal remote"),
            (package().replace("https://", "http://"), "HTTPS release"),
            (package() + "\n" + package(), "unique"),
            ("", "retain remote"),
        ]
        for updated, error in malformed:
            with self.subTest(error=error), self.assertRaisesRegex(ValueError, error):
                release_check.check(package(), updated, "Release 1.0.0-alpha.11")


class GitTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="primordial-commit-test-")
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name)
        self.git("init", "-q", "--initial-branch=main")
        self.git("config", "user.name", "Hook Test")
        self.git("config", "user.email", "hook-test@example.invalid")
        self.git("config", "commit.gpgSign", "false")
        self.git("config", "core.hooksPath", ".githooks")
        (self.repo / "scripts").mkdir()
        (self.repo / ".githooks").mkdir()
        shutil.copyfile(SCRIPT, self.repo / "scripts/check_release_commit.py")
        hook = self.repo / ".githooks/commit-msg"
        shutil.copyfile(ROOT / ".githooks/commit-msg", hook)
        hook.chmod(0o755)
        self.write_package("1.0.0-alpha.11")
        self.git("add", "Package.swift", "scripts", ".githooks")
        self.git("commit", "-qm", "Release 1.0.0-alpha.11")
        self.initial = self.git("rev-parse", "HEAD").stdout.strip()

    def git(self, *args, check=True, input=None):
        return subprocess.run(["git", *args], cwd=self.repo, text=True, capture_output=True, check=check, input=input)

    def write_package(self, version):
        (self.repo / "Package.swift").write_text(package(version))

    def validate(self, base, head="HEAD"):
        return subprocess.run([sys.executable, str(SCRIPT), "--base", base, "--head", head],
                              cwd=self.repo, text=True, capture_output=True)

    def test_hook_rejects_wrong_message_and_reads_staged_manifest(self):
        self.write_package("1.0.0-alpha.12")
        self.git("add", "Package.swift")
        self.write_package("1.0.0-alpha.13")
        rejected = self.git("commit", "-qm", "Fix license activation", check=False)
        self.assertNotEqual(rejected.returncode, 0)
        self.assertIn("Expected commit subject: Release 1.0.0-alpha.12", rejected.stderr)
        self.assertEqual(self.git("rev-parse", "HEAD").stdout.strip(), self.initial)
        self.git("commit", "-qm", "Release 1.0.0-alpha.12")
        self.assertIn("alpha.12", self.git("show", "HEAD:Package.swift").stdout)
        self.assertIn("alpha.13", (self.repo / "Package.swift").read_text())
        (self.repo / "README.md").write_text("Updated documentation.\n")
        self.git("add", "README.md")
        self.git("commit", "-qm", "Improve documentation")
        self.assertEqual(self.validate(self.initial).returncode, 0)

    def test_commit_only_uses_the_temporary_index(self):
        self.write_package("1.0.0-alpha.12")
        self.git("add", "Package.swift")
        (self.repo / "README.md").write_text("Documentation.\n")
        self.git("add", "README.md")
        self.git("commit", "-qm", "Improve documentation", "--only", "README.md")
        self.assertIn("alpha.11", self.git("show", "HEAD:Package.swift").stdout)
        self.git("commit", "-qm", "Release 1.0.0-alpha.12")

    def test_ci_checks_each_commit_and_message_only_amendments(self):
        self.write_package("1.0.0-alpha.12")
        self.git("add", "Package.swift")
        self.git("commit", "-qm", "Release 1.0.0-alpha.12")
        original = self.git("rev-parse", "HEAD").stdout.strip()
        # commit-msg cannot identify --amend; CI compares the amended commit to its parent.
        self.git("commit", "--amend", "-qm", "Fix license activation")
        amended = self.git("rev-parse", "HEAD").stdout.strip()
        (self.repo / "README.md").write_text("Documentation.\n")
        self.git("add", "README.md")
        self.git("commit", "-qm", "Improve documentation")
        result = self.validate(original)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(amended[:12], result.stderr)
        self.assertIn("Expected commit subject: Release 1.0.0-alpha.12", result.stderr)

    def test_merge_that_changes_release_metadata_requires_release_subject(self):
        self.git("switch", "-qc", "release")
        self.write_package("1.0.0-alpha.12")
        self.git("add", "Package.swift")
        self.git("commit", "-qm", "Release 1.0.0-alpha.12")
        self.git("switch", "-q", "main")
        rejected = self.git("merge", "--no-ff", "--no-edit", "release", check=False)
        self.assertNotEqual(rejected.returncode, 0)
        self.assertIn("Expected commit subject: Release 1.0.0-alpha.12", rejected.stderr)
        self.git("commit", "-qm", "Release 1.0.0-alpha.12")
        self.assertEqual(self.validate(self.initial).returncode, 0)

    def test_ci_handles_initial_push_and_missing_base(self):
        self.assertEqual(self.validate("0" * 40).returncode, 0)
        self.assertNotEqual(self.validate("f" * 40).returncode, 0)


if __name__ == "__main__":
    unittest.main()
