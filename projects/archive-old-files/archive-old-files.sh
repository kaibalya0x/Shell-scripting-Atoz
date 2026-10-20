#!/usr/bin/env bash
# Create a tar.gz of files older than N days; never delete source files.
set -o nounset
set -o pipefail

usage() {
    cat <<'HELP'
Usage: archive-old-files.sh --source DIR --destination EXISTING_DIR [--days N] [--apply]
Dry-run is the default. --apply creates an archive but does not remove originals.
The destination must exist and must not be inside the source directory.
HELP
}

source_dir=''
destination_dir=''
days=30
apply=false

while (($#)); do
    case "$1" in
        --source) (($# >= 2)) || { usage >&2; exit 2; }; source_dir=$2; shift 2 ;;
        --destination) (($# >= 2)) || { usage >&2; exit 2; }; destination_dir=$2; shift 2 ;;
        --days) (($# >= 2)) || { usage >&2; exit 2; }; days=$2; shift 2 ;;
        --apply) apply=true; shift ;;
        --help|-h) usage; exit 0 ;;
        *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
done

[[ -n $source_dir && -n $destination_dir ]] || { usage >&2; exit 2; }
[[ $days =~ ^[0-9]+$ ]] || { printf 'Days must be a non-negative integer.\n' >&2; exit 2; }
[[ -d $source_dir ]] || { printf 'Source is not a directory: %s\n' "$source_dir" >&2; exit 2; }
[[ -d $destination_dir ]] || { printf 'Destination must already exist: %s\n' "$destination_dir" >&2; exit 2; }

source_abs=$(cd -- "$source_dir" && pwd -P) || exit 2
destination_abs=$(cd -- "$destination_dir" && pwd -P) || exit 2

case "$destination_abs/" in
    "$source_abs/"*) printf 'Destination must not be inside the source directory.\n' >&2; exit 2 ;;
esac
[[ $source_abs != / ]] || { printf 'Refusing to archive from filesystem root.\n' >&2; exit 2; }

mapfile -d '' files < <(find "$source_abs" -type f -mtime "+$days" -print0)
if (("${#files[@]}" == 0)); then
    printf 'No files older than %s days were found.\n' "$days"
    exit 0
fi

printf 'Candidates (%s):\n' "${#files[@]}"
printf '  %s\n' "${files[@]}"

if [[ $apply != true ]]; then
    printf '\nDry run only; no archive created and no source files removed.\n'
    printf 'Review this list, then re-run with --apply to create the archive.\n'
    exit 0
fi

archive="$destination_abs/archive-$(date '+%Y%m%d-%H%M%S').tar.gz"
relative_files=()
for file in "${files[@]}"; do
    relative_files+=("${file#"$source_abs"/}")
done

if tar -czf "$archive" -C "$source_abs" -- "${relative_files[@]}"; then
    printf 'Archive created: %s\n' "$archive"
    printf 'Original files were left untouched. Verify the archive before any cleanup.\n'
else
    printf 'Archive creation failed.\n' >&2
    exit 1
fi
