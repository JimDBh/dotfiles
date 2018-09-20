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
    set-face global delimiters rgb:af3a03,default

    add-highlighter global/ number-lines -relative -hlcursor
    add-highlighter global/ show-matching
    # add-highlighter global/ show-whitespaces -tab "▏" -lf " " -nbsp "⋅" -spc " "
    add-highlighter global/ wrap -word -indent -marker ↪

    # Highlight operators and delimiters
    add-highlighter global/ regex (\+|-|\*|=|\\|\?|%|\|-|!|\||->|\.|,|<|>|::|\^) 0:operator
    add-highlighter global/ regex (\(|\)|\[|\]|\{|\}|\;|') 0:delimiters

# Maps and hooks
    # maps <c-/> to comment/uncomment line
    map global normal '' :comment-line<ret>
    map -docstring "file non-recursive" global goto '<a-f>' 'f'
    map -docstring "file" global goto 'f' '<esc>:open-file-rec<ret>'

    # tab-completion
    hook global InsertCompletionShow .* %{map   window insert <tab> <c-n>; map   window insert <s-tab> <c-p>}
    hook global InsertCompletionHide .* %{unmap window insert <tab> <c-n>; unmap window insert <s-tab> <c-p>}

# Commands
    define-command -docstring "open file recursively searching for it under path" \
    open-file-rec %{ edit -existing %sh{
        for path in $kak_opt_path; do
            [ "$path" = "'%/'" ] && path=$(echo $kak_buffile | sed -E "s/\/[^\/]*$/\//")
            file=$(find -L $path -type f -name $(eval echo $kak_reg_dot))
            if [ ! "x$file" = "x" ]; then
                break
            fi
        done
        [ ! "x$file" = "x" ] && echo $file
    }}

