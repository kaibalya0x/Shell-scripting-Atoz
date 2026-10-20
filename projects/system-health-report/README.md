# Project 3 — System health report

This script collects read-only snapshots: timestamp, hostname, uptime, filesystem usage, and memory information where available. It writes to standard output unless you provide --output FILE.

## Run it

    bash projects/system-health-report/system-health-report.sh
    bash projects/system-health-report/system-health-report.sh --output /tmp/health-report.txt

When using --output, the script overwrites that file. Choose a new path or back up the file first.

## Exercise

Add a section showing the five processes using the most CPU, using a tool available on your distribution. Avoid printing sensitive command-line arguments in a report that may be shared.
