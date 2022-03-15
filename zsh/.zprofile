if whence -p pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  alias vim="PYTHONPATH=$(python -m site --user-site) vim"
fi
