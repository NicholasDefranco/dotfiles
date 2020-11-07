#!/usr/bin/env sh

# Creates a file and the directories as nessesary given a path
mkpaths() {
    for arg in $@
    do
	file="${arg##*/}"
	if [ "$(echo "$1" | grep '.*/.*')" != "" ]; then
	    dirs="${arg%/*}/"
	    mkdir -p "$dirs"
	else
	    dirs="./"
	fi

	if [ "$file" != "" ]; then
	    touch "${dirs}${file}"
	fi
    done
}

