# ╭─────────────╥───────────────────╮
# │ Author:     ║ File:             │
# │ Andrey Orst ║ commands.kak      │
# ╞═════════════╩═══════════════════╡
# │ Custom commands for Kakoune     │
# ╞═════════════════════════════════╡
# │ Rest of .dotfiles:              │
# │ GitHub.com/andreyorst/dotfiles  │
# ╰─────────────────────────────────╯
 
define-command -override -hidden -params 1 smart-f %{ evaluate-commands %sh{
	for buffer in $kak_buflist; do
		buffer="${buffer%\'}"; buffer="${buffer#\'}"
		if [ -z "${buffer##*$1}" ]; then
			echo "buffer $buffer"
			exit
		fi
	done
	if [ -e "'$1'" ]; then
		echo "edit -existing '$1'"
		exit
	fi
	for path in $kak_opt_path; do
		path="${path%\'}"; path="${path#\'}"
		case $path in
			"./") path=${kak_buffile%/*};;
			"%/") path=$(pwd);;
		esac
		if [ -z "${1##*/*}" ]; then
			test=$(eval echo "'$path/$1'")
			[ -e "$test" ] && file=$test
		else
			file=$(find -L $path -xdev -type f -name $(eval echo $1) | head -n 1)
		fi
		if [ ! -z "$file" ]; then
			echo "edit -existing '$file'"
			exit
		fi
	done
	echo "echo -markup '{Error}unable to find file ''$1'''"
}}

define-command -override -docstring "run command if Kakoune was launched in termux" in-termux -params 2 %{
	evaluate-commands %sh{
		case $PATH in
		*termux*)
			echo "$1"
			;;
		*)
			echo "$2"
			;;
		esac
	}
}

define-command -override -docstring "select a word under cursor, or add cursor on next occurence of current selection" \
select-or-add-cursor %{ execute-keys -save-regs '' %sh{
	if [ "$(expr $(echo $kak_selection | wc -m) - 1)" = "1" ]; then
		echo "<a-i>w*"
	else
		echo "*<s-n>"
	fi
}}

define-command -override -docstring "find file recursively searching for it under path" \
find -params 1 -shell-script-candidates %{ find . \( -path '*/.svn*' -o -path '*/.git*' \) -prune -o -type f -print } %{ edit %arg{1} }

define-command -override leading-spaces-to-tabs %{ declare-option -hidden int cline %val{cursor_line}; declare-option -hidden int ccol %val{cursor_column}; execute-keys %{ %s^\h+<ret><a-@>}; execute-keys %opt{cline}g %opt{ccol}lh }
define-command -override leading-tabs-to-spaces %{ declare-option -hidden int cline %val{cursor_line}; declare-option -hidden int ccol %val{cursor_column}; execute-keys %{ %s^\h+<ret>@}; execute-keys %opt{cline}g %opt{ccol}lh }

