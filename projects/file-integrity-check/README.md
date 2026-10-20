# Project 6 — File integrity check

This project records SHA-256 hashes for regular files under a directory, then compares a later snapshot with the saved baseline. It is a small way to learn integrity monitoring and file manifests.

## Try it in a lab

    mkdir -p /tmp/integrity-lab/files /tmp/integrity-lab/state
    printf 'original content\n' > /tmp/integrity-lab/files/example.txt

Create a baseline:

    bash projects/file-integrity-check/file-integrity-check.sh \
      --create /tmp/integrity-lab/state/baseline.sha256 /tmp/integrity-lab/files

Check it:

    bash projects/file-integrity-check/file-integrity-check.sh \
      --check /tmp/integrity-lab/state/baseline.sha256 /tmp/integrity-lab/files

Now edit example.txt and repeat the check. The script returns 1 when differences are found, 0 when the snapshot matches, and 2 for usage or execution errors.

## Important limits

Keep the baseline outside the directory being monitored. If an attacker can alter both the files and the baseline, this check can be fooled; store a trusted baseline somewhere with stronger access controls. A checksum detects content changes, but does not explain whether they were expected. Review changes before taking action.

## Exercise

Add an ignore list for known volatile files. Make the test cover a new file, a modified file, and a removed file.
