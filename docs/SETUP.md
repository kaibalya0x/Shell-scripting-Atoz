# Setting up a safe shell lab

## Choose an environment

A Linux VM or WSL distribution is the easiest way to match these examples. macOS is fine for the basics, but utilities such as stat, date, and df can use different options.

Check the version of Bash:

    bash --version

The environment variable SHELL usually names your configured login shell; it does not necessarily identify the shell interpreting the current script.

## Create a disposable lab directory

    mkdir -p "$HOME/bash-lab"
    cd "$HOME/bash-lab"
    pwd

Use this directory for file creation, archiving, and cleanup exercises. Do not practise deletion commands against /, /etc, /var/log, or a directory containing important data.

## Install helpful tools

On Debian or Ubuntu:

    sudo apt update
    sudo apt install bash shellcheck

On Fedora:

    sudo dnf install bash ShellCheck

Package names can vary by distribution. You do not need administrator rights to run most lessons or example tests.

## Run scripts

    bash path/to/script.sh
    chmod u+x path/to/script.sh
    ./path/to/script.sh

The first form asks Bash to read the file. The second adds execute permission for your user. The third runs the file directly, using its shebang.

## Safe testing

The tests create temporary files under a test directory and remove that directory on exit. Project scripts accept configurable paths where appropriate. Read each project's safety notes before adapting it for a real host.
