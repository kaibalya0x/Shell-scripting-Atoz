#!/usr/bin/env bash
# Read the expiry date of a TLS certificate presented by a host.
set -o nounset
set -o pipefail

host=''
port=443
warning_days=30

usage() {
    printf 'Usage: %s --host HOST [--port PORT] [--warning-days DAYS]\n' "$0"
}

while (($#)); do
    case "$1" in
        --host) (($# >= 2)) || { usage >&2; exit 2; }; host=$2; shift 2 ;;
        --port) (($# >= 2)) || { usage >&2; exit 2; }; port=$2; shift 2 ;;
        --warning-days) (($# >= 2)) || { usage >&2; exit 2; }; warning_days=$2; shift 2 ;;
        --help|-h) usage; exit 0 ;;
        *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
done

[[ $host =~ ^[A-Za-z0-9.-]+$ ]] || {
    printf 'Provide a hostname containing only letters, digits, dots, and hyphens.\n' >&2
    exit 2
}
if ! [[ $port =~ ^[0-9]+$ ]] || (( port < 1 || port > 65535 )); then
    printf 'Port must be an integer from 1 to 65535.\n' >&2
    exit 2
fi
[[ $warning_days =~ ^[0-9]+$ ]] || {
    printf 'Warning days must be a non-negative integer.\n' >&2
    exit 2
}
command -v openssl >/dev/null 2>&1 || { printf 'OpenSSL is required.\n' >&2; exit 2; }
command -v timeout >/dev/null 2>&1 || { printf 'The timeout command is required.\n' >&2; exit 2; }

end_line=$(timeout 12 openssl s_client -connect "$host:$port" -servername "$host" -showcerts \
    </dev/null 2>/dev/null | openssl x509 -noout -enddate) || {
    printf 'Could not retrieve a certificate from %s:%s.\n' "$host" "$port" >&2
    exit 2
}

expiry=${end_line#notAfter=}
expiry_epoch=$(date -d "$expiry" +%s) || {
    printf 'Could not parse certificate expiry date: %s\n' "$expiry" >&2
    exit 2
}
now=$(date +%s)
if (( expiry_epoch <= now )); then
    printf 'EXPIRED: certificate for %s expired at %s\n' "$host" "$expiry" >&2
    exit 1
fi

days_left=$(( (expiry_epoch - now + 86399) / 86400 ))
printf 'Host: %s:%s\nExpiry: %s\nDays remaining: %s\n' "$host" "$port" "$expiry" "$days_left"

if (( days_left <= warning_days )); then
    printf 'WARNING: certificate is within the %s-day warning window.\n' "$warning_days" >&2
    exit 1
fi

printf 'OK: certificate is outside the warning window.\n'
exit 0
