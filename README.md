# Shell Scripting A to Z

A practical, learn-by-doing Bash guide for people learning Linux administration, automation, and defensive cybersecurity. The goal is to understand what each command does, why it is written that way, and how to test it without breaking your machine.

## Start here

1. Read the learning roadmap in `docs/ROADMAP.md`.
2. Set up Bash and tools using `docs/SETUP.md`.
3. Work through lessons in order.
4. Try the exercises before looking up answers.
5. Build something practical from `projects/README.md`.
6. Run the checks before sharing a change.

## Course map

| Stage | Topics | Practical outcome |
|---|---|---|
| 1 | shell, terminal, shebang, running a script | Run a small script and understand output |
| 2 | variables, quoting, arrays, strings, user input | Handle text safely |
| 3 | arithmetic, conditions, logical operators, loops | Make decisions and repeat work |
| 4 | functions, arguments, exit codes | Build reusable command-line tools |
| 5 | stdin/stdout/stderr, pipes, redirection, `/dev/null` | Control where data and errors go |
| 6 | files, permissions, `find`, `grep`, `sed`, `awk`, logs | Inspect a Linux host |
| 7 | logging, debugging, validation, ShellCheck, tests | Make scripts easier to maintain |
| 8 | monitoring, archiving, backups, reports | Apply the concepts to admin tasks |

## Lessons

- [01 — Your first script](lessons/01-first-script/README.md)
- [02 — Variables and quoting](lessons/02-variables-and-quoting/README.md)
- [03 — Input, strings, and arrays](lessons/03-input-strings-arrays/README.md)
- [04 — Arithmetic and conditions](lessons/04-arithmetic-and-conditions/README.md)
- [05 — Loops and functions](lessons/05-loops-and-functions/README.md)
- [06 — Arguments and exit codes](lessons/06-arguments-and-exit-codes/README.md)
- [07 — Streams, pipes, and `/dev/null`](lessons/07-streams-pipes-dev-null/README.md)
- [08 — Files, logs, and text tools](lessons/08-files-logs-text-tools/README.md)
- [09 — Logging, debugging, and safer scripts](lessons/09-logging-debugging-safety/README.md)

## Projects

See [the project index](projects/README.md) for eight practical projects: disk-space alerts, safe archiving, system health reports, log review, checksum backups, file integrity checks, TLS certificate expiry, and service status.

## Run an example

```bash
bash lessons/01-first-script/hello.sh
chmod u+x lessons/01-first-script/hello.sh
./lessons/01-first-script/hello.sh
```

A Linux environment is recommended. On Windows, use WSL or a Linux VM. The lessons target Bash 4+ where practical; check each project README for dependencies and platform differences.

## Safety notes

- Do not run unfamiliar scripts with `sudo` just to make an error go away.
- Use a temporary lab directory while learning file operations.
- Read scripts that delete, move, change permissions, or modify services before running them.
- Use dry-run modes for operations that could change data.
- Do not commit passwords, tokens, private logs, or real user data.
- Only inspect systems and logs you own or are authorized to administer.
- `/dev/null` discards writes; it is not a backup or an undo mechanism.

## Checks

```bash
shellcheck lessons/*/*.sh projects/*/*.sh tests/*.sh
bash tests/run-tests.sh
```

## Contribution and references

See [CONTRIBUTING.md](CONTRIBUTING.md). Useful references: [GNU Bash manual](https://www.gnu.org/software/bash/manual/bash.html), [ShellCheck wiki](https://www.shellcheck.net/wiki/), [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html), [OWASP OS Command Injection Defense Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/OS_Command_Injection_Defense_Cheat_Sheet.html), and [GitHub Actions documentation](https://docs.github.com/en/actions).

MIT licensed; see [LICENSE](LICENSE).