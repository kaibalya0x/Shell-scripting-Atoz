#!/usr/bin/env bash
# Count selected words in a supplied readable text file.
set -o nounset
set -o pipefail

if (($# != 1)); then
    printf 'Usage: %s LOG_FILE\n' "$0" >&2
    exit 2
fi

log_file=$1
[[ -f $log_file && -r $log_file ]] || {
    printf 'Expected a readable regular file: %s\n' "$log_file" >&2
    exit 2
}

for keyword in ERROR WARN FAILED denied; do
    count=$(grep -Eic -- "$keyword" "$log_file") || {
        grep_status=$?
        if (( grep_status != 1 )); then
            printf 'Could not search log file: %s\n' "$log_file" >&2
            exit 1
        fi
        count=0
    }
    printf '%-8s %s\n' "$keyword" "$count"
done
