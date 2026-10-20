# 05 — Loops and functions

Loops repeat work. Functions give a small task a name so it can be reused.

## for loop

    for service in ssh cron
    do
        printf 'Would check service: %s\n' "$service"
    done

This prints two lines. It does not inspect or modify services.

For filenames, prefer arrays or safe loops over parsing plain ls output. A safe pattern for finding files is:

    while IFS= read -r -d '' path; do
        printf 'Found: %s\n' "$path"
    done < <(find . -type f -print0)

The NUL delimiter handles filenames containing spaces, tabs, and newlines. This example requires Bash and a find implementation supporting -print0.

## while loop

    count=1
    while (( count <= 3 )); do
        printf 'Attempt %s\n' "$count"
        ((count += 1))
    done

Make sure the loop condition eventually becomes false.

## Functions

    say_status() {
        local status=$1
        printf '[%s] check complete\n' "$status"
    }

    say_status 'OK'

Using local keeps the variable scoped to the function. Functions can return an exit status with return. Use standard output when a function needs to produce a value, and use an exit status to indicate success or failure.

## Try it yourself

1. Print the numbers 1 through 10.
2. Loop over an array of file extensions.
3. Write a function that checks whether a supplied path is a regular file.
4. Make a loop stop after a fixed number of attempts.

## Common mistake

A function's return is an exit status, not a general-purpose string return. Use standard output for data and exit statuses to indicate success or failure.
