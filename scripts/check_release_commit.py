#!/usr/bin/env python3
"""Require exact release subjects when remote binary target metadata changes."""

import argparse
from pathlib import Path
import re
import subprocess
import sys
from urllib.parse import unquote, urlsplit


TARGET = re.compile(
    r'\.binaryTarget\s*\(\s*name:\s*"([^"\n]+)"\s*,\s*'
    r'url:\s*"([^"\n]+)"\s*,\s*checksum:\s*"([0-9a-f]{64})"\s*,?\s*\)'
)


def git(*args, allow_missing=False):
    result = subprocess.run(["git", *args], text=True, capture_output=True)
    if not (allow_missing and result.returncode == 1):
        result.check_returncode()
    return result.stdout


def manifest(revision):
    paths = git("ls-files", "--cached", "--", "Package.swift") if revision == ":" else git(
        "ls-tree", "--name-only", revision, "--", "Package.swift"
    )
    if not paths.strip():
        return ""
    return git("show", ":Package.swift" if revision == ":" else f"{revision}:Package.swift")


def artifacts(source):
    # Preserve quoted URLs while removing Swift comments.
    source = re.sub(
        r'("(?:\\.|[^"\\])*")|//[^\n]*|/\*.*?\*/',
        lambda match: match[1] or "",
        source,
        flags=re.S,
    )
    matches = TARGET.findall(source)
    if len(matches) != len(re.findall(r"\.binaryTarget\s*\(", source)):
        raise ValueError("Use literal remote binaryTarget(name:url:checksum:) metadata.")
    result = {name: (url, checksum) for name, url, checksum in matches}
    if len(result) != len(matches):
        raise ValueError("Binary target names must be unique.")
    return result


def check(before, after, message):
    if before == after:
        return
    previous, current = artifacts(before), artifacts(after)
    if previous == current:
        return
    if not current:
        raise ValueError("Release metadata must retain remote binary targets.")
    versions = set()
    for url, _ in current.values():
        parsed = urlsplit(url)
        version = re.fullmatch(r"/.+/releases/download/([^/]+)/[^/]+", parsed.path)
        if parsed.scheme != "https" or not parsed.netloc or not version:
            raise ValueError("Binary URLs must identify an HTTPS release download version.")
        versions.add(unquote(version[1]))
    if len(versions) != 1:
        raise ValueError("All binary target URLs must use the same exact release version.")
    expected = f"Release {versions.pop()}"
    subject = message.splitlines()[0] if message else ""
    if subject != expected:
        raise ValueError(f"Expected commit subject: {expected}\nReceived: {subject or '(empty)'}")


def check_commit(commit):
    parents = git("rev-list", "--parents", "-n", "1", commit).split()[1:]
    after = manifest(commit)
    before = manifest(parents[0]) if parents else ""
    try:
        check(before, after, git("show", "-s", "--format=%B", commit))
    except ValueError as error:
        raise ValueError(f"Commit {commit[:12]}: {error}") from error


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group(required=True)
    modes.add_argument("--message-file", type=Path, help="Validate staged release metadata (commit-msg hook).")
    modes.add_argument("--base", help="Validate commits introduced since this SHA (CI).")
    parser.add_argument("--head", default="HEAD", help="Last commit to validate in CI.")
    args = parser.parse_args()
    try:
        if args.message_file:
            head = git("rev-parse", "--verify", "--quiet", "HEAD", allow_missing=True).strip()
            check(manifest(head) if head else "", manifest(":"), args.message_file.read_text(encoding="utf-8"))
        else:
            if not args.base or set(args.base) == {"0"}:
                commits = [git("rev-parse", "--verify", args.head).strip()]
            else:
                commits = git("rev-list", "--reverse", f"{args.base}..{args.head}").splitlines()
            for commit in commits:
                check_commit(commit)
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        detail = error.stderr.strip() if isinstance(error, subprocess.CalledProcessError) else str(error)
        print(f"Release commit check failed: {detail}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
