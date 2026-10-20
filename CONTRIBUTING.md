# Contributing

Thanks for helping make these lessons clearer and more useful.

## What makes a good contribution?

- Fix an inaccurate or confusing explanation.
- Add a small example and show its expected output.
- Add an exercise that asks the learner to change the code.
- Improve quoting, error messages, input validation, or tests.
- Add a practical project that solves a real admin task safely.

## Before opening a pull request

1. Keep one change focused.
2. Label platform-specific commands.
3. Quote variable expansions unless splitting or globbing is intentional.
4. Avoid eval and avoid building shell commands inside strings.
5. Never add credentials, private logs, or personal data.
6. Test examples in a temporary directory.
7. Run ShellCheck on changed scripts and run bash tests/run-tests.sh.
8. Explain what you tested and note any limitations.

## Teaching style

Write like you are helping a classmate at a terminal. Explain why a line exists, not only what it is called. Prefer a short, runnable example over a large unexplained block. If a command can delete or overwrite data, say so clearly and show a safe test first.

## Pull request checklist

- [ ] The change has a clear purpose.
- [ ] Examples include comments or expected output where useful.
- [ ] Risky actions have safeguards or clear warnings.
- [ ] ShellCheck passes, or any warning is explained.
- [ ] Relevant tests pass.
- [ ] Documentation links and paths work.
