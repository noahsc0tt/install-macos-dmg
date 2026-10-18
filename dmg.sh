#!/usr/bin/env bash

error() {
    echo "Failed: $1" >&2
    exit 1
}

path=$(realpath "$1")

if [[ ! -f $path || ${path,,} != *.dmg ]]; then
    error "Provide a .dmg path"
fi



echo "Mounting disk image"

errfile=$(mktemp)
trap 'rm "$errfile"' EXIT

volume=$(hdiutil attach "$path" 2>"$errfile" | awk '$NF ~ /\/Volumes\/.*/ { print $NF }')

if [[ -s $errfile ]]; then
    error < "$<($errfile)"
fi

appname="${volume##/Volumes/}"



echo "Copying app to Applications directory"

if ! err=$(ditto "$volume/$appname.app" "/Applications/$appname.app" 2>&1 > /dev/null) ; then
    error "$err"
fi



echo "Ejecting disk image"

if ! err=$(hdiutil detach "$volume" 2>&1 > /dev/null); then
    error "$err"
fi
