#!/usr/bin/env bash

error() {
    echo "Failed: $1" >&2
    exit 1
}

path=$(realpath "$1")

if [[ ! -f $path || ${path,,} != *.dmg ]]; then
    error "Provide a .dmg path"
fi

dmg=$(basename "$path")
appname="${dmg:0:-4}"
volume="/Volumes/$appname"

echo "Mounting disk image"
if ! err=$(hdiutil attach "$path" 2>&1 > /dev/null); then
    error "$err"
fi

echo "Copying app to Applications directory"
if ! err=$(ditto "$volume/$appname.app" "/Applications/$appname.app" 2>&1 > /dev/null) ; then
    error "$err"
fi

echo "Ejecting disk image"
if ! err=$(hdiutil detach "$volume" 2>&1 > /dev/null); then
    error "$err"
fi
