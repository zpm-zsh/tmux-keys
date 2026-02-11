if [[ -z "${TMUX}" ]]; then
  return 0
fi

# Standarized $0 handling, following:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
_DIRNAME="${0:h}"

STAT_CACHE_FILE="${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh"
CONFIG_CANDIDATES=(
  "${XDG_CONFIG_HOME:-${HOME}/.config}/tmux/keys.yaml"
  "${HOME}/.tmux/keys.yaml"
  "${HOME}/.tmux-keys.yaml"
)
TMUX_KEYS_CONFIG=""

for candidate in "${CONFIG_CANDIDATES[@]}"; do
  if [[ -e "${candidate}" ]]; then
    TMUX_KEYS_CONFIG="${candidate}"
    break
  fi
done

if [[ -z "${TMUX_KEYS_CONFIG}" ]]; then
  TMUX_KEYS_CONFIG="${CONFIG_CANDIDATES[1]}"
  mkdir -p "${TMUX_KEYS_CONFIG:h}"
  cp "${_DIRNAME}/tmux-keys.example.yaml" "${TMUX_KEYS_CONFIG}"
fi

if [[ -f "$STAT_CACHE_FILE" && "$STAT_CACHE_FILE" -nt "${TMUX_KEYS_CONFIG}" && "$STAT_CACHE_FILE" -nt "${_DIRNAME}/generate.py" ]]; then
  source "$STAT_CACHE_FILE"
else
  mkdir -p "${TMPDIR:-/tmp}/zsh-${UID}"
  TMUX_KEYS_CONFIG="${TMUX_KEYS_CONFIG}" python3 "${_DIRNAME}/generate.py" || cp "${_DIRNAME}/tmux-keys.example.zsh" "${STAT_CACHE_FILE}"
  source "${STAT_CACHE_FILE}"
fi
