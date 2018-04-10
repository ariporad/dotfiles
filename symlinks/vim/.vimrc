set nocompatible

let mapleader=","
let maplocalleader="\\"

" Disable Ex Mode
nnoremap Q <Nop>

set backupcopy=yes
set colorcolumn=101

" Make it easy to edit the .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Automagically reload the .vimrc after editing	
autocmd! bufwritepost .vimrc source %

set guifont=Source\ Code\ Pro\ for\ Powerline:h14 

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

" Since ; is easier than :
map ; :

nnoremap <leader><leader> <c-^>

augroup comments
	autocmd!
	autocmd FileType javascript nnoremap <buffer> <localleader>c I// <esc>
	autocmd FileType javascript vnoremap <buffer> <localleader>c <esc>`<i/* <esc>`>a */<esc>
	autocmd FileType html nnoremap <buffer> <localleader>c I<!-- <esc>E --><esc>
	autocmd FileType html vnoremap <buffer> <localleader>c <esc>`<i<!-- <esc>`>a --><esc>
	autocmd FileType css nnoremap <buffer> <localleader>c <esc>I/* <esc>A */<esc>
	autocmd FileType css vnoremap <buffer> <localleader>c <esc>`<i/* <esc>`>a */<esc>
	autocmd FileType python nnoremap <buffer> <localleader>c I# <esc>
"	TODO: Python multi-line
augroup END

onoremap p i(


" set the runtime path to include Vundle and initialize
call plug#begin('~/.vim/plugged')

" These are for vimfiler, an alternative to NERDTree
" VimFiler disabled until I can make it work with dvorak
"Plug 'Shougo/unite.vim'
"Plug 'Shougo/vimfiler.vim'
"let g:vimfiler_as_default_explorer = 1
"let g:vimfiler_ignore_pattern = '^\%(\.git\|\.DS_Store\)$'

" Lint
Plug 'w0rp/ale'
let g:ale_fixers = {
\	'javascript': ['eslint'],
\}
let g:ale_linters = {
\   'javascript': ['eslint'],
\}

let g:ale_sign_error = "◉"
let g:ale_sign_warning = "◉"
let g:ale_fix_on_save = 1
hi link ALEErrorSign    Error
hi link ALEWarningSign  Warning
hi link ALEStyleError   ErrorMsg
hi link ALEStyleWarning   WarningMsg

" Fuzzy Finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
augroup fzf
	autocmd!

	nnoremap <leader>. :FZF<CR>

	" Mapping selecting mappings
	nmap <leader><tab> <plug>(fzf-maps-n)
	xmap <leader><tab> <plug>(fzf-maps-x)
	omap <leader><tab> <plug>(fzf-maps-o)
	
	" Insert mode completion
	imap <c-x><c-k> <plug>(fzf-complete-word)
	imap <c-x><c-f> <plug>(fzf-complete-path)
	imap <c-x><c-j> <plug>(fzf-complete-file-ag)
	imap <c-x><c-l> <plug>(fzf-complete-line)
augroup END


" Pretty Writing
Plug 'junegunn/goyo.vim'

" Misc
Plug 'editorconfig/editorconfig-vim'

" Markdown
Plug 'jtratner/vim-flavored-markdown'
augroup markdown
	au!
	au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Javascript
"Plug 'moll/vim-node'
"Plug 'ternjs/tern_for_vim'
Plug 'pangloss/vim-javascript'
let g:javascript_plugin_flow = 1
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0
Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key='<localleader>p'
Plug 'prettier/vim-prettier', {
    \ 'do': 'npm install',
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss'] }
let g:prettier#autoformat = 0
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0
autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx,*.css,*.scss,*.less PrettierAsync
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
"Plug 'hynek/vim-python-pep8-indent'
"Plug 'tmhedberg/SimpylFold'

" Arduino
" Plug 'stevearc/vim-arduino', { 'do': './install.py --tern-completer' }

" Plug 'Valloric/YouCompleteMe'
"Plug 'rizzatti/dash.vim'

" Git
"Plug 'tpope/vim-fugitive'

" Taskpaper
"Plug 'davidoc/taskpaper.vim'

" All of your Plugins must be added before the following line
call plug#end()

set number
colorscheme ariporad

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
