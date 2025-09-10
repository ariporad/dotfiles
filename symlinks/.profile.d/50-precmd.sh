# Always show the directory in the titlebar (This is for automatic time tracking)
# https://superuser.com/a/414953
function precmd() {
	echo -ne "\e]1;${PWD//$HOME/~}\a"
}