" Airline
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

" ALE
	let g:airline#extensions#ale#enabled = 1
	let g:ale_lint_delay = 350

	highlight ALEErrorSign guibg=#282a2e guifg=#cc6666
	let g:ale_sign_error = '⬥ '
	let g:ale_sign_warning = '⬥ '

	let g:ale_linters = {
		\ 'c': ['clang', 'gcc'],
		\ 'cpp': ['clang'],
	\}

	" C/C++
		let g:ale_cpp_clang_options = '-Wall --std=c++11 '
		let g:ale_c_clang_options = '-Wall --std=c99 '
		let g:ale_c_gcc_options = '-Wall --std=c99 '

		let g:includepath = ''

		if filereadable("./testkit.settings")
			let g:includepath = system('echo -n
						\ -I $(pwd)/include
						\ -I $(pwd)/testpacks/SPW_TESTS/spw_lib_src
						\ -I $(pwd)/testpacks/CAN/can_lib_src
						\ -I $(pwd)/platforms/$(cat ./testkit.settings | grep "?=" |  sed -E "s/.*= //")/include
						\')
		elseif filereadable("./main.c")
			let g:includepath = system('echo -n
						\ -I $(pwd)/include
						\ -I $(pwd)/include/cp2
						\ -I $(pwd)/include/hdrtest
						\ -I $(pwd)../../include
						\')
		endif

		let g:ale_c_clang_options.= g:includepath
		let g:ale_c_gcc_options.= g:includepath

" CtrlP
	let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
	let g:ctrlp_clear_cache_on_exit = 1
	if executable('ag')
		set grepprg=ag\ --nogroup\ --nocolor
		let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	endif

	set wildignore+=*/.git/*,*/.svn/*,*/rtlrun*/*
				" 'dir':  '\v[\/]\.(git|hg|svn)$',
	let g:ctrlp_custom_ignore = {
				\ 'dir':  '\v(\.git|\.svn|rtlrun.*)$',
				\ 'file': '\v\.(exe|so|dll|o|swp|tar.*)$',
				\ }

" DelimitMate
	let delimitMate_expand_cr = 1
	let delimitMate_expand_space = 0
	let delimitMate_nesting_quotes = ['`']

" Deoplete
	" set completeopt-=preview
	" let g:deoplete#enable_at_startup = 1
	" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Deoplete Clang
	" let g:deoplete#sources#clang#libclang_path='/usr/lib/libclang.so'
	" let g:deoplete#sources#clang#clang_header='/lib/clang/'

	" if filereadable("./testkit.settings") || filereadable("./main.c")
	" 	redir! > ./.clang
	" 	silent! echon 'flags = ' g:includepath
	" 	redir END
	" endif

" Indent Guides
	let g:indentguides_spacechar = '▏'
	let g:indentguides_tabchar = '▏'

" LanguageClient-neovim
	autocmd FileType rust nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>

	let g:LanguageClient_serverCommands = {
		\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
	\ }
	let g:LanguageClient_loadSettings = 1
	"
" NCM
	set shortmess+=c
	let g:cm_completed_snippet_engine = "ultisnips"
	let g:cm_matcher = {'module': 'cm_matchers.abbrev_matcher', 'case': 'case'}
	let g:cm_refresh_length = 2
	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>

	let g:cm_sources_override = {
				\ 'cm-tags': {'enable':0}
    \ }

" NCM Clang
	if filereadable("./testkit.settings") || filereadable("./main.c")
		redir! > ./.clang_complete
		silent! echon g:includepath
		redir END
	endif

" NERDTree
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Tagbar
	let g:tagbar_sort = 0
	let g:tagbar_compact = 1
	autocmd FileType c,cpp nested :TagbarToggle

