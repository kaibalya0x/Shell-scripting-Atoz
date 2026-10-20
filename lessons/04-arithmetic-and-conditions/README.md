# 04 — Arithmetic and conditions

## Arithmetic

Bash supports integer arithmetic:

    used=72
    limit=80
    remaining=$((limit - used))
    printf 'Remaining: %s\n' "$remaining"

Output:

    Remaining: 8

This is integer math. For decimal calculations, use a tool designed for that task, such as awk or bc, and check whether it is installed.

## Conditions

    free_percent=18

    if (( free_percent < 10 )); then
        printf 'CRITICAL: very little space remains\n'
    elif (( free_percent < 20 )); then
        printf 'WARNING: disk space is getting low\n'
    else
        printf 'OK: disk space looks healthy\n'
    fi

Arithmetic conditions are useful for numeric comparisons. For string and file checks, [[ ... ]] is often clearer.

    file='report.txt'

    if [[ -f "$file" ]]; then
        printf 'A regular file exists: %s\n' "$file"
    else
        printf 'No regular file at: %s\n' "$file"
    fi

## Logical operators

Inside [[ ... ]], use && for AND and || for OR. For example:

    if [[ -r "$file" && -f "$file" ]]; then
        printf 'Readable regular file\n'
    fi

For commands, command_a && command_b runs the second command only if the first succeeds; command_a || command_b runs the second when the first fails. This is about exit statuses, not text output.

## case

    read -r -p 'Choose start, stop, or status: ' action
    case "$action" in
        start|stop|status) printf 'Selected action: %s\n' "$action" ;;
        *) printf 'Unknown action\n' >&2; exit 2 ;;
    esac

This example only recognizes input. It does not start or stop any service.

## Try it yourself

1. Classify a number as positive, negative, or zero.
2. Check whether a path exists and is a directory.
3. Add an unknown branch to a menu.
4. Explain the difference between string and integer comparisons.

## Common mistake

Do not compare integers as strings. Use (( ... )) for integer arithmetic and [[ ... ]] for string or file conditions.
