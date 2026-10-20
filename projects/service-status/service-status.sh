#!/usr/bin/env bash
# Read-only status checks for systemd service units.
set -o nounset
set -o pipefail

if (($# == 0)) || [[ $1 == --help || $1 == -h ]]; then
    printf 'Usage: %s SERVICE_NAME [SERVICE_NAME ...]\n' "$0"
    printf 'Reports status only; it never starts or stops services.\n'
    exit $(( $# == 0 ? 2 : 0 ))
fi

command -v systemctl >/dev/null 2>&1 || {
    printf 'systemctl is not available on this host.\n' >&2
    exit 2
}

overall_status=0
for service in "$@"; do
    [[ $service =~ ^[A-Za-z0-9_.@:-]+$ ]] || {
        printf 'Skipping invalid unit name: %s\n' "$service" >&2
        overall_status=2
        continue
    }

    if systemctl is-active --quiet "$service"; then
        printf 'ACTIVE   %s\n' "$service"
    else
        state=$(systemctl is-active "$service" 2>/dev/null || true)
        [[ -n $state ]] || state=inactive-or-unknown
        printf '%-8s %s\n' "$state" "$service"
        overall_status=1
    fi
done

exit "$overall_status"
