# 07 — Streams, pipes, and /dev/null

Every process normally has three standard streams:

- stdin (0): input
- stdout (1): ordinary output
- stderr (2): diagnostics and error messages

## Redirect output

    printf 'normal output\n' > normal.txt
    printf 'another line\n' >> normal.txt

A single > replaces a file's contents. >> appends. Be cautious: the wrong target can overwrite useful data.

Separate output and errors:

    some-command >command-output.txt 2>command-errors.txt

To keep both streams in one file in Bash:

    some-command >combined.txt 2>&1

Redirection order matters. Read it from left to right.

## Pipes

A pipe sends one command's standard output to the next command's standard input:

    printf 'INFO started\nERROR permission denied\nINFO finished\n' | grep 'ERROR'

Output:

    ERROR permission denied

A pipeline does not automatically prove every command succeeded. Bash's pipefail option helps expose pipeline failures:

    set -o pipefail

## What is /dev/null?

/dev/null is a special device that discards anything written to it. Reading from it returns end-of-file immediately. Think of it as a sink, not storage.

    printf 'You will not see this line\n' > /dev/null
    printf 'This line is visible\n'

Output:

    This line is visible

To discard only standard error:

    some-command 2>/dev/null

To discard both standard output and standard error in Bash:

    some-command >/dev/null 2>&1

Use this sparingly. Throwing away all output can hide important errors. During learning and troubleshooting, keep messages until you know they are unnecessary.

## Try it yourself

1. Redirect a command's output to a file, then append another line.
2. Pipe several lines into grep.
3. Send stderr to a temporary file.
4. Explain why >/dev/null does not stop a command from running.

## Common mistake

/dev/null does not make an unsafe command safe, undo changes, or save a copy. It only discards the data written to it.
