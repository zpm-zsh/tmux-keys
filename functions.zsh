refresh_keys () {
  BUFFER=''
  zle accept-line
}

zle -N refresh_keys

function prefix_keys() {
  pr_shortkeys=(" -- %{$fg_bold[cyan]%}$state_name%{$reset_color%}")
}

function suffix_keys() {
  pr_shortkeys+=(" --")
}

function unbind_keys() {
  for key in "$keys[@]"; do
    bindkey -s "$key" ''
  done
}

function set_state() {
  state=$1
}

function set_state_name() {
  state_name=$1
}

function create_key() {
  pr_shortkeys+=("%{$fg_bold[blue]%}F${1}%{$fg_bold[yellow]%}:%{$fg_bold[green]%}${2}%{$reset_color%}")
  
  if [ "$4" = "-s" ]; then
    bindkey -s $keys[$1] "$3 \n"
  else
    bindkey  $keys[$1] "$3"
  fi
}

keys=('^[OP' '^[OQ' '^[OR' '^[OS' '^[[15~' '^[[17~' '^[[18~' '^[[19~' '^[[20~' '^[[21~' '^[[23~' '^[[24~')
