export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
[[ -d $(pyenv root)/plugins/pyenv-virtualenv ]] && eval "$(pyenv virtualenv-init -)"
