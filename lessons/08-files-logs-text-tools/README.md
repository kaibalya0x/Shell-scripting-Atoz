# 08 — Files, logs, and text tools

Linux administrators often need to narrow a large amount of text into a useful answer. Practise with sample data or copies of logs; production logs may contain usernames, tokens, email addresses, and other sensitive information.

Create a sample log:

    cat > sample.log <<'LOG'
    2026-10-20 INFO service started
    2026-10-20 WARN disk usage rising
    2026-10-20 ERROR cannot read example file
    2026-10-20 INFO service stopped
    LOG

## grep

    grep -n 'ERROR' sample.log
    grep -Ei 'warn|error' sample.log

The first prints matching lines with line numbers. The second searches case-insensitively for either word on common GNU grep implementations.

## sort and uniq

    printf 'ssh\ncron\nssh\n' | sort | uniq -c

Example output:

         1 cron
         2 ssh

uniq compares adjacent lines, so sorting first is useful for frequency counts.

## awk

    awk '$3 == "ERROR" { print $0 }' sample.log

This works with the sample's whitespace-separated fields. Real logs can use other formats, so inspect the format before writing a parser.

## find

    find . -type f -name '*.log' -print
    find . -type f -size +1M -print

Do not parse ls output to process filenames. To handle arbitrary filenames, use NUL delimiters where available:

    while IFS= read -r -d '' file; do
        echo "Found: $file"
    done < <(find . -type f -print0)

## sed

    sed 's/WARN/WARNING/' sample.log

Without an in-place option, this prints transformed text without editing the source. In-place editing differs between platforms and should be tested on a copy.

## Try it yourself

1. Count occurrences of each level in the sample log.
2. Find all .log files below your lab directory.
3. Print only lines containing disk.
4. Try the commands on a copy of a real log after removing sensitive data.

## Common mistake

A quick text filter is not automatically a robust log parser. Document assumptions about the format, and never treat untrusted log content as shell code.
