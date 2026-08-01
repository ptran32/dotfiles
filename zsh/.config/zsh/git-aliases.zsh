# Git aliases inspired by Oh My Zsh's Git plugin. Starship is prompt-only;
# these aliases work in plain Zsh without enabling the Oh My Zsh framework.

alias g='git'
alias s='git status'
alias gst='git status'
alias gss='git status --short'
alias gsb='git status --short --branch'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'

alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbr='git branch --remotes'
alias gbl='git blame -w'

alias gco='git checkout'
alias gcb='git checkout -b'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gc='git commit'
alias gcm='git commit --message'
alias gcam='git commit --all --message'
alias gcas='git commit --all --signoff'
alias gcasm='git commit --all --signoff --message'

alias gd='git diff'
alias gdc='git diff --cached'
alias gdw='git diff --word-diff'
alias gds='git diff --staged'

alias gf='git fetch'
alias gfa='git fetch --all --tags --prune'
alias gfo='git fetch origin'

alias gl='git pull'
alias gpr='git pull --rebase'
alias gp='git push'
alias gpd='git push --dry-run'
alias gpv='git push --verbose'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbs='git rebase --skip'
alias grf='git reflog'

alias gr='git remote'
alias gra='git remote add'
alias grrm='git remote remove'
alias grv='git remote --verbose'

alias grs='git restore'
alias grst='git restore --staged'
alias grev='git revert'
alias greva='git revert --abort'
alias grevc='git revert --continue'

alias gsh='git show'
alias gstaa='git stash apply'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsta='git stash push'
alias gsts='git stash show --patch'

alias gsw='git switch'
alias gswc='git switch --create'
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'

alias glog='git log --oneline --decorate --graph --all'
alias glg='git log --stat'
alias glgp='git log --stat --patch'
alias gcount='git shortlog --summary --numbered'
