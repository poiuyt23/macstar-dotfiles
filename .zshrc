# ----- start of dotfiles helper -----
alias config='/usr/bin/git --git-dir=$HOME/.macstar-dotfiles/ --work-tree=$HOME'
# Make sure Git ignores the .dotfiles folder itself
config config --local status.showUntrackedFiles no
# ----- end of dotfiles helper -----
