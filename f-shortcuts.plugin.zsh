source ${0:A:h}/functions.zsh

if [[ ! -e ~/.zsh-f-shortcuts.yaml ]]; then
  cp ${0:A:h}/zsh-f-shortcuts.example.yaml ~/.zsh-f-shortcuts.yaml
fi

if [[! -e /tmp/zpm-zsh-f-shorcuts.$USER.zsh ]]; then
  ruby ${0:A:h}/generate.rb
fi

if [[ ~/.zsh-f-shortcuts.yaml -nt /tmp/zpm-zsh-f-shorcuts.$USER.zsh ]]; then
  ruby ${0:A:h}/generate.rb
fi


cache_file="/tmp/zpm-zsh-f-shorcuts.$USER.zsh"

source "$cache_file"