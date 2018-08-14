" My basic .vimrc only contains mappings. It's what I'll feed into IdeaVim or VsVim.
source $HOME/.vimrc.basic
colorscheme ariporad

" start Vundle
call plug#begin('~/.vim/plugged')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-vinegar'

let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

noremap <C-\> :Lexplore<CR>

" https://unix.stackexchange.com/a/42939
augroup netrw_dvorak_fix
	autocmd!
	autocmd filetype netrw call Fix_netrw_maps_for_dvorak()
augroup END
function! Fix_netrw_maps_for_dvorak()
	noremap <buffer> h h
	noremap <buffer> H H
	noremap <buffer> t j
	noremap <buffer> T J
	noremap <buffer> n k
	noremap <buffer> N K
	noremap <buffer> s l
	noremap <buffer> S L
	setlocal winwidth=20 winminwidth=20
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocomplete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif
"let g:deoplete#enable_at_startup = 1
"Plug 'fszymanski/deoplete-emoji'
"Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
"let g:deoplete#sources#ternjs#types = 1
"let g:deoplete#sources#ternjs#docs = 1
"
"set completeopt-=preview
"" https://gregjs.com/vim/2016/configuring-the-deoplete-asynchronous-keyword-completion-plugin-with-tern-for-vim/ 
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif


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
" Status Line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('nvim')
	python from powerline.vim import setup as powerline_setup
	python powerline_setup()
	python del powerline_setup
else
	let g:airline_powerline_fonts = 1
	let g:airline#extensions#tabline#left_sep = ' '
	let g:airline#extensions#tabline#left_alt_sep = '|'
	let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
endif


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

" Really basic runner
" To use: run it once manually (ie. :!./script.blah), then use <leader>t to write & run
nnoremap <leader>t :w\|!!<CR>


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

	" fix common mispellings
	inoremap <buffer> teh the
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
" LESS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'groenewege/vim-less'


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
