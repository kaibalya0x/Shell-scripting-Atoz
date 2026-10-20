# Learning roadmap

There is no prize for rushing through this list. Run each example, predict what it will print, then change it and run it again.

## Stage 1 — Get your bearings

Learn the difference between a shell prompt and a script file, how the shebang selects an interpreter, how execute permission works, and how to run a script with bash file.sh.

**Checkpoint:** Print your username, current directory, and date from one script.

## Stage 2 — Store and transform information

Learn variables, single and double quotes, parameter expansion, arrays, string length, substring extraction, and reading input. Many early Bash bugs are really quoting or whitespace bugs.

**Checkpoint:** Ask for a service name and print a friendly message without losing spaces.

## Stage 3 — Make decisions and repeat work

Practise integer arithmetic, tests, if, elif, case, for, while, until, and logical operators. Learn the difference between a command's exit status and the text it prints.

**Checkpoint:** Classify a percentage as OK, warning, or critical.

## Stage 4 — Package reusable logic

Write functions with clear inputs and outputs. Handle positional parameters such as $1, $2, and "$@". Use return for small status codes and standard output when a function needs to produce a value.

**Checkpoint:** Validate command-line arguments and print usage for invalid input.

## Stage 5 — Work with streams

Standard input is file descriptor 0, standard output is 1, and standard error is 2. Learn pipes, redirection, here-documents, and /dev/null.

**Checkpoint:** Save normal output to one file and errors to another. Explain which output disappears when redirected to /dev/null.

## Stage 6 — Become useful to an admin

Practise find, grep, sort, uniq, cut, tr, sed, awk, df, du, ps, date, and stat. Learn permissions and why logs can contain sensitive information.

**Checkpoint:** Find large files in a temporary lab folder and summarize repeated words from a sample log.

## Stage 7 — Make it dependable

Add input checks, meaningful exit codes, logs, cleanup traps, and dry-run modes where changes might be risky. Use ShellCheck and test on fixtures rather than production paths.

**Checkpoint:** Reproduce a bug, fix it, and write a test for the corrected behavior.

## Stage 8 — Build projects

Start with the disk-space monitor, then the archive project, system report, log review, and checksum backup.

## A useful practice routine

1. Read the lesson once without typing.
2. Type the example instead of pasting it.
3. Predict the output before running it.
4. Change one value or condition.
5. Try the exercise without looking up a solution.
6. Write down a mistake you made and how you found it.

That last step is often the most useful part of the lesson.
