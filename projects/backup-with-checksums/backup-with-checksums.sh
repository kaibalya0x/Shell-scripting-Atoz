#!/usr/bin/env bash
# Create a compressed backup and SHA-256 manifest; source files stay unchanged.
set -o nounset -o pipefail

src=''; dest=''
while (($#)); do
    case $1 in
        --source|--destination)
            (($# >= 2)) || { echo "Missing value for $1" >&2; exit 2; }
            if [[ $1 == --source ]]; then src=$2; else dest=$2; fi
            shift 2 ;;
        --help|-h) echo "Usage: $0 --source DIR --destination EXISTING_DIR"; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; exit 2 ;;
    esac
done
[[ -n $src && -n $dest && -d $src && -d $dest ]] || { echo "Source and destination must be existing directories." >&2; exit 2; }
src=$(cd -- "$src" && pwd -P) || exit 2
dest=$(cd -- "$dest" && pwd -P) || exit 2
[[ $src != / ]] || { echo "Refusing to back up filesystem root." >&2; exit 2; }
case "$dest/" in "$src/"*) echo "Destination must be outside source." >&2; exit 2 ;; esac
command -v tar >/dev/null 2>&1 || { echo "tar is required." >&2; exit 2; }
if command -v sha256sum >/dev/null 2>&1; then hash_tool=sha256sum
elif command -v shasum >/dev/null 2>&1; then hash_tool=shasum
else echo "sha256sum or shasum is required." >&2; exit 2; fi
stamp=$(date '+%Y%m%d-%H%M%S')
archive="$dest/backup-$stamp.tar.gz"
manifest="$archive.sha256"
[[ ! -e $archive && ! -e $manifest ]] || { echo "Backup name already exists; retry shortly." >&2; exit 1; }
if ! tar -czf "$archive" -C "$(dirname -- "$src")" -- "$(basename -- "$src")"; then
    rm -f -- "$archive"; echo "Backup failed; partial archive removed." >&2; exit 1
fi
if [[ $hash_tool == sha256sum ]]; then
    (cd -- "$dest" && sha256sum "$(basename -- "$archive")" > "$(basename -- "$manifest")")
else
    (cd -- "$dest" && shasum -a 256 "$(basename -- "$archive")" > "$(basename -- "$manifest")")
fi || { rm -f -- "$manifest"; echo "Could not write checksum manifest." >&2; exit 1; }
echo "Archive: $archive"
echo "Checksum: $manifest"
