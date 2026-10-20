# 10 — Scheduling and automation

A script becomes automation when it runs without someone typing the command each time. Cron is common for simple schedules; systemd timers are useful on systemd-based Linux hosts. Start by running the script manually and checking its exit status before scheduling it.

## First, practise manually

Use an absolute path when you schedule a script. Cron normally runs with a smaller environment than your interactive terminal, so do not assume PATH or your working directory will match your shell session.

    /usr/bin/bash /home/learner/Shell-scripting-Atoz/projects/system-health-report/system-health-report.sh

Replace the example path with the actual path on your machine. Check that the report looks right.

## Cron basics

Show your current jobs:

    crontab -l

Edit your personal crontab:

    crontab -e

A line with five time fields is followed by a command. This example runs a read-only health report every day at 08:00; change both the path and output destination before using it.

    0 8 * * * /usr/bin/bash /home/learner/Shell-scripting-Atoz/projects/system-health-report/system-health-report.sh >> /home/learner/health-report.log 2>&1

The output is appended to a log. Keep log growth in mind; arrange log rotation or use a reporting system rather than letting a file grow forever.

## Avoid overlapping runs

If a job can take longer than its schedule interval, two copies may run at the same time. On Linux systems with flock installed, you can use a lock:

    */5 * * * * /usr/bin/flock -n /tmp/disk-check.lock /usr/bin/bash /home/learner/Shell-scripting-Atoz/projects/disk-space-monitor/disk-space-monitor.sh --path / >> /home/learner/disk-check.log 2>&1

This is an example only. Edit paths, permissions, thresholds, and log destinations for your environment. A nonzero monitor exit status may be meaningful, so do not confuse a warning or critical result with a script crash.

## Environment differences

- Use full paths for scripts and important utilities when appropriate.
- Set a deliberate working directory inside the script if relative paths are used.
- Redirect stdout and stderr somewhere you will actually inspect.
- Decide who owns the job and what permissions it needs.
- Test failure behaviour. A scheduled script should fail clearly rather than quietly hiding every error.
- Do not schedule an unfamiliar script with root privileges just to make permissions problems disappear.

## Cron or a systemd timer?

Cron is straightforward for clock-based tasks. systemd timers can integrate with a service unit, execution restrictions, and journaling. The right choice depends on how the host is managed; check the distribution's documentation.

## Try it yourself

1. Schedule a report every day in a lab VM, using your own absolute path.
2. Check the cron service and confirm that the log was updated.
3. Make the script write a clear error when an input path is missing.
4. Remove the test job when you are finished.

## Common mistake

A job that works from your terminal can fail under cron because of a different PATH, permissions, current directory, or environment. Test the exact command with the same user that will run it.
