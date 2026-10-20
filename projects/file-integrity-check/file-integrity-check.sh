#!/usr/bin/env bash
# Create or compare a SHA-256 snapshot for regular files under a directory.
set -o nounset
set -o pipefail

usage() {
    printf 'Usage: %s --create BASELINE_FILE DIRECTORY\n' "$0"
    printf '       %s --check BASELINE_FILE DIRECTORY\n' "$0"
    printf 'Baseline must be outside the directory being monitored.\n'
}

if (($# != 3)); then
    usage >&2
    exit 2
fi

mode=$1
baseline=$2
target=$3

[[ $mode == --create || $mode == --check ]] || { usage >&2; exit 2; }
[[ -d $target ]] || { printf 'Target must be an existing directory.\n' >&2; exit 2; }

target_abs=$(cd -- "$target" && pwd -P) || exit 2
[[ $target_abs != / ]] || { printf 'Refusing to scan filesystem root.\n' >&2; exit 2; }

baseline_parent=$(dirname -- "$baseline")
baseline_name=$(basename -- "$baseline")
[[ -d $baseline_parent ]] || { printf 'Baseline parent directory must exist.\n' >&2; exit 2; }
baseline_parent_abs=$(cd -- "$baseline_parent" && pwd -P) || exit 2
baseline_abs="$baseline_parent_abs/$baseline_name"

case "$baseline_abs" in
    "$target_abs"/*) printf 'Keep the baseline outside the target directory.\n' >&2; exit 2 ;;
esac
[[ $baseline_abs != "$target_abs" ]] || { printf 'Baseline path cannot be the target directory.\n' >&2; exit 2; }

if [[ $mode == --create ]]; then
    temporary="$baseline_abs.tmp.$$"
    trap 'rm -f -- "$temporary"' EXIT
    if ! find "$target_abs" -type f -print0 | sort -z | xargs -0 -r sha256sum > "$temporary"; then
        printf 'Could not generate a complete checksum manifest.\n' >&2
        exit 2
    fi
    if ! mv -- "$temporary" "$baseline_abs"; then
        printf 'Could not save baseline: %s\n' "$baseline_abs" >&2
        exit 2
    fi
    trap - EXIT
    printf 'Baseline written: %s\n' "$baseline_abs"
    exit 0
fi

[[ -f $baseline_abs && ! -L $baseline_abs ]] || {
    printf 'Baseline must be an existing regular file, not a symlink.\n' >&2
    exit 2
}

current=$(mktemp) || { printf 'Could not create temporary manifest.\n' >&2; exit 2; }
trap 'rm -f -- "$current"' EXIT
if ! find "$target_abs" -type f -print0 | sort -z | xargs -0 -r sha256sum > "$current"; then
    printf 'Could not generate the current checksum manifest.\n' >&2
    exit 2
fi

if diff -u -- "$baseline_abs" "$current"; then
    printf 'Integrity check passed: no file changes detected.\n'
    exit 0
else
    diff_status=$?
    if (( diff_status == 1 )); then
        printf 'Integrity differences detected; review the diff above.\n' >&2
        exit 1
    fi
    printf 'Could not compare manifests.\n' >&2
    exit 2
fi
