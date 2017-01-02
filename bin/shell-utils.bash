#!/usr/bin/env bash

##
# Print error message and immediately exit with a nonzero exit status
##
die() {
    printf '%s\n' "$@" >&2
    exit 1
}

##
# Die if run as root
##
no_root() {
    if [[ $(whoami) == "root" ]]; then
        echo "Don't run this as root!  Just run as your user."
        exit 1
    fi
}

##
# A better alternative to `which`(suppresses output for ZSH)
##
exists() {
    local cmd_to_find="$1"
    command -v $cmd_to_find >/dev/null 2>&1
    return $?
}

##
# Returns 0 if osx, otherwise 1
##
is_osx() {
    if [ "$(uname -s)" == "Darwin" ]; then
        return 0
    fi

    return 1
}

##
# Returns 0 if linux, otherwise 1
##
is_linux() {
    if [ "$(uname -s)" == "Linux" ]; then
        return 0
    fi

    return 1
}

