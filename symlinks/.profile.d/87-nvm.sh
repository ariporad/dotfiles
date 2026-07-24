export NVM_DIR="$HOME/.nvm"

# Sourcing nvm.sh on every shell costs ~700ms. Instead, cheaply add the default
# node's bin dir straight to PATH so node/npm/npx/yarn are real binaries (visible
# to subprocesses too), and only source the full nvm lazily when you actually
# need to manage versions. This is all builtins/globs -- no subprocess.
if [ -r "$NVM_DIR/alias/default" ]; then
  _nvm_default="${$(<"$NVM_DIR/alias/default")#v}"
  # (Nn): null_glob so no match => empty, and numeric sort so v20.9 < v20.19.
  _nvm_bins=("$NVM_DIR/versions/node/v${_nvm_default}"*/bin(Nn))
  [ -z "$_nvm_bins" ] && _nvm_bins=("$NVM_DIR/versions/node/"*/bin(Nn))  # fall back to newest
  [ -n "$_nvm_bins" ] && export PATH="${_nvm_bins[-1]}:$PATH"
  unset _nvm_default _nvm_bins
fi

# Lazy-load the real nvm (and completion) on first use, then hand off.
# NOTE: this lazy-loading setup was written by Claude (2026-06-30).
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
