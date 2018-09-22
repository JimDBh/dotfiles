# ╭─────────────╥───────────────────╮
# │ Author:     ║ File:             │
# │ Andrey Orst ║ common.kak        │
# ╞═════════════╩═══════════════════╡
# │ Common settings for Kakoune     │
# ╞═════════════════════════════════╡
# │ Rest of .dotfiles:              │
# │ GitHub.com/andreyorst/dotfiles  │
# ╰─────────────────────────────────╯
 
# Common options
    set-option global scrolloff 3,3
    set-option global grepcmd 'rg -L --with-filename --column'
    set-option global tabstop 4
    set-option global indentwidth 4

# UI
    colorscheme base16-guvbox-dark-soft
    set-option global ui_options ncurses_status_on_top=no ncurses_assistant=none
    set-option global modelinefmt '{rgb:83a598}{rgb:3c3836,rgb:83a598+b} %val{bufname}{{context_info}} {default,rgb:3c3836} {{mode_info}} {rgb:83a598+b}%val{cursor_line}{default}:{rgb:83a598+b}%val{cursor_char_column} {rgb:83a598}{rgb:3c3836,rgb:83a598+b} %opt{filetype} {rgb:3c3836,rgb:83a598}{rgb:83a598} {rgb:83a598,default+b}%val{client}{default} at {magenta,default+b}[%val{session}] '

# Highlighters
    add-highlighter global/ number-lines -relative -hlcursor
    add-highlighter global/ show-matching
    # add-highlighter global/ show-whitespaces -tab "▏" -lf " " -nbsp "⋅" -spc " "
    add-highlighter global/ wrap -word -indent -marker ↪

# Maps and hooks
    # maps <c-/> to comment/uncomment line
    map global normal '' :comment-line<ret>
    map -docstring "file non-recursive" global goto '<a-f>' '<esc><a-i><a-w>gf'
    map -docstring "file" global goto 'f' '<esc><a-i><a-w>:find %reg{dot}<ret>'

    # tab-completion
    hook global InsertCompletionShow .* %{map   window insert <tab> <c-n>; map   window insert <s-tab> <c-p>}
    hook global InsertCompletionHide .* %{unmap window insert <tab> <c-n>; unmap window insert <s-tab> <c-p>}

