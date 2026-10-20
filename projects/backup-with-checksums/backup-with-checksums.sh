#!/usr/bin/env bash
# Create a timestamped tar.gz and SHA-256 manifest; source files are not changed.
set -o nounset
set -o pipefail

source_dir=''
destination_dir=''

while (($#)); do
    case "$1" in
        --source) (($# >= 2)) || { printf 'Missing source path\n' >&2; exit 2; }; source_dir=$2; shift 2 ;;
        --destination) (($# >= 2)) || { printf 'Missing destination path\n' >&2; exit 2; }; destination_dir=$2; shift 2 ;;
        --help|-h) printf 'Usage: %s --source DIR --destination DIR\n' "$0"; exit 0 ;;
        *) printf 'Unknown argument: %s\n' "$1" >&2; exit 2 ;;
    esac
done

[[ -n $source_dir && -n $destination_dir ]] || {
    printf 'Both --source and --destination are required.\n' >&2
    exit 2
}
[[ -d $source_dir ]] || { printf 'Source directory not found.\n' >&2; exit 2; }
[[ -d $destination_dir ]] || { printf 'Destination directory must already exist.\n' >&2; exit 2; }

source_abs=$(cd -- "$source_dir" && pwd -P) || exit 2
destination_abs=$(cd -- "$destination_dir" && pwd -P) || exit 2
[[ $source_abs != / ]] || { printf 'Refusing to back up filesystem root.\n' >&2; exit 2; }
case "$destination_abs/" in
    "$source_abs/"*) printf 'Destination must not be inside source.\n' >&2; exit 2 ;;
esac

stamp=$(date '+%Y%m%d-%H%M%S')
archive="$destination_abs/backup-$stamp.tar.gz"
if ! tar -czf "$archive" -C "$(dirname -- "$source_abs")" -- "$(basename -- "$source_abs")"; then
    printf 'Backup archive creation failed.\n' >&2
    rm -f -- "$archive"
    exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
    (cd -- "$destination_abs" && sha256sum "$(basename -- "$archive")" > "$(basename -- "$archive").sha256")
elif command -v shasum >/dev/null 2>&1; then
    (cd -- "$destination_abs" && shasum -a 256 "$(basename -- "$archive")" > "$(basename -- "$archive").sha256")
else
    printf 'Archive created, but no SHA-256 tool was found.\n' >&2
    exit 1
fi

printf 'Archive: %s\nChecksum: %s.sha256\n' "$archive" "$archive"
