" Airline theme matching the 'ariporad' colorscheme.
"
" Every color below is lifted verbatim from a highlight group in
" ~/.vim/colors/ariporad.vim, so the statusline stays inside the palette the
" rest of the editor already uses. The group each pair comes from is named in
" the comment beside it.
"
" The colorscheme is dark-only, so there is no light variant.

let s:theme = 'ariporad'

function! airline#themes#{s:theme}#refresh()
	" ------------------------------------------------------------------
	" Section B / C — shared by every mode.
	" B is the middle chunk (git branch); C is the wide filename field.
	" ------------------------------------------------------------------
	let s:B = [ '#bcbcbc', '#3a3a3a', 250, 237 ]  " fg CursorLineNr / bg Pmenu
	let s:C = [ '#9e9e9e', '#262626', 247, 235 ]  " StatusLineNC

	" ------------------------------------------------------------------
	" Section A — the mode chip.
	"
	" Normal mode is deliberately neutral: it is the resting state, so it
	" gets the scheme's tab gray rather than an accent. The saturated
	" colors are spent on the modes worth flagging, and each is a hue the
	" scheme already leans on heavily (blue keywords, olive strings)
	" rather than a color that appears once or twice.
	" ------------------------------------------------------------------
	let s:N = [ '#262626', '#a8a8a8', 235, 248 ]  " TabLine       (gray)
	let s:I = [ '#080808', '#87afd7', 232, 110 ]  " Statement     (blue)
	let s:R = [ '#080808', '#ff8787', 232, 210 ]  " DiffDelete bg (red)
	let s:V = [ '#080808', '#ffffaf', 232, 229 ]  " Visual        (yellow)
	let s:T = [ '#080808', '#afaf87', 232, 144 ]  " String        (olive)

	" Inactive splits: Comment gray, so unfocused windows recede.
	let s:IA = [ '#777777', '#262626', 244, 235 ]  " Comment on StatusLine bg

	" Error / warning chips, used by the ALE + syntastic extensions.
	let s:ER = [ '#e4e4e4', '#af0000', 254, 124 ]  " ErrorMsg
	let s:WI = [ '#080808', '#d7af00', 232, 178 ]  " Todo

	let palette = {}

	let palette.normal   = airline#themes#generate_color_map(s:N, s:B, s:C)
	let palette.insert   = airline#themes#generate_color_map(s:I, s:B, s:C)
	let palette.replace  = airline#themes#generate_color_map(s:R, s:B, s:C)
	let palette.visual   = airline#themes#generate_color_map(s:V, s:B, s:C)
	let palette.terminal = airline#themes#generate_color_map(s:T, s:B, s:C)
	let palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

	for s:mode in ['normal', 'insert', 'replace', 'visual', 'terminal']
		let palette[s:mode].airline_error   = s:ER
		let palette[s:mode].airline_warning = s:WI
	endfor

	" Unsaved buffer: tint just the filename field with DiffChange's yellow
	" rather than recoloring the mode chip, so 'modified' is visible without
	" competing with the mode indicator.
	let s:MOD = { 'airline_c': [ '#d7d787', s:C[1], 186, s:C[3] ] }
	let palette.normal_modified   = s:MOD
	let palette.insert_modified   = s:MOD
	let palette.replace_modified  = s:MOD
	let palette.visual_modified   = s:MOD
	let palette.inactive_modified = { 'airline_c': [ '#87875f', '', 101, '' ] }

	" ------------------------------------------------------------------
	" Tabline (enabled in .vimrc). Selected tab reuses the normal-mode
	" chip so the top and bottom bars agree.
	" ------------------------------------------------------------------
	let palette.tabline = {
		\ 'airline_tab':    s:C,
		\ 'airline_tabsel': s:N,
		\ 'airline_tabtype': s:I,
		\ 'airline_tabfill': s:C,
		\ 'airline_tabmod': s:WI,
		\ 'airline_tabhid': s:IA,
		\ }

	" Accents (readonly flag, etc.) drawn from the syntax colors.
	let palette.accents = {
		\ 'red':    [ '#af0000', '', 124, '' ],
		\ 'green':  [ '#87af87', '', 108, '' ],
		\ 'blue':   [ '#87afd7', '', 110, '' ],
		\ 'yellow': [ '#d7af00', '', 178, '' ],
		\ 'orange': [ '#d78700', '', 172, '' ],
		\ 'purple': [ '#87d7d7', '', 116, '' ],
		\ 'bold':   [ '', '', '', '', 'bold' ],
		\ 'italic': [ '', '', '', '', 'italic' ],
		\ }

	let g:airline#themes#{s:theme}#palette = palette
endfunction

call airline#themes#{s:theme}#refresh()
