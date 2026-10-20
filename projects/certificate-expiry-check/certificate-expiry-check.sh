#!/usr/bin/env bash
# Check a TLS certificate's expiry on a host you are authorized to assess.
set -o nounset -o pipefail

host=''; port=443; warning=30
while (($#)); do
    case $1 in
        --host|--port|--warning-days)
            (($# >= 2)) || { echo "Missing value for $1" >&2; exit 2; }
            case $1 in --host) host=$2 ;; --port) port=$2 ;; --warning-days) warning=$2 ;; esac
            shift 2 ;;
        --help|-h) echo "Usage: $0 --host HOST [--port 1..65535] [--warning-days N]"; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; exit 2 ;;
    esac
done
[[ $host =~ ^[A-Za-z0-9.-]+$ && $host != .* && $host != *. && $host != *..* ]] || { echo "Provide a valid DNS hostname." >&2; exit 2; }
if ! [[ $port =~ ^[0-9]{1,5}$ ]] || (( 10#$port < 1 || 10#$port > 65535 )); then
    echo "Port must be 1..65535." >&2
    exit 2
fi
[[ $warning =~ ^[0-9]{1,6}$ ]] || { echo "Warning days must be a non-negative integer." >&2; exit 2; }
for cmd in openssl timeout date; do command -v "$cmd" >/dev/null 2>&1 || { echo "$cmd is required." >&2; exit 2; }; done
end_line=$(timeout 12 openssl s_client -connect "$host:$port" -servername "$host" </dev/null 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null) || {
    echo "Could not retrieve a certificate from $host:$port." >&2; exit 2;
}
expiry=${end_line#notAfter=}
expiry_epoch=$(date -d "$expiry" +%s) || { echo "Could not parse certificate expiry." >&2; exit 2; }
now=$(date +%s)
days_left=$(( (expiry_epoch - now + 86399) / 86400 ))
echo "Host: $host:$port"
echo "Expiry: $expiry"
echo "Days remaining: $days_left"
if (( expiry_epoch <= now )); then echo "EXPIRED" >&2; exit 1; fi
if (( days_left <= warning )); then echo "WARNING: within $warning-day window." >&2; exit 1; fi
echo "OK: outside warning window."
