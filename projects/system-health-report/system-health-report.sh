#!/usr/bin/env bash
# Collect a small, read-only host status report.
set -o nounset
set -o pipefail

output=''

while (($#)); do
    case "$1" in
        --output)
            (($# >= 2)) || { printf 'Missing value for --output\n' >&2; exit 2; }
            output=$2
            shift 2
            ;;
        --help|-h)
            printf 'Usage: %s [--output FILE]\n' "$0"
            exit 0
            ;;
        *)
            printf 'Unknown argument: %s\n' "$1" >&2
            exit 2
            ;;
    esac
done

generate_report() {
    printf 'System health report\n'
    printf 'Generated: %s\n' "$(date '+%F %T %Z')"
    printf 'Hostname: %s\n' "$(hostname 2>/dev/null || printf 'unknown')"
    printf '\n-- Uptime --\n'
    uptime 2>&1 || printf 'uptime information unavailable\n'
    printf '\n-- Filesystem usage --\n'
    df -hP 2>&1 || printf 'df information unavailable\n'
    printf '\n-- Memory --\n'
    if command -v free >/dev/null 2>&1; then
        free -h
    elif [[ -r /proc/meminfo ]]; then
        sed -n '1,5p' /proc/meminfo
    else
        printf 'Memory information unavailable\n'
    fi
}

if [[ -n $output ]]; then
    if generate_report > "$output"; then
        printf 'Report written to %s\n' "$output"
    else
        printf 'Could not write report to %s\n' "$output" >&2
        exit 1
    fi
else
    generate_report
fi
