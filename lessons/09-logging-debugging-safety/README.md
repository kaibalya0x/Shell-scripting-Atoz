# 09 — Logging, debugging, and safer scripts

A script is easier to maintain when it explains what it is doing, fails clearly, and avoids surprising changes.

## Log messages

    log() {
        local level=$1
        shift
        printf '%s [%s] %s\n' "$(date '+%F %T')" "$level" "$*" >&2
    }

    log INFO 'Starting the disk check'
    log WARN 'This is an example warning'

This sends messages to standard error. A caller can redirect stderr to a log file. Do not include passwords, tokens, or unnecessary personal data in logs.

## Debugging

Use Bash trace mode for a short test:

    bash -x script.sh

Trace output may reveal variable values, including secrets. Do not enable it casually in production or when a script processes credentials.

A useful baseline for many scripts is:

    set -o nounset
    set -o pipefail

These options can expose bugs, but they do not replace error handling. The behaviour of set -e has exceptions and context-dependent rules; do not rely on it as a complete error-handling strategy.

## Validate before changing files

- Check required arguments.
- Use clear, quoted paths.
- Make a dry-run mode for potentially destructive work.
- Refuse unexpected directories or dangerous destinations.
- Prefer least privilege.
- Test against temporary fixtures.
- Explain how to recover and what the script changes.

## /dev/null and “de-null”

The device is named /dev/null (pronounced “dev null”). It discards writes. For example, command 2>/dev/null hides error output only. Avoid hiding errors until you have a good reason.

## ShellCheck and tests

    shellcheck path/to/script.sh
    bash tests/run-tests.sh

The goal is not just to make ShellCheck quiet. Understand a warning, fix the cause, or document why an intentional pattern is safe.

## Try it yourself

1. Add timestamps to status messages.
2. Send a diagnostic message to stderr.
3. Reproduce a missing-variable bug, then fix it.
4. Add a dry-run option to a file operation.
