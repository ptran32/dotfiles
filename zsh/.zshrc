# Environment
export VISUAL=nvim
export EDITOR="$VISUAL"
export PATH="$HOME/.local/bin:$PATH"

# Completion
setopt autocd auto_menu complete_in_word always_to_end
if command -v brew >/dev/null 2>&1; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

autoload -Uz compinit
compinit
zmodload -i zsh/complist
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true

# Tool initialization
for completion in \
  'kubectl completion zsh' \
  'docker completion zsh' \
  'helm completion zsh'; do
  command_name="${completion%% *}"
  command -v "$command_name" >/dev/null 2>&1 && source <(eval "$completion")
done
command -v gh >/dev/null 2>&1 && eval "$(gh completion -s zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v tfenv >/dev/null 2>&1 && eval "$(tfenv init -)"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init - zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Everyday aliases
alias v='nvim'
alias ng='nvim -c "lua require(\"neogit\").open()"'
alias c='bat --paging=never'
alias y='yazi'
alias l='eza --icons --modified --sort=modified'
alias tree='eza -T --icons'
alias k='kubectl'
alias kx='kubectx'
alias ks='kubens'
alias kpo='kubectl get pod'
alias d='docker'
alias co='codex'
alias cc='claude'
alias oc='opencode'
alias hd='hunk diff'
alias src='exec zsh'

# Git aliases are kept separately so Git workflow stays easy to discover.
[[ -r "$HOME/.config/zsh/git-aliases.zsh" ]] && source "$HOME/.config/zsh/git-aliases.zsh"

# Directory shortcuts
alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'

# Helpers
extract() {
  [ -f "$1" ] || { echo "$1 is not a valid file"; return 1; }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;; *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.xz|*.txz) tar xJf "$1" ;; *.tar) tar xf "$1" ;;
    *.bz2) bunzip2 "$1" ;; *.gz) gunzip "$1" ;; *.zip) unzip "$1" ;;
    *.rar) unrar x "$1" ;; *.7z) 7z x "$1" ;;
    *) echo "$1 cannot be extracted via extract()"; return 1 ;;
  esac
}

take() { mkdir -p "$1" && cd "$1"; }
..() { cd ..; }
copyfile() { [ "$#" -eq 1 ] || { echo 'usage: copyfile <file>' >&2; return 1; }; pbcopy < "$1"; }
copypath() { pwd | pbcopy; }

appearance() {
  case "${1:-toggle}" in
    dark|on) osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true' ;;
    light|off) osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false' ;;
    toggle) osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode' ;;
    status) osascript -e 'tell app "System Events" to tell appearance preferences to get dark mode' | grep -q true && echo dark || echo light ;;
    *) echo 'usage: appearance [dark|light|toggle|status]' >&2; return 1 ;;
  esac
}
