#!/usr/bin/env bash
# Archive files older than N full days. Never delete originals.
set -o nounset -o pipefail

usage() {
    echo "Usage: $0 --source DIR --destination EXISTING_DIR [--days N] [--apply]"
    echo "Dry-run is the default; --apply creates an archive but keeps source files."
}

src=''
dest=''
days=30
apply=false
while (($#)); do
    case $1 in
        --source|--destination|--days)
            (($# >= 2)) || { usage >&2; exit 2; }
            case $1 in --source) src=$2 ;; --destination) dest=$2 ;; --days) days=$2 ;; esac
            shift 2 ;;
        --apply) apply=true; shift ;;
        --help|-h) usage; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
    esac
done

[[ -n $src && -n $dest && $days =~ ^[0-9]+$ ]] || { usage >&2; exit 2; }
[[ -d $src && -d $dest ]] || { echo "Source and destination must be existing directories." >&2; exit 2; }
src=$(cd -- "$src" && pwd -P) || exit 2
dest=$(cd -- "$dest" && pwd -P) || exit 2
[[ $src != / ]] || { echo "Refusing to archive filesystem root." >&2; exit 2; }
case "$dest/" in "$src/"*) echo "Destination must be outside source." >&2; exit 2 ;; esac

list=$(mktemp) || { echo "Cannot create temporary file." >&2; exit 2; }
trap 'rm -f -- "$list"' EXIT
find "$src" -type f -mtime "+$days" -print0 > "$list" || {
    echo "Could not list source files." >&2; exit 1;
}
mapfile -d '' files < "$list"
(("${#files[@]}" > 0)) || { echo "No files older than $days full days found."; exit 0; }

echo "Candidates: ${#files[@]}"
printf '  %s\n' "${files[@]}"
if [[ $apply != true ]]; then
    echo "Dry run: nothing was archived or deleted. Re-run with --apply after review."
    exit 0
fi

archive="$dest/archive-$(date '+%Y%m%d-%H%M%S').tar.gz"
[[ ! -e $archive ]] || { echo "Archive already exists; try again in a second." >&2; exit 1; }
relative=()
for file in "${files[@]}"; do relative+=("${file#"$src"/}"); done
if tar -czf "$archive" -C "$src" -- "${relative[@]}"; then
    echo "Archive created: $archive"
    echo "Original files were left untouched."
else
    rm -f -- "$archive"
    echo "Archive failed; partial output removed." >&2
    exit 1
fi
