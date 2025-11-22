# ----- start of dotfiles helper -----
alias config='/usr/bin/git --git-dir=$HOME/.macstar-dotfiles/ --work-tree=$HOME'
# Make sure Git ignores the .dotfiles folder itself
config config --local status.showUntrackedFiles no
# ----- end of dotfiles helper -----
alias vim="nvim"
alias update='cd /etc/nix-darwin/; sudo nix flake update; sudo darwin-rebuild switch; cd ~'
alias nvimk='NVIM_APPNAME="nvim-kickstart" nvim'
alias ssh="kitten ssh"
eval "$(pay-respects zsh --alias)" # alias f to "pay-respects"

setopt correct         # typo correction for commands
setopt histignoredups  # don’t store duplicate entries in history
setopt share_history   # keep history synced across multiple terminals

export EDITOR=nvim # default editor
export VISUAL=$EDITOR

autoload -U compinit && compinit   # enable completion system
zstyle ':completion:*' menu select # navigate completions with arrow keys

#   Guard: make sure we’re in an interactive shell.
if [[ $- == *i* && -t 1 ]]; then

        command fastfetch -c ~/.config/fastfetch/myconfig.jsonc
fi

