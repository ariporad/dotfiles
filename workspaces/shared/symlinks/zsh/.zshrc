# Managing a big rc file is a mess, so split it up into lots of little easy-to-manage files
# Stolen from Ubuntu's default /etc/profile
if [ -d ~/.profile.d ]; then
  for i in ~/.profile.d/*.sh; do
    if [ -r $i ]; then
      source $i
    fi
  done
  unset i
fi