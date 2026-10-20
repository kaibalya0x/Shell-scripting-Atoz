#!/usr/bin/env bash
# Create or verify a SHA-256 manifest for files in a directory.
set -o nounset -o pipefail

usage() { echo "Usage: $0 --create BASELINE_FILE DIRECTORY"; echo "       $0 --check BASELINE_FILE DIRECTORY"; }
(($# == 3)) || { usage >&2; exit 2; }
mode=$1; baseline=$2; target=$3
[[ $mode == --create || $mode == --check ]] || { usage >&2; exit 2; }
[[ -d $target ]] || { echo "Target must be an existing directory." >&2; exit 2; }
target=$(cd -- "$target" && pwd -P) || exit 2
[[ $target != / ]] || { echo "Refusing to scan filesystem root." >&2; exit 2; }
parent=$(dirname -- "$baseline"); name=$(basename -- "$baseline")
[[ -d $parent ]] || { echo "Baseline parent directory must exist." >&2; exit 2; }
parent=$(cd -- "$parent" && pwd -P) || exit 2
baseline="$parent/$name"
case "$baseline" in "$target"/*) echo "Store baseline outside the target directory." >&2; exit 2 ;; esac
[[ $baseline != "$target" ]] || { echo "Baseline cannot be the target directory." >&2; exit 2; }
command -v sha256sum >/dev/null 2>&1 || { echo "sha256sum is required." >&2; exit 2; }
make_manifest() {
    local output=$1
    local file
    local list
    list=$(mktemp) || return 1
    if ! find "$target" -type f -print0 | sort -z > "$list"; then
        rm -f -- "$list"
        return 1
    fi
    : > "$output" || { rm -f -- "$list"; return 1; }
    local status=0
    while IFS= read -r -d '' file; do
        if ! sha256sum -- "$file" >> "$output"; then
            status=1
            break
        fi
    done < "$list"
    rm -f -- "$list"
    return "$status"
}
if [[ $mode == --create ]]; then
    [[ ! -e $baseline && ! -L $baseline ]] || { echo "Baseline already exists; choose a new path." >&2; exit 2; }
    temp=$(mktemp "$parent/.manifest.XXXXXX") || { echo "Cannot create temporary manifest." >&2; exit 2; }
    trap 'rm -f -- "$temp"' EXIT
    make_manifest "$temp" || { echo "Could not create a complete manifest." >&2; exit 2; }
    mv -- "$temp" "$baseline" || { echo "Could not save baseline." >&2; exit 2; }
    trap - EXIT
    echo "Baseline saved: $baseline"
    exit 0
fi
[[ -f $baseline && ! -L $baseline ]] || { echo "Baseline must be an existing regular file." >&2; exit 2; }
current=$(mktemp) || { echo "Cannot create temporary manifest." >&2; exit 2; }
trap 'rm -f -- "$current"' EXIT
make_manifest "$current" || { echo "Could not create current manifest." >&2; exit 2; }
if diff -u -- "$baseline" "$current"; then echo "PASS: no file changes detected."; exit 0
else
    result=$?
    if (( result == 1 )); then echo "CHANGED: review differences above." >&2; exit 1; fi
    echo "Could not compare manifests." >&2; exit 2
fi
