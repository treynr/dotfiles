"""" file:	.vimrc
"""" desc:	vim configuration file.
""

execute pathogen#infect()

filetype plugin indent on

"" Vim airline settings
let g:airline_powerline_fonts = 1
set laststatus=2

"" Prevent automatic indentation removal from python/bash comments
"" ^H is entered with Ctrl-V Ctrl-H
inoremap # X#
" Remap the escape key to Alt h
imap <A-h> <Esc>
"" Syntax highlighting
syntax on

"" 90 char wide lines
set textwidth=90
"" 256 colors, remember to enable in PuTTY
set t_Co=256
"" Vim command history limited to N commands
set history=666
"" Use relative line numbers (unsupported by older versions on the ECS servers)
if exists('+relativenumber')
	set relativenumber
endif
"" Use line numbers
set number
"" Default to case-insensitive searches
set ignorecase
"" Case-sensitive searches depending on the given pattern
set smartcase
"" Don't highlight shit when searching
set nohlsearch
"" Color scheming
set background=dark
colorscheme b16-term
"" Don't convert tabs to spaces
set expandtab
set smarttab
"" Number of columns used for indents
set shiftwidth=4
"" Number of columns used for tabs
set tabstop=4
"" Auto indent based on indentation from the previous line
set ai
"" Inserts a level of indentation in certain cases
set si
"" Highlight matching braces
set showmatch
"" Hit F2 for copy pasta mode
set pastetoggle=<F2>
"" Fix backspace
set backspace=2
"" Column + row numbers in the status line
set ruler
set ff=unix

"" Treat some files differently depending on their extensions.
"" Text files, most of these options are useful for prose editing
autocmd BufRead,BufNewFile *.txt setlocal textwidth=90 wrap linebreak nolist wrapmargin=0 formatoptions+=nt expandtab
"" Files with no extensions are treated as text files
autocmd BufRead,BufNewFile * if &ft == '' | set ft=txt | endif

let g:python_highlight_all=1
let g:python_version_2=1

