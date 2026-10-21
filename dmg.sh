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

if ! attach_output=$(hdiutil attach "$path" 2>"$errfile"); then
    if [[ -s $errfile ]]; then
        error "$(<"$errfile")"
    fi
    error "hdiutil attach failed"
fi

volume=$(awk 'match($0, /\/Volumes\/.*/) { print substr($0, RSTART, RLENGTH); exit }' <<<"$attach_output")

if [[ ! -d $volume ]]; then
    error "Could not determine mounted volume path"
fi

for file in "$volume"/*.app; do
    [[ -d $file ]] && app="$file"
done

[[ -z $app ]] && error "No app found in $volume"



echo "Copying app to Applications directory"

if ! err=$(ditto "$app" "/Applications/${app##*/}" 2>&1 > /dev/null) ; then
    error "$err"
fi



echo "Ejecting disk image"

if ! err=$(hdiutil detach "$volume" 2>&1 > /dev/null); then
    error "$err"
fi
