#!/usr/bin/env bash
# Count lines matching common warning/error keywords in a readable log.
set -o nounset -o pipefail

if (($# != 1)); then echo "Usage: $0 LOG_FILE" >&2; exit 2; fi
file=$1
[[ -f $file && -r $file ]] || { echo "Not a readable regular file: $file" >&2; exit 2; }

for word in ERROR WARN FAILED denied; do
    if count=$(grep -Eic -- "$word" "$file"); then
        :
    else
        result=$?
        if (( result == 1 )); then count=0
        else echo "Could not read/search log: $file" >&2; exit 1
        fi
    fi
    printf '%-8s %s matching lines\n' "$word" "$count"
done
