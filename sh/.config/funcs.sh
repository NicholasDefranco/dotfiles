#!/usr/bin/env sh

# Change working dir in shell to last dir in lf on exit (adapted from ranger).
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@" \ || {
	echo "head over to: https://github.com/gokcehan/lf" >&2
	    return 1
	}
    if [ -f "$tmp" ]; then
	dir="$(cat "$tmp")"
	rm -f "$tmp"
	if [ -d "$dir" ]; then
	    if [ "$dir" != "$(pwd)" ]; then
		cd "$dir" || exit 1
	    fi
	fi
    fi
}

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

git() {
    if [ $1 = "clone" ]; then
	shift
	for arg in $@; do
	    [ -n "$(echo $arg | grep ':.*/')" ] && url=$arg && continue
	    [ -z "$(echo "$arg" | grep '^--')" ] && dir_name=$arg && break
	done
	tmp="${url##*/}"
	tmp="${tmp%.*}"
	command git clone "$@" && cd "${dir_name:-$tmp}" && prunehooks
    else
	command git "$@";
    fi;
}

usehook() {
    file=$1
    [ -z "$(git rev-parse --show-toplevel)" ] && {
	return 1
    }

    [ -z "$file" ] && {
	echo "Usage: <hook type>/<hook name>"
	tree ~/.config/git/hooks/
	return 1
    }

    [ -f "$HOME/.config/git/hooks/$1" ] || {
	echo "no such hook"
	echo "Usage: <hook type>/<hook name>"
	tree ~/.config/git/hooks/
	return 1
    }

    hook="$(git rev-parse --show-toplevel)"/.git/hooks/"${file%/*}"
    [ -f "$hook" ] && {
	echo "File exists! Replace? (y/n)"
	read -r
	[ "$(echo "$REPLY" | tr 'Y' 'y')" = 'y' ] && rm "$hook" || {
	    echo "Aborting"
	    return 1
	}
    }

    echo "Installing $hook hook"
    ln -s ~/.config/git/hooks/"$1" "$hook"
    # In case the file isn't executable already
    chmod +x "$hook"
}

prunehooks() {
    repo="$(git rev-parse --show-toplevel)"
    [ -z "$repo" ] && {
	return 1
    }

    echo "Ok, removing *.sample hooks"
    rm $repo/.git/hooks/*.sample 2> /dev/null
}

disablehook() {
    repo="$(git rev-parse --show-toplevel)"
    [ -z "$repo" ] && {
	return 1
    }

    [ -z "$1" ] && {
	echo "Usage: <hook type>"
	echo "Hooks in use:"
	ls -H "$repo/.git/hooks/"
	return 1
    }

    [ "$(ls $repo/.git/hooks/$1)" ] || {
	echo "No such hook"
	ls -H "$repo/.git/hooks/"
	return 1
    }

    echo "Disabling $1 hook"
    rm "$repo/.git/hooks/$1"
}

# github actions
useaction() {
    repo="$(git rev-parse --show-toplevel)"
    [ -z "$repo" ] && {
	return 1
    }

    [ -z "$1" ] && {
	echo "Usage: <action>"
	echo "Available actions:"
	ls ~/.config/git/actions/
	return 1
    }

    [ -f "$HOME/.config/git/actions/$1" ] || {
	echo "No such action"
	ls ~/.config/git/actions/
	return 1
    }

    [ -z "$(git remote -v | grep 'github')" ] && {
	echo "No github repo detected, are you sure you want to add an action?"
	read -r
	[ "$(echo $REPLY | tr 'Y' 'y')" = 'y' ] || {
	    echo "Aborting"
	    return 1
	}
    }

    echo "installing $1 action"
    mkdir -p "$repo/.github/workflows/"
    cp "$HOME/.config/git/actions/$1" "$repo/.github/workflows/"
}

rmaction() {
    repo="$(git rev-parse --show-toplevel)"
    [ -z "$repo" ] && {
	return 1
    }

    [ -z "$repo/.github/workflows/*" ] || {
	echo "No actions in use, no need to delete"
	return 1
    }

    [ -z "$1" ] && {
	echo "Usage: <action>"
	echo "Actions in use:"
	ls "$repo/.github/workflows/"
	return 1
    }

    [ -f "$repo/.github/workflows/$1" ] || {
	echo "No such action"
	ls "$repo/.github/workflows/"
	return 1
    }

    echo "Removing the $1 action"
    rm "$repo/.github/workflows/$1"
}
