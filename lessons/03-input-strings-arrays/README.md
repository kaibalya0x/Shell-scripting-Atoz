# 03 — Input, strings, and arrays

## Read user input

    read -r -p 'Which service are you checking? ' service
    echo "You entered: $service"

The -r option prevents backslashes from being treated as escape characters. Quoting the variable preserves spaces in the response.

When input is sensitive, read -r -s hides typing in the terminal. Be careful not to log or echo such a value. Do not store passwords in a repository or shell history.

## Basic string operations

    host='web-01.example.test'
    echo "Length: ${#host}"
    echo "Prefix: ${host%%.*}"
    echo "Uppercase: ${host^^}"

This prints the string length, the text before the first dot, and an uppercase version. The ^^ operator requires a modern Bash version.

String equality is commonly checked with [[ "$a" == "$b" ]]. Prefer [[ ... ]] for Bash conditionals because it avoids many word-splitting surprises associated with older [ ... ] tests.

## Arrays

    tools=('grep' 'awk' 'sed')
    tools+=('find')

    echo "First tool: ${tools[0]}"
    echo "Tool count: ${#tools[@]}"

    for tool in "${tools[@]}"; do
        echo "Reviewing: $tool"
    done

Array indexes begin at zero. An empty array is valid. Avoid using "$array" when you mean all elements; use "${tools[@]}".

## Try it yourself

1. Ask for a filename and print it without losing spaces.
2. Create an array of three services.
3. Print the number of array elements.
4. Convert a short environment name to uppercase.

## Common mistake

Do not use eval to turn user input into shell commands. Keep input as data, validate it where needed, and pass it as a quoted argument.
