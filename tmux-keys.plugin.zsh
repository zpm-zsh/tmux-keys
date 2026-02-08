if [[ -z "${TMUX}" ]]; then
  return 0
fi

# Standarized $0 handling, following:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
_DIRNAME="${0:h}"

STAT_CACHE_FILE="${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh"

if [[ "$STAT_CACHE_FILE" -nt "${HOME}/.tmux-keys.yaml" ]]; then
  source "$STAT_CACHE_FILE"
else
  mkdir -p "${TMPDIR:-/tmp}/zsh-${UID}"

  if [ ! -e "${HOME}/.tmux-keys.yaml" ]; then
    cp "${_DIRNAME}/tmux-keys.example.yaml" "${HOME}/.tmux-keys.yaml"
  fi

  python3 "${_DIRNAME}/generate.py" || cp "${_DIRNAME}/tmux-keys.example.zsh" "${STAT_CACHE_FILE}"
  source "${STAT_CACHE_FILE}"
fi
