# ----- start of dotfiles helper -----
alias config='/usr/bin/git --git-dir=$HOME/.macstar-dotfiles/ --work-tree=$HOME'
# Make sure Git ignores the .dotfiles folder itself
config config --local status.showUntrackedFiles no
# ----- end of dotfiles helper -----
alias vim="nvim"
alias update='cd /etc/nix-darwin/; sudo nix flake update; sudo darwin-rebuild switch; cd ~'

# 1️⃣  Guard: make sure we’re in an interactive shell.
if [[ $- == *i* && -t 1 ]]; then

        command fastfetch -c .config/fastfetch/myconfig.jsonc
fi
