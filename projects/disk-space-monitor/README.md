# Project 1 — Disk-space monitor

This script checks the percentage of space used on a selected filesystem and prints a status. It can optionally call a mail command when usage reaches a configured threshold.

## Run it

From the repository root:

    bash projects/disk-space-monitor/disk-space-monitor.sh --help
    bash projects/disk-space-monitor/disk-space-monitor.sh --path /

To test without relying on the machine's actual disk usage, provide a sample percentage:

    bash projects/disk-space-monitor/disk-space-monitor.sh --usage 91 --warning 80 --critical 90

No email is sent unless you explicitly request notification and configure a recipient.

## Example

    CRITICAL: usage is 91% (warning 80%, critical 90%)

## Email note

A working mail command and a configured mail transfer service are needed for delivery. Having the executable installed does not guarantee the message will arrive. Start with console output, then send a test to an address you control and verify delivery. Do not hardcode email credentials.

## Exercise

Add a configurable mount point. Test at 50%, 80%, and 95% usage. Make sure invalid percentages are rejected and notification failures do not get reported as successful deliveries.

## Production considerations

This is a teaching monitor. A production solution should account for network filesystems, inode exhaustion, mount points, alert deduplication, mail queue failures, and the effect of containers on what df reports.
