#!/usr/bin/env bash
# Read filesystem usage, or accept --usage for a safe test.
set -o nounset -o pipefail

usage() {
    echo "Usage: $0 [--path PATH] [--usage 0..100] [--warning N] [--critical N] [--email ADDRESS]"
    echo "Defaults: path=/ warning=80 critical=90. Exit: 0=OK, 1=warning, 2=critical, 3=error."
}

path=/
sample=''
sample_set=false
warning=80
critical=90
email=''

while (($#)); do
    case $1 in
        --path|--usage|--warning|--critical|--email)
            (($# >= 2)) || { echo "Missing value for $1" >&2; exit 3; }
            case $1 in
                --path) path=$2 ;;
                --usage) sample=$2; sample_set=true ;;
                --warning) warning=$2 ;;
                --critical) critical=$2 ;;
                --email) email=$2 ;;
            esac
            shift 2 ;;
        --help|-h) usage; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; usage >&2; exit 3 ;;
    esac
done

is_percent() { [[ $1 =~ ^(100|[1-9]?[0-9])$ ]]; }
if ! is_percent "$warning" || ! is_percent "$critical" || (( warning > critical )); then
    echo "Thresholds must be 0..100, and warning must not exceed critical." >&2
    exit 3
fi

if [[ $sample_set == true ]]; then
    is_percent "$sample" || { echo "--usage must be a whole number from 0 to 100." >&2; exit 3; }
    used=$sample
else
    [[ -e $path ]] || { echo "Path does not exist: $path" >&2; exit 3; }
    used=$(df -P -- "$path" | awk 'NR == 2 { gsub(/%/, "", $5); print $5 }') || {
        echo "Could not read filesystem usage." >&2; exit 3;
    }
    is_percent "$used" || { echo "Could not parse df output." >&2; exit 3; }
fi

status=0
label=OK
if (( used >= critical )); then status=2; label=CRITICAL
elif (( used >= warning )); then status=1; label=WARNING
fi
message="$label: usage is ${used}% (warning ${warning}%, critical ${critical}%)"
echo "$message"

if (( status > 0 )) && [[ -n $email ]]; then
    [[ $email != -* && $email != *$'\n'* && $email == *@* ]] || {
        echo "Provide a valid email recipient." >&2; exit 3;
    }
    command -v mail >/dev/null 2>&1 || { echo "mail command is not installed." >&2; exit 3; }
    echo "$message" | mail -s "Disk space $label" "$email" || {
        echo "Mail command failed; delivery is not confirmed." >&2; exit 3;
    }
fi
exit "$status"
