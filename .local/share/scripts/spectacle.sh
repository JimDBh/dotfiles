#!/bin/sh

if [ $# -ne 1 ]; then
	printf "%s\n" "Wrong argument count: $#, required 1" >&2
	exit
fi

case $1 in
    full)
		message="Fullscreen" ;;
    window)
        args="a"
		message="Active window" ;;
    rectangle)
        args="r"
		message="Rectangle" ;;
	*)
		printf "%s\n" "unsupported argument '$1'" >&2
		exit ;;
esac

screenshot="${TMPDIR:-/tmp}/screenshot.png"
rm -rf ${screenshot}
spectacle -n${args}bo ${screenshot}
if [ -f ${screenshot} ]; then
    xclip -selection clipboard -t $(file -b --mime-type ${screenshot}) < ${screenshot} &&
    notify-send -i spectacle "Spectacle" "${message} screenshot captured to the clipboard" ||
    notify-send -i spectacle "Spectacle" "can't capture ${message} screenshot to the clipboard. Error code: $?"
fi
