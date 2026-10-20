#!/usr/bin/env bash
# Report filesystem usage, with an optional test value and optional email.
set -o nounset
set -o pipefail

usage() {
    cat <<'HELP'
Usage:
  disk-space-monitor.sh [--path PATH] [--usage PERCENT]
                        [--warning PERCENT] [--critical PERCENT]
                        [--email ADDRESS] [--help]

--path PATH       Filesystem path to inspect (default: /)
--usage PERCENT   Use a sample percentage for testing; skips df
--warning N       Warning threshold (default: 80)
--critical N      Critical threshold (default: 90)
--email ADDRESS   Send an alert with the mail command when warning/critical
--help            Show this help

Exit status: 0=OK, 1=warning, 2=critical, 3=usage/check error.
No email is sent unless --email is specified.
HELP
}

path=/
sample_usage=''
warning=80
critical=90
email=''

is_percent() {
    [[ $1 =~ ^([0-9]|[1-9][0-9]|100)$ ]]
}

while (($#)); do
    case "$1" in
        --path)
            (($# >= 2)) || { printf 'Missing value for --path\n' >&2; exit 3; }
            path=$2
            shift 2
            ;;
        --usage)
            (($# >= 2)) || { printf 'Missing value for --usage\n' >&2; exit 3; }
            sample_usage=$2
            shift 2
            ;;
        --warning)
            (($# >= 2)) || { printf 'Missing value for --warning\n' >&2; exit 3; }
            warning=$2
            shift 2
            ;;
        --critical)
            (($# >= 2)) || { printf 'Missing value for --critical\n' >&2; exit 3; }
            critical=$2
            shift 2
            ;;
        --email)
            (($# >= 2)) || { printf 'Missing value for --email\n' >&2; exit 3; }
            email=$2
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            printf 'Unknown argument: %s\n' "$1" >&2
            usage >&2
            exit 3
            ;;
    esac
done

if ! is_percent "$warning" || ! is_percent "$critical"; then
    printf 'Thresholds must be whole numbers from 0 to 100.\n' >&2
    exit 3
fi
(( warning <= critical )) || {
    printf 'Warning threshold must not exceed critical threshold.\n' >&2
    exit 3
}

if [[ -n $sample_usage ]]; then
    is_percent "$sample_usage" || {
        printf 'Sample usage must be a whole number from 0 to 100.\n' >&2
        exit 3
    }
    used=$sample_usage
else
    [[ -e $path ]] || {
        printf 'Path does not exist: %s\n' "$path" >&2
        exit 3
    }
    df_output=$(df -P "$path") || {
        printf 'Could not read filesystem usage for: %s\n' "$path" >&2
        exit 3
    }
    used=$(awk 'NR == 2 { gsub(/%/, "", $5); print $5 }' <<< "$df_output")
    is_percent "$used" || {
        printf 'Could not parse df output for: %s\n' "$path" >&2
        exit 3
    }
fi

status=0
label=OK
if (( used >= critical )); then
    status=2
    label=CRITICAL
elif (( used >= warning )); then
    status=1
    label=WARNING
fi

message="$label: usage is ${used}% (warning ${warning}%, critical ${critical}%)"
printf '%s\n' "$message"

if (( status > 0 )) && [[ -n $email ]]; then
    if [[ $email == *$'\n'* || $email == -* || $email != *@* ]]; then
        printf 'Provide a valid recipient address.\n' >&2
        exit 3
    fi
    if ! command -v mail >/dev/null 2>&1; then
        printf 'Alert requested but the mail command is not installed.\n' >&2
        exit 3
    fi
    if ! printf '%s\n' "$message" | mail -s "Disk space $label" "$email"; then
        printf 'Alert command failed; email delivery was not confirmed.\n' >&2
        exit 3
    fi
fi

exit "$status"
