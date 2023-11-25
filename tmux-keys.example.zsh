
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
  display_message=''
  if [ "$6" = 'true' ]; then
    display_message="display -d 200 '#[fill=colour0 bg=colour${5} align=centre] ${2} '"
  fi

  tmux_command=''

  if [ "$4" = "exec" ]; then
    tmux_command="send-keys $keys[$1] '$3
'"
  elif [ "$4" = "insert" ]; then
    tmux_command="send-keys $keys[$1] '$3'"
  elif [ "$4" = "view" ]; then
    tmux_command="run-shell 'zsh ${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh $3'"
  elif [ "$4" = "tmux" ]; then
    tmux_command="$3"
  fi

  if [ "$display_message" = "" ]; then
    tmux bind-key -n F${1} "$tmux_command"
  else
    tmux bind-key -n F${1} "$display_message ; $tmux_command"
  fi
}

function set_status() {
  tmux set -g status-right "$left_status"
}

  
a02c83a7dbd96295beaefb72c2bee2de_view() {
  unbind_keys

  create_key 1 "←" 'previous-window' 'tmux' 2 false
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour2,fg=colour0,bold] ← #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "→" 'next-window' 'tmux' 2 false
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour2,fg=colour0,bold] → #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "System" 'a45da96d0bf6575970f2d27af22be28a_view' 'view' 13 false
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour13,fg=colour0,bold] System #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "Git" '0bcc70105ad279503e31fe7b3f47b665_view' 'view' 10 false
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour10,fg=colour0,bold] Git #[fg=default,bg=default]"
  left_status+=' '
  create_key 5 "Python" 'a7f5f35426b927411fc9231b56382173_view' 'view' 9 false
  left_status+="#[bg=colour8,fg=colour15,bold] 5 #[bg=colour9,fg=colour0,bold] Python #[fg=default,bg=default]"
  left_status+=' '
  create_key 6 "ZPM" '3517978753cf2043f2a652b3c9d7b524_view' 'view' 3 false
  left_status+="#[bg=colour8,fg=colour15,bold] 6 #[bg=colour3,fg=colour0,bold] ZPM #[fg=default,bg=default]"

  set_status
}
    
0bcc70105ad279503e31fe7b3f47b665_view() {
  unbind_keys

  create_key 1 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' 'view' 12 false
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour12,fg=colour0,bold] Main #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "Git Status" 'git status' 'exec' 6 true
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour6,fg=colour0,bold] Git Status #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "Git Branch" 'git branch' 'exec' 10 true
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour10,fg=colour0,bold] Git Branch #[fg=default,bg=default]"

  set_status
}
    
a7f5f35426b927411fc9231b56382173_view() {
  unbind_keys

  create_key 1 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' 'view' 11 false
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour11,fg=colour0,bold] Main #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "pip install " 'pip install ' 'insert' 1 true
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour1,fg=colour0,bold] pip install  #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "Python" '23eeeb4347bdd26bfc6b7ee9a3b755dd_view' 'view' 12 false
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour12,fg=colour0,bold] Python #[fg=default,bg=default]"

  set_status
}
    
00a5cdc4be82fd4ba549d52988ef9e14_view() {
  unbind_keys

  create_key 1 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' 'view' 13 false
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour13,fg=colour0,bold] Main #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "NPM list" 'npm ls' 'exec' 3 true
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour3,fg=colour0,bold] NPM list #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "NPM Install" 'npm i ' 'insert' 14 true
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour14,fg=colour0,bold] NPM Install #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' 'view' 9 false
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour9,fg=colour0,bold] Main #[fg=default,bg=default]"

  set_status
}
    
3517978753cf2043f2a652b3c9d7b524_view() {
  unbind_keys

  create_key 2 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' 'view' 12 false
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour12,fg=colour0,bold] Main #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "Upgrade Plugins" 'zpm upgrade' 'exec' 6 true
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour6,fg=colour0,bold] Upgrade Plugins #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "Clean Cache" 'zpm clean' 'exec' 10 true
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour10,fg=colour0,bold] Clean Cache #[fg=default,bg=default]"
  left_status+=' '
  create_key 5 "Readme" 'zpm readme' 'insert' 11 true
  left_status+="#[bg=colour8,fg=colour15,bold] 5 #[bg=colour11,fg=colour0,bold] Readme #[fg=default,bg=default]"

  set_status
}
    
a45da96d0bf6575970f2d27af22be28a_view() {
  unbind_keys

  create_key 1 "Main" 'a02c83a7dbd96295beaefb72c2bee2de_view' 'view' 6 false
  left_status+="#[bg=colour8,fg=colour15,bold] 1 #[bg=colour6,fg=colour0,bold] Main #[fg=default,bg=default]"
  left_status+=' '
  create_key 2 "$(_tmux_uname)" 'neofetch' 'exec' 3 true
  left_status+="#[bg=colour8,fg=colour15,bold] 2 #[bg=colour3,fg=colour0,bold] $(_tmux_uname) #[fg=default,bg=default]"
  left_status+=' '
  create_key 3 "$(_tmux_myip)" 'ip addr' 'insert' 1 true
  left_status+="#[bg=colour8,fg=colour15,bold] 3 #[bg=colour1,fg=colour0,bold] $(_tmux_myip) #[fg=default,bg=default]"
  left_status+=' '
  create_key 4 "Menu" 'b61541208db7fa7dba42c85224405911_view' 'view' 4 false
  left_status+="#[bg=colour8,fg=colour15,bold] 4 #[bg=colour4,fg=colour0,bold] Menu #[fg=default,bg=default]"

  set_status
}
    

case $1 in
		a02c83a7dbd96295beaefb72c2bee2de_view) a02c83a7dbd96295beaefb72c2bee2de_view ;;
		0bcc70105ad279503e31fe7b3f47b665_view) 0bcc70105ad279503e31fe7b3f47b665_view ;;
		a7f5f35426b927411fc9231b56382173_view) a7f5f35426b927411fc9231b56382173_view ;;
		00a5cdc4be82fd4ba549d52988ef9e14_view) 00a5cdc4be82fd4ba549d52988ef9e14_view ;;
		3517978753cf2043f2a652b3c9d7b524_view) 3517978753cf2043f2a652b3c9d7b524_view ;;
		a45da96d0bf6575970f2d27af22be28a_view) a45da96d0bf6575970f2d27af22be28a_view ;;
    *) a02c83a7dbd96295beaefb72c2bee2de_view
esac

  