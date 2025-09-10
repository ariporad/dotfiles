# Commonly used for `do_long_thing && beep`
function beep() { osascript -e 'beep' }

# Handy shortcut to edit the hosts file
function hosts() {
	sudo $EDITOR /private/etc/hosts
	dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

# Generate a .gitignore
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# This has been somewhat replaced by fkill
function whosOnPort(){ lsof -n -i4TCP:$1 | grep LISTEN }

# Set the title of the terminal: http://superuser.com/a/599156
function settitle() { echo -ne "\033]0;"$*"\007" }

function ev() {
	vim ~/.zshrc
	. ~/.zshrc
}
