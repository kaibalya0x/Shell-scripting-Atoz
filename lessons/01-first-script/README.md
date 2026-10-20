# 01 — Your first script

A shell is a program that reads commands and asks the operating system to run them. A script is a text file containing commands you want to run in sequence.

## Write a script

Create hello.sh with the following content:

    #!/usr/bin/env bash
    # Print a small introduction.
    printf 'Hello from Bash!\n'
    printf 'Current user: %s\n' "$USER"
    printf 'Current directory: %s\n' "$PWD"

Run it:

    bash hello.sh

Example output (your user and directory will differ):

    Hello from Bash!
    Current user: learner
    Current directory: /home/learner/lab

## What is the first line?

The line #!/usr/bin/env bash is the shebang. When you run an executable script directly, the operating system uses it to locate Bash through env. If you explicitly run bash hello.sh, Bash reads the file regardless of the shebang.

## Why use printf?

printf gives predictable formatting. It also helps keep user-controlled text separate from formatting instructions:

    name='Sam'
    printf 'Hello, %s!\n' "$name"

## Execute permission

    chmod u+x hello.sh
    ./hello.sh

If you see “Permission denied”, check execute permission and whether the filesystem allows execution. You can still run the script with bash hello.sh.

## Comments

Lines beginning with # are comments, except the shebang has a special meaning at the top of an executable script. Comments should explain intent or non-obvious decisions instead of repeating every command in English.

## Try it yourself

1. Print the current date with date.
2. Print your home directory with echo.
3. Add a comment explaining the script's purpose.
4. Run it once with bash and once directly after adding execute permission.

## Common mistake

Running hello.sh without ./ often fails because the current directory usually is not in PATH. Use ./hello.sh or the full path instead.
