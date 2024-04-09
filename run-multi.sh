#!/bin/bash

# Emulates the White Rabbit scene from 'The Matrix'.
#
# Targets: MacOS, Linux (Debian)
# Requires an internet connection if tools are not already installed.
#
# Configuration:
# NAME: str => the name to use in the message. Defaults to "Neo"
# HUMAN: bool => Make typing seem more natural with random delays and the occasional typo. Defaults to FALSE
# FULLSCREEN: bool => MacOS Only. Make terminal full screen. Defaults to FALSE.
# HACKER: bool => MacOS Only. Use black/green terminal theme. Defaults to FALSE.

## RUN WITH CURL and remove history
# export NAME=Dave && curl https://raw.githubusercontent.com/velcr0/white-rabbit/main/run-multi.sh | bash && history -c

clear
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ -z "$NAME" ]]; then
    NAME="Neo"
fi

macos_ensure_homebrew () {
    # install homebrew if not installed. requires sudo password.
    if [[ $(command -v brew) == "" ]]; then
        echo "Installing Hombrew"
        nohup /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    clear
}

macos_homebrew_tools () {
    # install tooling if not installed, via homebrew
    brew ls --versions cmatrix > /dev/null || bash -c 'brew install cmatrix > /dev/null & disown'
    brew ls --versions automake > /dev/null || bash -c 'brew install automake > /dev/null & disown'
    clear
}

linux_gnu_tools () {
    # install tooling if not installed, via apt
    sudo bash -c 'apt-get update -y >/dev/null 2>&1'
    sudo bash -c 'apt-get -y install cmatrix >/dev/null 2>&1 & disown'
    clear
}

typer () {
    # slowly types out text input
    # if $HUMAN=TRUE, add some randomness to make typing appear more human
    # usage: typer "content to type"
    
    # split single characters into lines
    grep -o . <<<$1 | while read a
    do
        if [[ "$HUMAN" ]]; then
            # short random delay between keystrokes
            sleep 0.$((RANDOM%3))
            # make fake typo every 30th keystroke
            if [[ $((RANDOM%30)) == 1 ]]; then
                # print random character between a-z
                printf "\\$(printf %o "$((RANDOM%26+97))")"
                # wait a bit and delete it again
                sleep 0.5; echo -ne '\b'; sleep 0.2
            fi
        else
            # short fixed delay between keystrokes
            sleep 0.1
        fi
        
        # output a space, or $a if it is not null
        echo -n "${a:- }"
    done
    echo
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux/GNU
    # echo "linux-gnu"

    linux_gnu_tools
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    # echo "darwin"

    # ensure homebrew is installed
    macos_ensure_homebrew
    # install tools via homebrew
    macos_homebrew_tools

    if [[ "$HACKER" == "TRUE" ]]; then
        HACKER_TERMINAL_THEME="Homebrew"
        LS="Application(\"Terminal\").windows[0].currentSettings = Application(\"Terminal\").settingsSets[\"$HACKER_TERMINAL_THEME\"]"
        osascript -l JavaScript -e "$LS" > /dev/null
        clear
    fi

    if [[ "$FULLSCREEN" == "TRUE" ]]; then
        osascript <<"EOF"
            tell application "Terminal" to activate
            tell application "System Events" to keystroke "f" using { command down, control down }
            delay 3
EOF
        clear
    fi

elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        echo "cygwin"
        exit 1;
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        echo "msys"
        exit 1;
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
        echo "win32"
        exit 1;
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
        echo "freebsd"
        exit 1;
else
        # Unknown.
        echo "unknwon os"
        exit 1;
fi

clear

typer "Wake up, $NAME..."
echo "" # display an empty line and keep going 
sleep 3
# read -n 1 -s -r -p "" # pause and wait for ANY keyboard input

typer "The Matrix has you... Follow the white rabbit."
echo ""
sleep 6

typer "Knock, Knock, $NAME."
sleep 1

# clear

# if [[ "$OSTYPE" == "darwin"* ]]; then
#     # Change the color of the terminal back to what it was before
#     DEFAULT_TERMINAL_THEME="Basic"
#     RS="Application(\"Terminal\").windows[0].currentSettings = Application(\"Terminal\").settingsSets[\"$DEFAULT_TERMINAL_THEME\"]"
#     osascript -l JavaScript -e "$RS" > /dev/null
# fi
cmatrix
