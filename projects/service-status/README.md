# Project 8 — Service and process status

This project is a read-only check for services managed by systemd. It asks systemctl whether each named unit is active; it does not start, stop, or restart anything.

## Run it

    bash projects/service-status/service-status.sh ssh cron

The exact service names available depend on your Linux distribution. You can try a service name you know exists on your own test machine. A missing or inactive service is reported in the output.

## Safety notes

No sudo is required for ordinary status checks on most systems. Avoid adding automatic restarts until you have carefully considered what the service does and how recovery should work.

## Exercise

Add a process-name option using pgrep, then test the script with an active, inactive, and unknown service.
