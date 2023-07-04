antigen apply # actually setup the plugins

# Now add yarn global modules to $PATH. We can't do this until after antigen apply, because antigen
# sets up nvm, which sets up yarn.
export PATH="$PATH:`yarn global bin`"