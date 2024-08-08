SPACESHIP_PROMPT_ORDER=(
  user           # Username section
  dir            # Current directory section
  host           # Hostname section
  git            # Git section (git_branch + git_status)
  package        # Package version
  node           # Node.js section
  docker         # Docker section
  docker_compose # Docker section
  ansible        # Ansible section
  terraform      # Terraform workspace section
  gnu_screen     # GNU Screen section
  async          # Async jobs indicator
  line_sep       # Line break
  battery        # Battery level and status
  sudo           # Sudo indicator
  char           # Prompt character
)

SPACESHIP_RPROMPT_ORDER=(
  exit_code      # Exit code section
  exec_time      # Execution time
  jobs           # Background jobs indicator
  aws            # Amazon Web Services section
  kubectl        # Kubectl context section
  venv           # virtualenv section
  golang         # Go section
  ruby           # Ruby section
  python         # Python section
  perl           # Perl section
  php            # PHP section
  rust           # Rust section
  java           # Java section
  time           # Time stamps section
)

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_12HR=true
# Do not truncate path in repos
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true

SPACESHIP_PYTHON_SHOW=always

# Symbol overrides
SPACESHIP_AWS_SYMBOL="  "
SPACESHIP_CHAR_SYMBOL="❯ "
