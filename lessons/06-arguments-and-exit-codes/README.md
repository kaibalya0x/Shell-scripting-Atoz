# 06 — Arguments and exit codes

Arguments let a user provide data when starting a script.

    echo "Script name: $0"
    echo "First argument: ${1-}"
    echo "Argument count: $#"
    echo 'All arguments, preserving each argument:'
    printf ' - %s\n' "$@"

Run a saved version with:

    bash args.sh "monthly report.txt" /tmp

"$@" is normally the right way to forward all positional arguments. Avoid unquoted $@ when preserving argument boundaries matters.

## Validate required input

    #!/usr/bin/env bash
    set -o nounset

    if (( $# != 1 )); then
        printf 'Usage: %s PATH\n' "$0" >&2
        exit 2
    fi

    target=$1
    if [[ ! -e "$target" ]]; then
        printf 'Error: path does not exist: %s\n' "$target" >&2
        exit 1
    fi

    echo "Path exists: $target"

Exit status conventions vary by program, but zero generally means success and nonzero means an error or a particular condition. Here, status 2 indicates incorrect usage and 1 indicates a missing path.

## Understanding grep exit status

grep returns 0 when it finds a match, 1 when there is no match, and a higher status when an error occurs.

    if grep -q 'ERROR' app.log; then
        echo 'An ERROR line was found'
    else
        status=$?
        if (( status == 1 )); then
            echo 'No ERROR line was found'
        else
            echo 'grep could not complete' >&2
        fi
    fi

## Try it yourself

1. Require exactly two arguments and print usage otherwise.
2. Return status 2 for invalid usage.
3. Distinguish a missing file from an empty file.
4. Run echo $? after successful and failing commands.

## Common mistake

Do not treat every nonzero status as the same situation. Check the tool's documentation when the distinction matters.
