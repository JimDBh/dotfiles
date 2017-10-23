set nocompatible
filetype off

" Plugins
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'chriskempson/base16-vim'

    Plugin 'scrooloose/syntastic'

    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'

    Plugin 'Raimondi/delimitMate'

    Plugin 'Yggdroot/indentLine'

    Plugin 'octol/vim-cpp-enhanced-highlight'

    Plugin 'Valloric/YouCompleteMe'

    Plugin 'junegunn/goyo.vim'
    call vundle#end()

" Common Settings
    set encoding=utf-8

    set mouse=a

    set number

    syntax on

    set foldmethod=syntax
    set foldlevelstart=20
    hi Folded ctermbg=black

    " set cursorline
    set wrap
    set linebreak
    " set colorcolumn=110

    " set listchars=tab:▏\ ,eol:\ ,trail:⋅,extends:,precedes:,space:\ 
    " set list
    set termguicolors

    set splitright
    set splitbelow
    set signcolumn=yes

" Tabs
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set autoindent
    set smartindent

" AirLine config
    set laststatus=2

    " Bottom row
        if !exists('g:airline_symbols')
            let g:airline_symbols = {}
        endif
        let g:airline_symbols.linenr = '≣'

    " Tabs
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#left_sep = ''
        let g:airline#extensions#tabline#left_alt_sep = ''

    " Theme
        let g:airline_powerline_fonts = 1
        " let g:airline_theme='tomorrow'

" Map Settings
    " Toggle nerd tree
        " map <A-n> :NERDTreeToggle<CR>

    " Toggle terminal on/off
    nnoremap <A-t> :call Term_toggle(12)<cr>
    inoremap <A-t> <Esc>:call Term_toggle(12)<cr>
    tnoremap <A-t> <C-\><C-n>:call Term_toggle(12)<cr>

    " Terminal go back to normal mode
    :tnoremap <Esc> <C-\><C-n>

    " visual mode from insert mode
        inoremap <C-v> <Esc>l<C-v>
        inoremap <A-v> <Esc>lV

    " navigation in insert mode
        inoremap <A-h> <Left>
        inoremap <A-j> <Down>
        inoremap <A-k> <Up>
        inoremap <A-l> <Right>
        
        inoremap <A-w> <Esc>lwi
        inoremap <C-w> <Esc>lWi

        inoremap <A-e> <Esc>lei
        inoremap <C-e> <Esc>lEi

        inoremap <A-b> <Esc>lbi
        inoremap <C-b> <Esc>lBi

        inoremap <A-o> <Esc>o
        inoremap <C-o> <Esc>O

        inoremap <A-i> <Esc>I
        inoremap <A-a> <Esc>A
        
        inoremap <A-c> <Esc>lc

        inoremap <A-y> <Esc>ly
        inoremap <A-p> <Esc>lpi
        inoremap <C-p> <Esc>lPi

        inoremap <A-u> <Esc>ui
        inoremap <A-r> <Esc><C-r>i

" Indent Line Settings
    let g:indentLine_char = '▏'
    " let g:indentLine_enabled = 1

" Terminal Function
    let g:term_buf = 0
    let g:term_win = 0

    function! Term_toggle(height)
        if win_gotoid(g:term_win)
            hide
        else
            botright new
            exec "resize " . a:height
            try
                exec "buffer " . g:term_buf
            catch
                call termopen($SHELL, {"detach": 0})
                let g:term_buf = bufnr("")
            endtry
            startinsert!
            let g:term_win = win_getid()
        endif
    endfunction

" Base 16
    if filereadable(expand("~/.vimrc_background"))
        let base16colorspace=256
        source ~/.vimrc_background
    endif

    let g:NERDTreeDirArrowExpandable = '📁'
    let g:NERDTreeDirArrowCollapsible = '📂'
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" YCM
    let g:ycm_global_ycm_extra_conf = '/home/andreyorst/.vim/bundle/YouCompleteMe/ycm_global_ycm_extra_conf.py'

    " turn on completion in comments
        let g:ycm_complete_in_comments=0
    " load ycm conf by default
        let g:ycm_confirm_extra_conf=0
    " turn on tag completion
        let g:ycm_collect_identifiers_from_tags_files=1
    " only show completion as a list instead of a sub-window
        set completeopt-=preview
    " start completion from the first character
        let g:ycm_min_num_of_chars_for_completion=2
    " don't cache completion items
        let g:ycm_cache_omnifunc=1
    " complete syntax keywords
        let g:ycm_seed_identifiers_with_syntax=1

" delimitMate
    let delimitMate_expand_cr = 1
    let delimitMate_expand_space = 0
    let delimitMate_nesting_quotes = ['`']
