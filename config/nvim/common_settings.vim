" Common Settings
	set encoding=utf-8
	set mouse=a
	set number
	set cursorline
	set relativenumber
	syntax on
	set path+=**
	set wildmenu
	set termguicolors
	colorscheme base16-tomorrow-night
	set updatetime=350
	set signcolumn=yes
	set wrap
	set linebreak
	set scrolloff=5
	set foldcolumn=0

" Folds
	set foldmethod=indent
	set foldlevelstart=20    " Disables automatic closing of all folds on fileopen
	hi Folded ctermfg=black
	hi Folded ctermbg=white

" Tabs, trailing spaces
	set listchars=tab:▏\ ,eol:\ ,extends:,precedes:,space:\ ,trail:⋅
	set list

" Splits
	set noequalalways
	set splitright
	set splitbelow

" Tabs
	set noexpandtab
	set tabstop=4
	set shiftwidth=4
	set smartindent

" Highlights
	highlight EndOfBuffer guifg=#1D1F21
	highlight ALEErrorSign guibg=#282a2e guifg=#cc6666
	highlight LineNr guifg=#6c6d6c
	highlight NonText guifg=#4d4d4d
	highlight Search guifg=#282a2e
	highlight IncSearch guifg=#282a2e
	highlight Ignore guifg=#969896

	" Highlightings for C/C++ types and struct/class members.
	autocmd FileType c,cpp,h,hpp
				 \ syntax match Type "\v<\w+_t>"                            |
				 \ syntax match Type "\v<__signed>"                         |
				 \ syntax match Type "\v<(v|u|vu)\w+(8|16|32|64)>"          |
				 \ syntax match Type "\v<(v|u|vu)?(_|__)?(int|short|char)>" |
				 \ syntax match Type "\v<(v)?(_|__)?(s|u)(8|16|32|64)>"     |
				 \ syntax match ErrorMsg "\v(-\>|\.)@<=(\s+)?\w+"           |
				 \ syntax match Function "\v(-\>|\.)@<=(\s+)?\w+(\(.*\))@=" |

