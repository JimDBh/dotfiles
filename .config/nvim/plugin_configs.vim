" Airline
	set laststatus=2

	" Bottom row
		if !exists('g:airline_symbols')
			let g:airline_symbols = {}
		endif
		let g:airline_symbols.linenr = '≣'
		"set noshowmode

	" Tabs
		let g:airline#extensions#tabline#enabled = 1
		let g:airline#extensions#tabline#left_sep = ''
		let g:airline#extensions#tabline#left_alt_sep = ''

	" Theme
		let g:airline_powerline_fonts = 1

" ALE
	let g:airline#extensions#ale#enabled = 1
	let g:ale_lint_delay = 350

	let g:ale_sign_error = '⬥ '
	let g:ale_sign_warning = '⬥ '

	"autocmd FileType rust <Esc>:ALEDisable<Cr>

	let g:ale_linters = {
		\ 'c': ['clang', 'gcc'],
		\ 'cpp': ['clang'],
	\}

	" C/C++
		let g:ale_cpp_clang_options = '-Wall --std=c++11 '
		let g:ale_c_clang_options = '-Wall --std=c99 '
		let g:ale_c_gcc_options = '-Wall --std=c99 '

		let g:includepath = ''

		" NOTE: This piece of code is used to generate clang options for ALE,
		" because we aren't using any build system. You may delete this, or
		" rewrite to your project needs. Basically you can refer to a specific
		" file in your project root, and automatically pass desired options to
		" ALE, and later to Clang. But the main reason I wrote it because, we
		" have special config file, that contains current includepath, for our
		" own build system, so I need to pass it to ALE somehow and detect if
		" it was changed. You can go further and have a separate if() for each
		" project, I have two for now. I understand that this is not the most
		" beautiful way of doing this, but, still, it works fine, and I'm kinda
		" happy with this variant for now.
		if filereadable("./testkit.settings")
			let g:includepath = system('echo -n
						\ -I $(pwd)/include
						\ -I $(pwd)/testpacks/SPW_TESTS/spw_lib_src
						\ -I $(pwd)/testpacks/CAN/can_lib_src
						\ -I $(pwd)/platforms/$(cat ./testkit.settings | grep "?=" |  sed -E "s/.*= //")/include
						\')
		elseif filereadable("./startf.S")
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
		let g:ctrlp_user_command = 'ag %s -l --nocolor --nogroup --hidden -g ""'
	endif

" DelimitMate
	let delimitMate_expand_cr = 1
	let delimitMate_expand_space = 0
	let delimitMate_nesting_quotes = ['`']

" Deoplete
	set completeopt-=preview
	let g:deoplete#enable_at_startup = 1

	" NOTE: Deoplete is now ruled by UltiSnips. This imap is deprecated
	" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Deoplete Clang
	let g:deoplete#sources#clang#libclang_path='/usr/lib/libclang.so'
	let g:deoplete#sources#clang#clang_header='/lib/clang/'

	" NOTE: This piece of code reuses previous code that generates clang
	" options and exports it to file at project root. Again, you may delete
	" it, or rewrite to your project needs.
	if filereadable("./testkit.settings") || filereadable("startf.S")
		redir! > ./.clang
		silent! echon 'flags = ' g:includepath
		redir END
	endif

" LanguageClient-neovim
	autocmd FileType rust nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>

	let g:LanguageClient_serverCommands = {
				\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
				\ }
	let g:LanguageClient_loadSettings = 1

" NERDTree
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Tagbar
	let g:tagbar_sort = 0
	let g:tagbar_compact = 1
	"autocmd FileType c,cpp nested :TagbarToggle

" Ultisnips
	" NOTE: The settings below will make Ultisnips and Deoplete play nice
	" together. Wich means that Deoplete is configured here too. If you'll
	" modify anything here, you'll may loose ability to use deoplete <Tab>
	" mapping wich is also done here

	" Basic stuff
		let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips/']
		let g:UltiSnipsEditSplit="vertical"

	" For sake of manual expanding
		let g:UltiSnipsExpandTrigger="<c-k>"
	" Undefine all jump triggers, because FUNCTIONS
		let g:UltiSnipsJumpForwardTrigger = "<NUL>"
		let g:UltiSnipsJumpBackwardTrigger = "<NUL>"

	" Now onto buiseness
	" If deoplete popup is visible <Cr> will expand or jump. If not it will
	" close deoplete popup and leave everything as is. If used while editing an
	" expanded snippet it will complete the word and jump to next placeholder.
	" Magic!
		"let g:ulti_expand_or_jump_res = 0
		"function! <SID>ExpandOrClosePopup()
		"	let snippet = UltiSnips#ExpandSnippetOrJump()
		"	if g:ulti_expand_or_jump_res > 0
		"		return snippet
		"	else
		"		let close_popup = deoplete#close_popup()
		"		return close_popup
		"	endif
		"endfunction

	" When deoplete popup visible <Tab> acts like <C-n> wich selects next
	" completion item from the list. If there is no popup then <Tab> acts as
	" jump to next snippet placeholder, if we actually editing a snippet. If
	" no popup and no snippet <Tab> acts like <Tab>
		"function! SmartTab()
		"	if pumvisible() == 1
		"		return "\<C-n>"
		"	else
		"		let snippet = UltiSnips#ExpandSnippetOrJump()
		"		if g:ulti_expand_or_jump_res > 0
		"			return snippet
		"		else
		"			return "\<Tab>"
		"		endif
		"	endif
		"endfunction

	" The same as previous, but selects previous item and jumps backwards. Or
	" acts like <S-Tab>
		"function! SmartSTab()
		"	if pumvisible() == 1
		"		return "\<C-p>"
		"	else
		"		let snippet = UltiSnips#JumpBackwards()
		"		if g:ulti_expand_or_jump_res > 0
		"			return snippet
		"		else
		"			return "\<S-Tab>"
		"		endif
		"	endif
		"endfunction

	" Ultisnips + Deoplete mappings
		"inoremap <silent><expr><CR> pumvisible() ? "<C-R>=<SID>ExpandOrClosePopup()<CR>" : delimitMate#WithinEmptyPair() ? "\<C-R>=delimitMate#ExpandReturn()\<CR>" : "\<Cr>"
		"inoremap <silent><Tab>      <C-R>=SmartTab()<CR>
		"snoremap <silent><Tab>      <Esc>:call UltiSnips#JumpForwards()<CR>
		"inoremap <silent><S-Tab>    <C-R>=SmartSTab()<CR>
		"snoremap <silent><S-Tab>    <Esc>:call UltiSnips#JumpBackwards()<CR>

" SimpleSnippets.vim
	let g:SimpleSnippets_dont_remap_tab = 1
	function! ExpandOrClosePopup()
		if SimpleSnippets#isExpandableOrJumpable()
			return "\<Esc>:call SimpleSnippets#expandOrJump()\<Cr>"
		else
			let close_popup = deoplete#close_popup()
			return close_popup
		endif
	endfunction

	inoremap <silent><expr><Tab> pumvisible() ? "\<c-n>" : SimpleSnippets#isExpandableOrJumpable() ? "\<Esc>:call SimpleSnippets#expandOrJump()\<Cr>" : "\<Tab>"
	inoremap <silent><expr><S-Tab> pumvisible() ? "\<c-p>" : SimpleSnippets#isJumpable() ? "\<esc>:call SimpleSnippets#jumpToLastPlaceholder()\<Cr>" : "\<S-Tab>"
	snoremap <silent><expr><Tab> SimpleSnippets#isExpandableOrJumpable() ? "\<Esc>:call SimpleSnippets#expandOrJump()\<Cr>" : "\<Tab>"
	snoremap <silent><expr><S-Tab> SimpleSnippets#isJumpable() ? "\<Esc>:call SimpleSnippets#jumpToLastPlaceholder()\<Cr>" : "\<S-Tab>"
	inoremap <silent><expr><CR> pumvisible() ? "<C-R>=ExpandOrClosePopup()<CR>" : delimitMate#WithinEmptyPair() ? "\<C-R>=delimitMate#ExpandReturn()\<CR>" : "\<Cr>"
