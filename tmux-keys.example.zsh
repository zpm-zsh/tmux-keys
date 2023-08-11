
left_status=''

function unbind_keys() {
  tmux unbind-key -n F1
  tmux unbind-key -n F2
  tmux unbind-key -n F3
  tmux unbind-key -n F4
  tmux unbind-key -n F5
  tmux unbind-key -n F6
  tmux unbind-key -n F7
  tmux unbind-key -n F8
  tmux unbind-key -n F9
  tmux unbind-key -n F10
  tmux unbind-key -n F11
  tmux unbind-key -n F12
}

function create_key() {
  if [ "$4" = "-s" ]; then
    tmux bind-key -n F${1} send-keys $keys[$1] "$3
"
  elif [ "$4" = "-t" ]; then
    tmux bind-key -n F${1} send-keys $keys[$1] "$3"
  elif [ "$4" = "-v" ]; then
    tmux bind-key -n "F${1}" run-shell "zsh /tmp/zsh-1000/tmux-keys.zsh '$3'"
  elif [ "$4" = "-b" ]; then
    tmux bind-key -n F${1} "$3"
  fi
}

function set_status() {
  tmux set -g status-right "$left_status"
}

  
a02c83a7dbd96295beaefb72c2bee2de_view() {
  unbind_keys

  create_key 1 "←" 'previous-window' '-b'
  left_status+="#[bg=colour3,fg=colour0,bold] ← #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "→" 'next-window' '-b'
  left_status+="#[bg=colour2,fg=colour0,bold] → #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour1,fg=colour0,bold] Menu #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "$(_tmux_prompt)" 'true' '-s'
  left_status+="#[bg=colour4,fg=colour0,bold] $(_tmux_prompt) #[fg=default,bg=default]"

  set_status
}
    
b61541208db7fa7dba42c85224405911_view() {
  unbind_keys

  create_key 1 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' '-v'
  left_status+="#[bg=colour12,fg=colour0,bold] Main #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "Git functions" '520cf8ae214858229a683e2853e343cc_view' '-v'
  left_status+="#[bg=colour1,fg=colour0,bold] Git functions #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "NPM functions" 'e3b54fd200a08e098757b4bb10fec678_view' '-v'
  left_status+="#[bg=colour1,fg=colour0,bold] NPM functions #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "ZPM functions" 'cf2fa0e1a2c6046d54edb86fb8cae4dc_view' '-v'
  left_status+="#[bg=colour3,fg=colour0,bold] ZPM functions #[fg=default,bg=default]"

  set_status
}
    
520cf8ae214858229a683e2853e343cc_view() {
  unbind_keys

  create_key 1 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour5,fg=colour0,bold] Menu #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "Git Status" 'git status' '-s'
  left_status+="#[bg=colour5,fg=colour0,bold] Git Status #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "Git Branch" 'git branch' '-s'
  left_status+="#[bg=colour14,fg=colour0,bold] Git Branch #[fg=default,bg=default]"

  set_status
}
    
e3b54fd200a08e098757b4bb10fec678_view() {
  unbind_keys

  create_key 1 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour1,fg=colour0,bold] Menu #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "NPM list" 'npm ls' '-s'
  left_status+="#[bg=colour14,fg=colour0,bold] NPM list #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "NPM Install" 'npm i ' '-t'
  left_status+="#[bg=colour6,fg=colour0,bold] NPM Install #[fg=default,bg=default]"

  set_status
}
    
cf2fa0e1a2c6046d54edb86fb8cae4dc_view() {
  unbind_keys

  create_key 1 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour1,fg=colour0,bold] Menu #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "Upgrade Plugins" 'zpm upgrade' '-s'
  left_status+="#[bg=colour9,fg=colour0,bold] Upgrade Plugins #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "Clean Cache" 'zpm clean' '-s'
  left_status+="#[bg=colour6,fg=colour0,bold] Clean Cache #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "Readme" 'zpm readme' '-t'
  left_status+="#[bg=colour12,fg=colour0,bold] Readme #[fg=default,bg=default]"

  set_status
}
    

case $1 in
		a02c83a7dbd96295beaefb72c2bee2de_view) a02c83a7dbd96295beaefb72c2bee2de_view ;;
		b61541208db7fa7dba42c85224405911_view) b61541208db7fa7dba42c85224405911_view ;;
		520cf8ae214858229a683e2853e343cc_view) 520cf8ae214858229a683e2853e343cc_view ;;
		e3b54fd200a08e098757b4bb10fec678_view) e3b54fd200a08e098757b4bb10fec678_view ;;
		cf2fa0e1a2c6046d54edb86fb8cae4dc_view) cf2fa0e1a2c6046d54edb86fb8cae4dc_view ;;
    *) a02c83a7dbd96295beaefb72c2bee2de_view
esac

  