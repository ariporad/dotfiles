set nocompatible

let mapleader=","
let maplocalleader="\\"

" Disable Ex Mode
nnoremap Q <Nop>

" Make it easy to edit the .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Automagically reload the .vimrc after editing	
autocmd! bufwritepost .vimrc source %

set guifont=Source\ Code\ Pro\ for\ Powerline:h14 

" dvorak remap
" movement keys
noremap h h
noremap H H
noremap t gj
noremap T gJ
noremap n gk
noremap N gK
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
noremap _ g$
noremap - g^

" break old habits
noremap $ <nop>
noremap ^ <nop>

" Since ; is easier than :
noremap ; :
noremap : <nop>
noremap <leader>c :xit<CR>
noremap <leader>w :write<CR>

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
\	'javascript': ['prettier', 'eslint'],
\}
let g:ale_linters = {
\   'javascript': ['eslint'],
\}
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --use-tabs 
			\--tab-width 4 --printWidth 100'

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
let g:goyo_width=106

function! s:goyo_enter()
	set number relativenumber " Goyo does weird stuff with line numbers. Fix it.
	set wrap linebreak nolist " soft wrapping
	set scrolloff=999         " typewriter mode
endfunction

function! s:goyo_leave()
	set nowrap nolinebreak    " no soft wrapping
	set scrolloff=0           " no typewritter mode
endfunction

augroup goyo_custom
	autocmd!
	autocmd! User GoyoEnter nested call <SID>goyo_enter()
	autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END


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

Plug 'alvan/vim-closetag'
let g:closetag_xhtml_filenames = "*.xhtml,*.jsx,*.js"
let g:closetag_emptyTags_caseSensitive = 1

Plug 'tpope/vim-eunuch'

Plug 'airblade/vim-gitgutter'

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

augroup yaml
	au!
	au BufNewFile,BufRead *.yaml,*.yml,*.sls setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

" Powerline
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Make the tab key indent at the start of a line, then autocomplete
" Stolen from https://github.com/garybernhardt/dotfiles/blob/master/.vimrc#L167
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" Remove fancy charecters (smart quotes, etc.)
" Stolen from https://github.com/garybernhardt/dotfiles/blob/master/.vimrc#L492
function! RemoveFancyCharacters()
    let typo = {}
    let typo["“"] = '"'
    let typo["”"] = '"'
    let typo["‘"] = "'"
    let typo["’"] = "'"
    let typo["–"] = '--'
    let typo["—"] = '---'
    let typo["…"] = '...'
    :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()

nnoremap <silent> <leader>f *
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>



set laststatus=2
set hidden
set autowrite
set textwidth=0
set wrapmargin=0
set hlsearch
set incsearch
set noerrorbells

" use tabs, the proper style of indentation
set copyindent
set preserveindent
set noexpandtab
set softtabstop=0
set shiftwidth=4
set tabstop=4
set autoread
set nolist
set backspace=indent,eol,start
set backupcopy=yes
set colorcolumn=101
set numberwidth=4

set winheight=30
set winminheight=8
set winwidth=100
set winminwidth=30
set nrformats=hex,bin,alpha
au VimEnter * set winheight=999

" From https://jeffkreeftmeijer.com/vim-number/
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

nnoremap <leader>w :w<CR>

nnoremap <leader>pH <C-w>H
nnoremap <leader>pT <C-w>J
nnoremap <leader>pN <C-w>K
nnoremap <leader>pS <C-w>L
nnoremap <leader>ph <C-w>h
nnoremap <leader>pt <C-w>j
nnoremap <leader>pn <C-w>k
nnoremap <leader>ps <C-w>l
nnoremap <leader>pr <C-w>r
nnoremap <leader>pe <C-w>=
nnoremap <leader>pr <C-w>r
nnoremap <leader>pw <C-w><C-w>
