""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basics
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
let mapleader=","
let maplocalleader="\\"
set spelllang=en_us spellfile=$HOME/.vim/spell/en-utf-8.add

colorscheme ariporad

" start Vundle
call plug#begin('~/.vim/plugged')


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Dvorak
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" movement keys (also make them nice to soft wrapping)
noremap h h
noremap H H
noremap t gj
noremap T gJ
noremap n gk
noremap N gK
noremap s l
noremap S L

" restore access to the commands we just overrode
noremap j n
noremap J N
noremap k s
noremap K S
noremap l t
noremap L T

" easy access to the beginning and end of lines, being nice to soft wrapping
noremap _ g$
noremap - g^

" break old habits
noremap $ <nop>
noremap ^ <nop>

" don't use arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" make it easy to edit the .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" automagically reload the .vimrc after editing	
autocmd! bufwritepost .vimrc source %


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I often hit shift-q when trying to hit ;q, so disable it
nnoremap Q <Nop>

" I kept hitting CMD-Q instead of ;q, so here's another way
noremap <leader>c :xit<CR>
noremap <leader>w :write<CR>

" since ; is easier than :
noremap ; :
noremap : <nop>

" stolen from Gary Bernhardt: switch to the last used file
nnoremap <leader><leader> <c-^>

" when specifying a movement, use p for everything inside the parenthesies (ex. cp)
onoremap p i(

" copy and paste from the real clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>y "+y

" use escape to end a search
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

set laststatus=2                " always show the status line
set hidden                      " don't hide buffers that are in the background
set autowrite                   " save the buffer when it enters the background
set textwidth=0 wrapmargin=0    " don't hard wrap TODO
set hlsearch incsearch          " highlight search results as you type
set copyindent preserveindent   " try to preserve existing indentation
set noet sts=0 sw=4 ts=4        " use the right indentation (tabs)
set autoread                    " reload files from disk if they've changed
set nolist                      " don't show invisibles
set backspace=indent,eol,start  " make backspace do the right thing
set backupcopy=yes              " not entirely sure what this does
set colorcolumn=101             " highlight the 101st column
set numberwidth=4               " make the line numbers use four columns
set nrformats=hex,bin,alpha     " make CTRL-X/CTRL-A do the right thing

" shamelessly stolen from jeffkreeftmeijer.com/vim-number: hybrid line numbers
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Window Managment
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set winheight=30                " this gets overridden later
set winminheight=8              " make every window at least eight lines tall
set winwidth=100                " try to make the active window at least 100 lines tall
set winminwidth=30              " make every window at least 30 lines wide
au VimEnter * set winheight=999 " setting winheight=999 normally makes everything explode, idk why

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Linting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fuzzy Finder
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unix
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-eunuch'
Plug 'airblade/vim-gitgutter'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous Helpers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" Occasionally, I'll want to open a markdown file in Byword.app
function! OpenInByword()
	" https://vi.stackexchange.com/a/1958
	silent exec "!open -a /Applications/Byword.app \"%\"" | redraw!
endfunction
command! Byword :call OpenInByword()

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

" DIY commenting
augroup comments
	autocmd!
	autocmd FileType javascript nnoremap <buffer> <localleader>c I// <esc>
	autocmd FileType javascript vnoremap <buffer> <localleader>c <esc>`<i/* <esc>`>a */<esc>
	autocmd FileType html nnoremap <buffer> <localleader>c I<!-- <esc>E --><esc>
	autocmd FileType html vnoremap <buffer> <localleader>c <esc>`<i<!-- <esc>`>a --><esc>
	autocmd FileType css nnoremap <buffer> <localleader>c <esc>I/* <esc>A */<esc>
	autocmd FileType css vnoremap <buffer> <localleader>c <esc>`<i/* <esc>`>a */<esc>
	autocmd FileType python nnoremap <buffer> <localleader>c I# <esc>
	" TODO: Python multi-line
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prose
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'junegunn/goyo.vim'
let g:goyo_width=106 " 100 chars + gutter

function! s:goyo_enter()
	set number relativenumber " Goyo does weird stuff with line numbers. Fix it.
	set wrap linebreak nolist " soft wrapping
	set scrolloff=999         " typewriter mode
	set spell                 " spell check
endfunction

function! s:goyo_leave()
	set nowrap nolinebreak    " no soft wrapping
	set scrolloff=0           " no typewritter mode
	set nospell               " no spell check
endfunction

augroup goyo_custom
	autocmd!
	autocmd! User GoyoEnter nested call <SID>goyo_enter()
	autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

" Misc
Plug 'editorconfig/editorconfig-vim' " TODO


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'jtratner/vim-flavored-markdown'
augroup markdown
	au!
	au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Javascript
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YAML
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup yaml
	au!
	" for some stupid reason, yaml insists upon two spaces of indentation
	" needless to say, this is objectively incorrect behevior
	au BufNewFile,BufRead *.yaml,*.yml,*.sls setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

call plug#end()
