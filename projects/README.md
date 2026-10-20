# Practical projects

Build these in order. Each one reinforces several lessons at once. Begin inside a disposable directory and read the script before running it on a machine you depend on.

| Project | Skills practised | Guide |
|---|---|---|
| Disk-space monitor | command substitution, thresholds, exit codes, optional notification | [Open guide](disk-space-monitor/README.md) |
| Archive old files | find, date filters, quoting, dry-run | [Open guide](archive-old-files/README.md) |
| System health report | functions, commands, redirection, reports | [Open guide](system-health-report/README.md) |
| Log keyword review | grep, counting, error handling, privacy | [Open guide](log-keyword-review/README.md) |
| Backup with checksums | archive creation, manifests, verification | [Open guide](backup-with-checksums/README.md) |
| File integrity check | SHA-256 manifests, diff, change detection | [Open guide](file-integrity-check/README.md) |
| TLS certificate expiry | OpenSSL, date arithmetic, alert thresholds | [Open guide](certificate-expiry-check/README.md) |
| Service status | loops, validation, exit codes, systemctl | [Open guide](service-status/README.md) |

## Capstone: admin toolkit

Build a small Linux admin toolkit with subcommands such as disk, health, log-summary, and backup. Keep each task in a separate function or script. Add argument validation, meaningful status codes, timestamped logs, a dry-run for changes, and tests that use temporary files.

For a real server, decide who owns the script, what permissions it needs, where logs go, how failures alert an operator, and how it will be tested after upgrades. A script that works on one laptop is not automatically production-ready.
