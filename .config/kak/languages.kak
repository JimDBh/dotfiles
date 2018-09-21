# Custom faces
    set-face global child rgb:fb4934,default+b
    set-face global delimiters rgb:af3a03,default

# Highlight operators and delimiters
    hook -group ope_delim global WinCreate .* %{
        add-highlighter buffer/operators regex (\+|-|\*|=|\\|\?|%|\|-|!|\||->|\.|,|<|>|::|\^|/) 0:operator
        add-highlighter buffer/delimiters regex (\(|\)|\[|\]|\{|\}|\;|') 0:delimiters
    }

# C/Cpp/Rust syntax fixes
    hook global WinSetOption filetype=(c|cpp|rust) %{
        add-highlighter buffer/ regex \w+(\h+)?(?=\() 0:function
        add-highlighter buffer/ regex ((?<=\.)|(?<=->))\w+\b(?![>"\(]) 0:child
        add-highlighter buffer/ regex ((?<=\.)|(?<=->))\w+(\h+)?(?=\() 0:function
    }

# Expandtab hooks
    hook global WinSetOption filetype=(rust|kak) %{
        hook -group expandtab global InsertChar \t %{
            exec -draft h@
        }
        hook -group expandtab global InsertDelete ' ' %{ try %{
          execute-keys -draft 'h<a-h><a-k>\A\h+\z<ret>i<space><esc><lt>'
        }}
    }
    hook global WinSetOption filetype=makefile %{
        remove-hooks global expandtab
    }

# C/Cpp
    hook global WinSetOption filetype=(c|cpp) %{
        # Custom C/Cpp types highlighing
        add-highlighter window/ regex \b(v|u|vu)\w+(8|16|32|64)(_t)?\b 0:type
        add-highlighter window/ regex \b(v|u|vu)?(_|__)?(s|u)(8|16|32|64)(_t)?\b 0:type
        add-highlighter window/ regex \b(v|u|vu)?(_|__)?(int|short|char|long)(_t)?\b 0:type
        add-highlighter window/ regex \b\w+_t\b 0:type
        set window formatcmd 'clang-format'
        clang-enable-autocomplete
        clang-enable-diagnostics
        set-option global clang_options  %sh{
            options='-Wall --std=c99'
            options=$(eval echo $options' -I$(pwd)/include')
            options=$(eval echo $options' -I$(pwd)/testpacks/SPW_TESTS/spw_lib_src')
            options=$(eval echo $options' -I$(pwd)/testpacks/SK_VG11/pci_master_slave_cross_test')
            options=$(eval echo $options' -I$(pwd)/testpacks/CAN/can_lib_src')
            options=$(eval echo $options' -I$(pwd)/testpacks/MKIO/mkio_lib_src')
            options=$(eval echo $options' -I$(pwd)/platforms/$(cat ./testkit.settings | grep "?=" |  sed -E "s/.*= //")/include')
            echo $options
        }
    }

# Rust
    hook global WinSetOption filetype=rust %{
        set window formatcmd 'rustfmt'
    }

# Markdown
    hook global WinSetOption filetype=markdown %{
        remove-highlighter buffer/operators
        remove-highlighter buffer/delimiters
    }
