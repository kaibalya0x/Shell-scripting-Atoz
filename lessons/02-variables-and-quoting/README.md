# 02 — Variables and quoting

Variables let a script keep a value and reuse it. In Bash, do not put spaces around the equals sign when assigning a variable.

    service_name='ssh'
    check_date=$(date +%F)
    echo "Checking $service_name on $check_date"

The date in the output will be the day you run it.

## Assignment versus expansion

- service_name='ssh' stores text.
- "$service_name" expands the variable into its value.
- $(date +%F) runs a command and captures its standard output.

## Single quotes and double quotes

Single quotes preserve characters literally. Double quotes still allow variable expansion and command substitution.

    name='Alex'
    echo 'Hello, $name'
    echo "Hello, $name"

Output:

    Hello, $name
    Hello, Alex

## Why quote variables?

    file_name='monthly report.txt'
    echo "File: $file_name"

The quotes preserve the filename as one argument even though it has a space. Unquoted expansions can undergo word splitting and pathname expansion. That can turn one intended argument into several, or expand wildcard characters unexpectedly.

A good default is "$variable" and "${array[@]}" unless you deliberately need splitting or globbing.

## Default values

    log_dir=${LOG_DIR:-"$HOME/logs"}
    echo "Logs will be read from: $log_dir"

The :- form uses the fallback when LOG_DIR is unset or empty. It does not create the directory.

## Try it yourself

1. Store your favourite Linux command in a variable and print it.
2. Store a sentence with spaces and show why quoting matters.
3. Set LOG_DIR and observe how the default changes.
4. Explain why name = value is not a valid assignment.

## Common mistake

Use name=value to assign. To expand a variable, prefix it with $. Variable names are case-sensitive: PATH and path are different.
