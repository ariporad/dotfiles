set nocompatible

let mapleader=","

" Disable Ex Mode
nnoremap Q <Nop>

set backupcopy=yes
set colorcolumn=101

" dvorak remap
" movement keys
noremap h h
noremap H H
noremap t j
noremap T J
noremap n k
noremap N K
noremap s l
noremap S L

" Now, restore access to the commands we just overrode
noremap j n
noremap J N
noremap k s
noremap K S
noremap l t
noremap L T

" easy access to beginning and end of line
noremap - $
noremap _ ^

" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')

" These are for vimfiler, an alternative to NERDTree
" VimFiler disabled until I can make it work with dvorak
"Plug 'Shougo/unite.vim'
"Plug 'Shougo/vimfiler.vim'
"let g:vimfiler_as_default_explorer = 1
"let g:vimfiler_ignore_pattern = '^\%(\.git\|\.DS_Store\)$'

" Allow Auto-Commenting
Plug 'scrooloose/nerdcommenter'

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Misc
Plug 'editorconfig/editorconfig-vim'

" Markdown
Plug 'jtratner/vim-flavored-markdown'
augroup markdown
	au!
	au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Javascript
"Plug 'othree/yajs.vim'
"Plug 'othree/es.next.syntax.vim'
"Plug 'maksimr/vim-jsbeautify'
"Plug 'elzr/vim-json'
"Plug 'mxw/vim-jsx'
Plug 'moll/vim-node'
Plug 'ternjs/tern_for_vim'
Plug 'pangloss/vim-javascript'
Plug 'prettier/vim-prettier', {
    \ 'do': 'npm install',
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss'] }
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.css,*.scss,*.less Prettier
let g:prettier#config#print_width = 100
let g:prettier#config#tab_width = 4
let g:prettier#config#use_tabs = 'true'
let g:prettier#config#semi = 'true'
let g:prettier#config#single_quote = 'true'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'true'
let g:prettier#config#trailing_comma = 'es5'
let g:prettier#config#parser = 'babylon'


" Python
Plug 'hynek/vim-python-pep8-indent'
Plug 'tmhedberg/SimpylFold'

" Arduino
" Plug 'stevearc/vim-arduino', { 'do': './install.py --tern-completer' }

" Plug 'Valloric/YouCompleteMe'
Plug 'rizzatti/dash.vim'

" Git
Plug 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call plug#end()

set number
colorscheme moody

" Powerline
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

set laststatus=2
set hidden
set autowrite

" use tabs, the proper style of indentation
set noexpandtab
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=4
set tabstop=4
set backspace=indent,eol,start
