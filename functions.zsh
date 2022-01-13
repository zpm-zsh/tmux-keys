# refresh_keys () {
#   BUFFER=''
#   zle accept-line
# }

# zle -N refresh_keys

function get_color() {
  echo -n "#[bg=colour${1},fg=colour0,bold]"
}

function prefix_keys() {
  pr_shortkeys=('')
}

function suffix_keys() {
  pr_shortkeys+=("#[bg=colour8,fg=colour7,bold] ${state_name} #[fg=default,bg=default]")
}

function set_state() {
  state=$1
}

function set_state_name() {
  state_name=$1
}

function create_key() {
  pr_shortkeys+=("$(get_color $1) F$((${1}+4)):${2} #[fg=default,bg=default]")

  if [ "$4" = "-s" ]; then
    bindkey -s $keys[$1] "$3 \n"
  elif [ "$4" = "-v" ]; then
    bindkey $keys[$1] "$3"
  elif [ "$4" = "-t" ]; then
    bindkey -s $keys[$1] "$3"
  fi
}

function write_to_file() {
  echo "$pr_shortkeys" >! "${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys-generated.log"
}

function unbind_keys() {
  for key in "$keys[@]"; do
    bindkey -s "$key" ''
  done
}

keys=( '^[[15~' '^[[17~' '^[[18~' '^[[19~' '^[[20~' '^[[21~' '^[[23~' '^[[24~')
