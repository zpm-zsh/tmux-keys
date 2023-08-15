
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
    tmux bind-key -n "F${1}" run-shell "zsh ${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh '$3'"
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
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour2,fg=colour0,bold] ← #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "→" 'next-window' '-b'
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour2,fg=colour0,bold] → #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "$(_tmux_uname)" 'neofetch' '-s'
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour3,fg=colour0,bold] $(_tmux_uname) #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "$(_tmux_myip)" 'ip addr' '-s'
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour1,fg=colour0,bold] $(_tmux_myip) #[fg=default,bg=default]"
  left_status+=' '
  create_key 5 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 5 #[bg=colour4,fg=colour0,bold] Menu #[fg=default,bg=default]"

  set_status
}
    
b61541208db7fa7dba42c85224405911_view() {
  unbind_keys

  create_key 1 "Git" '0bcc70105ad279503e31fe7b3f47b665_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour2,fg=colour0,bold] Git #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "Python" 'a7f5f35426b927411fc9231b56382173_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour13,fg=colour0,bold] Python #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "NPM" '00a5cdc4be82fd4ba549d52988ef9e14_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour1,fg=colour0,bold] NPM #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "ZPM" '3517978753cf2043f2a652b3c9d7b524_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour10,fg=colour0,bold] ZPM #[fg=default,bg=default]"
  left_status+=' '
  create_key 5 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 5 #[bg=colour2,fg=colour0,bold] Main #[fg=default,bg=default]"

  set_status
}
    
0bcc70105ad279503e31fe7b3f47b665_view() {
  unbind_keys

  create_key 1 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour2,fg=colour0,bold] Menu #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "Git Status" 'git status' '-s'
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour11,fg=colour0,bold] Git Status #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "Git Branch" 'git branch' '-s'
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour10,fg=colour0,bold] Git Branch #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour3,fg=colour0,bold] Menu #[fg=default,bg=default]"
  left_status+=' '
  create_key 5 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 5 #[bg=colour2,fg=colour0,bold] Main #[fg=default,bg=default]"

  set_status
}
    
a7f5f35426b927411fc9231b56382173_view() {
  unbind_keys

  create_key 1 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour11,fg=colour0,bold] Menu #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "Python list" 'npm ls' '-s'
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour4,fg=colour0,bold] Python list #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "Python Install" 'npm i ' '-t'
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour6,fg=colour0,bold] Python Install #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "Python" 'a7f5f35426b927411fc9231b56382173_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour11,fg=colour0,bold] Python #[fg=default,bg=default]"
  left_status+=' '
  create_key 5 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 5 #[bg=colour2,fg=colour0,bold] Main #[fg=default,bg=default]"

  set_status
}
    
00a5cdc4be82fd4ba549d52988ef9e14_view() {
  unbind_keys

  create_key 1 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour5,fg=colour0,bold] Menu #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "NPM list" 'npm ls' '-s'
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour14,fg=colour0,bold] NPM list #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "NPM Install" 'npm i ' '-t'
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour1,fg=colour0,bold] NPM Install #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour11,fg=colour0,bold] Main #[fg=default,bg=default]"
  left_status+=' '
  create_key 5 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 5 #[bg=colour2,fg=colour0,bold] Main #[fg=default,bg=default]"

  set_status
}
    
3517978753cf2043f2a652b3c9d7b524_view() {
  unbind_keys

  create_key 1 "Menu" 'b61541208db7fa7dba42c85224405911_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour12,fg=colour0,bold] Menu #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "Upgrade Plugins" 'zpm upgrade' '-s'
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour11,fg=colour0,bold] Upgrade Plugins #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "Clean Cache" 'zpm clean' '-s'
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour4,fg=colour0,bold] Clean Cache #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "Readme" 'zpm readme' '-t'
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour1,fg=colour0,bold] Readme #[fg=default,bg=default]"
  left_status+=' '
  create_key 5 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' '-v'
  left_status+="#[bg=colour8,fg=colour15,bold] 5 #[bg=colour2,fg=colour0,bold] Main #[fg=default,bg=default]"

  set_status
}
    

case $1 in
		a02c83a7dbd96295beaefb72c2bee2de_view) a02c83a7dbd96295beaefb72c2bee2de_view ;;
		b61541208db7fa7dba42c85224405911_view) b61541208db7fa7dba42c85224405911_view ;;
		0bcc70105ad279503e31fe7b3f47b665_view) 0bcc70105ad279503e31fe7b3f47b665_view ;;
		a7f5f35426b927411fc9231b56382173_view) a7f5f35426b927411fc9231b56382173_view ;;
		00a5cdc4be82fd4ba549d52988ef9e14_view) 00a5cdc4be82fd4ba549d52988ef9e14_view ;;
		3517978753cf2043f2a652b3c9d7b524_view) 3517978753cf2043f2a652b3c9d7b524_view ;;
    *) a02c83a7dbd96295beaefb72c2bee2de_view
esac

  