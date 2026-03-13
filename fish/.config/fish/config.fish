if status is-interactive
    set -U fish_greeting ""
    set -U __done_min_cmd_duration 10000
    set -U __done_notification_urgency_level low
end

# Path
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin

# Environment
set -x GOPATH $HOME/go
set -x GOBIN $GOPATH/bin
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# fzf
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git --exclude Library --exclude Applications --exclude .Trash --exclude .cache --exclude node_modules'
set -gx FZF_CTRL_T_COMMAND 'fd --type f --hidden --follow --exclude .git --exclude Library --exclude Applications --exclude .Trash --exclude .cache --exclude node_modules'
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git --exclude Library --exclude Applications --exclude .Trash --exclude .cache --exclude node_modules'

# Aliases - ls (eza)
alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.="eza -a | grep -e '^\.'"

# Aliases - navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Aliases - misc
alias k='kubectl'
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias grep='grep --color=auto'

# Tool init
fzf --fish | source
zoxide init fish | source

# Load secrets if they exist
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end
