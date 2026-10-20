#!/usr/bin/env bash
# Smoke tests only create files under a disposable temporary directory.
set -o nounset
set -o pipefail

repo_root=$(cd -- "$(dirname -- "$0")/.." && pwd -P)
tmp_dir=$(mktemp -d)
cleanup() {
    rm -rf -- "$tmp_dir"
}
trap cleanup EXIT

pass=0
fail=0

expect_status() {
    local expected=$1
    shift
    local actual=0
    "$@" >/dev/null 2>&1 || actual=$?
    [[ $actual -eq $expected ]]
}

directory_empty() {
    [[ -z $(find "$1" -mindepth 1 -maxdepth 1 -print -quit) ]]
}

disk_check() {
    bash "$repo_root/projects/disk-space-monitor/disk-space-monitor.sh" "$@"
}

archive_check() {
    bash "$repo_root/projects/archive-old-files/archive-old-files.sh" "$@"
}

check() {
    local name=$1
    shift
    if "$@"; then
        printf 'PASS: %s\n' "$name"
        ((pass += 1))
    else
        printf 'FAIL: %s\n' "$name" >&2
        ((fail += 1))
    fi
}

log_report_has_error() {
    bash "$repo_root/projects/log-keyword-review/log-keyword-review.sh" \
        "$repo_root/tests/fixtures/sample.log" > "$tmp_dir/log-report" &&
        grep -q '^ERROR ' "$tmp_dir/log-report"
}

archive_apply_preserves_source() {
    archive_check --source "$tmp_dir/source" --destination "$tmp_dir/archive" --days 7 --apply &&
        [[ -f "$tmp_dir/source/older file.txt" ]] &&
        find "$tmp_dir/archive" -maxdepth 1 -type f -name 'archive-*.tar.gz' -print -quit |
            grep -q .
}

integrity_check() {
    bash "$repo_root/projects/file-integrity-check/file-integrity-check.sh" "$@"
}

integrity_create_baseline() {
    integrity_check --create "$tmp_dir/integrity/state/baseline.sha256" "$tmp_dir/integrity/files"
}

integrity_matches_baseline() {
    integrity_check --check "$tmp_dir/integrity/state/baseline.sha256" "$tmp_dir/integrity/files" >/dev/null
}

check 'disk monitor reports OK' disk_check --usage 40 --warning 80 --critical 90
check 'warning threshold returns status 1' expect_status 1 disk_check --usage 80 --warning 80 --critical 90
check 'critical threshold returns status 2' expect_status 2 disk_check --usage 95 --warning 80 --critical 90
check 'invalid sample is rejected' expect_status 3 disk_check --usage 101
check 'warning above critical is rejected' expect_status 3 disk_check --warning 95 --critical 90
check 'log reviewer counts the fixture' log_report_has_error

mkdir -p "$tmp_dir/source" "$tmp_dir/archive"
printf 'old sample\n' > "$tmp_dir/source/older file.txt"
touch -d '20 days ago' "$tmp_dir/source/older file.txt"

check 'archive defaults to dry-run' expect_status 0 archive_check --source "$tmp_dir/source" --destination "$tmp_dir/archive" --days 7
check 'dry-run leaves destination empty' directory_empty "$tmp_dir/archive"
check 'apply creates archive and keeps source' archive_apply_preserves_source

mkdir -p "$tmp_dir/integrity/files" "$tmp_dir/integrity/state"
printf 'first content\n' > "$tmp_dir/integrity/files/space in name.txt"
check 'integrity baseline is created' integrity_create_baseline
check 'integrity check passes for unchanged files' integrity_matches_baseline
printf 'modified content\n' > "$tmp_dir/integrity/files/space in name.txt"
check 'integrity check reports changes' expect_status 1 integrity_check --check "$tmp_dir/integrity/state/baseline.sha256" "$tmp_dir/integrity/files"

printf '\nResults: %s passed, %s failed\n' "$pass" "$fail"
(( fail == 0 ))
