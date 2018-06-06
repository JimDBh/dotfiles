set nocompatible
filetype off

" Plugins
	let github = 'https://github.com/'
	let gitlag = 'https://gitlab.com/'

	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
	Plugin 'VundleVim/Vundle.vim'

	" Look
		Plugin github.'chriskempson/base16-vim'
		Plugin github.'vim-airline/vim-airline'
		Plugin github.'vim-airline/vim-airline-themes'

	" Tools
		Plugin github.'andreyorst/SimpleSnippets.vim'
		Plugin github.'andreyorst/SimpleSnippets-snippets'
		Plugin github.'craigemery/vim-autotag'
		Plugin github.'junegunn/goyo.vim'
		Plugin github.'justinmk/vim-sneak'
		Plugin github.'majutsushi/tagbar'
		Plugin github.'Raimondi/delimitMate'
		Plugin github.'scrooloose/nerdtree'
		Plugin github.'Shougo/deoplete.nvim'
		Plugin github.'Shougo/denite.nvim'
		Plugin github.'tpope/vim-surround'
		Plugin github.'w0rp/ale'

	" Rust
		Plugin github.'rust-lang/rust.vim'

	" C/C++
		Plugin github.'octol/vim-cpp-enhanced-highlight'
		Plugin github.'zchee/deoplete-clang'

	" Syntax Highlighting
		Plugin github.'justinmk/vim-syntax-extra'

	call vundle#end()

filetype plugin indent on

" Settings
	source ~/.config/nvim/common_settings.vim
	source ~/.config/nvim/plugin_configs.vim
	source ~/.config/nvim/mappings.vim
	source ~/.config/nvim/functions.vim

