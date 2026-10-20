#!/usr/bin/env bash
# Read-only snapshot of basic host health.
set -o nounset -o pipefail

output=''
force=false
while (($#)); do
    case $1 in
        --output) (($# >= 2)) || { echo "Missing filename for --output." >&2; exit 2; }; output=$2; shift 2 ;;
        --force) force=true; shift ;;
        --help|-h) echo "Usage: $0 [--output FILE] [--force]"; echo "--force allows an existing output file to be overwritten."; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; exit 2 ;;
    esac
done

if [[ -n $output && ( -e $output || -L $output ) && $force != true ]]; then
    echo "Output already exists; choose another path or use --force: $output" >&2
    exit 2
fi

report() {
    echo "System health report"
    echo "Generated: $(date '+%F %T %Z')"
    echo "Hostname: $(hostname 2>/dev/null || echo unknown)"
    echo
    echo "-- Uptime --"
    if command -v uptime >/dev/null 2>&1; then uptime; else echo "uptime command unavailable"; fi
    echo
    echo "-- Filesystems --"
    df -hP || return 1
    echo
    echo "-- Memory --"
    if command -v free >/dev/null 2>&1; then free -h
    elif [[ -r /proc/meminfo ]]; then head -n 5 /proc/meminfo
    else echo "Memory information unavailable"; fi
}

if [[ -n $output ]]; then
    report > "$output" || { echo "Report generation failed; check $output." >&2; exit 1; }
    echo "Report written to $output"
else
    report
fi
