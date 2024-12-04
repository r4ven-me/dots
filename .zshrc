####################
### SHELL CONFIG ###
####################

# Add custom directories to the PATH variable
export PATH=$HOME/.bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.config/oh-my-zsh"       # Path to Oh My Zsh installation
export ZSH_CUSTOM="$ZSH/custom"            # Path to Oh My Zsh custom dir
export TERM=xterm-256color                 # Set terminal type for better color support
# export TERM="screen-256color"            # Alternative terminal type (commented out)

# Configure FZF colors for better aesthetics
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

# Theme selection
# Find more themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
if [[ -n "$DISPLAY" || $(tty) == /dev/pts* || -n "$SSH_CONNECTION" ]]; then
    ZSH_THEME="agnoster"                    # Fallback to default "agnoster" theme
else
    ZSH_THEME="dpoggi"                      # Use the 'noicon' theme in other cases, e.g. in console (tty)
fi

# Powerlevel10k theme (requires installation)
# https://github.com/romkatv/powerlevel10k
# ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_AUTO_UPDATE="true"                  # Disable automatic updates for Oh My Zsh
COMPLETION_WAITING_DOTS="true"              # Show dots while completing commands

# Command History Configuration
HIST_STAMPS="yyyy-mm-dd"                    # Add timestamp to command history
HISTFILE=~/.zsh_history                     # File to save history
HISTSIZE=10000                              # Max number of history entries in memory
SAVEHIST=10000                              # Max number of history entries to save to file
setopt hist_ignore_all_dups                 # Ignore duplicate entries in history
setopt share_history                        # Share history between sessions
setopt histignorespace                      # Ignore commands starting with a space

# Enable vi-mode for the command line (default is emacs mode)
# set -o vi

plugins=(
    fzf                        # Fuzzy finder integration (Ctrl+r)
    git                        # Git aliases and functions
    sudo                       # Run/repeat last command with sudo (duble Esc)
    docker                     # Docker command-line helper
    kubectl                    # Kubernetes command-line helper
    cmdtime                    # Measure time spent on commands
    zsh-autopair               # Auto-close parentheses and quotes
    zsh-completions            # Additional completion scripts (Tab)
    zsh-autosuggestions        # Suggest commands based on history
    fast-syntax-highlighting   # Syntax highlighting for commands
    history-substring-search   # Search history with substring matches
)

# Example to install custom plugins manually:
# git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# Autoinstall selected plugins
if [[ -x $(which git) && -d "${ZSH_CUSTOM}" ]]; then
    if [[ ! -d "${ZSH_CUSTOM}"/plugins/cmdtime ]]; then
        git clone https://github.com/tom-auger/cmdtime \
            "${ZSH_CUSTOM}"/plugins/cmdtime
    fi
    
    if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-autopair ]]; then
        git clone https://github.com/hlissner/zsh-autopair \
            "${ZSH_CUSTOM}"/plugins/zsh-autopair
    fi
    
    if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-completions ]]; then
        git clone https://github.com/zsh-users/zsh-completions \
            "${ZSH_CUSTOM}"/plugins/zsh-completions
    fi
    
    if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions
    fi
    
    if [[ ! -d "${ZSH_CUSTOM}"/plugins/fast-syntax-highlighting ]]; then
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting \
            "${ZSH_CUSTOM}"/plugins/fast-syntax-highlighting
    fi
fi

source "${ZSH}"/oh-my-zsh.sh                    # Init Oh My Zsh framework

autoload -Uz compinit
compinit                                    # Initialize and enable completion system

export CLICOLOR=1                           # Enable colored output for `ls`
export LSCOLORS=GxFxCxDxBxegedabagaced      # Color scheme for `ls`
export VIRTUAL_ENV_DISABLE_PROMPT=1         # Disable default virtualenv prompt

if [[ -r "${HOME}"/.profile ]]; then
    . "${HOME}"/.profile                        # Source '.profile' if it exists
fi

###############
### ALIASES ###
###############

# Python
alias python="python3"

# Network
alias p8="ping -c3 8.8.8.8"
alias ip="ip -c"

# Editor
if [[ -e $(which nvim) ]]; then
    alias vim="nvim"
    alias n="nvim"
    alias N="sudo nvim"
fi

# exa instead ls
if [[ -e $(which exa) ]]; then
    alias ls="exa --icons"
    alias ll="exa -la --icons"
    alias l="exa -lah --icons"
    alias lm="exa -la --sort=modified --icons"
    alias lmm="exa -lbhHigUmuSa --sort=modified --time-style=long-iso --icons"
    alias lt="exa --tree --icons"
    alias lr="exa --recurse --icons"
    alias lg="exa -lh --git --sort=modified --icons"
fi

# bat* utils
if [[ -e $(which batman) ]]; then alias man="batman"; fi

if [[ -e $(which batwatch) ]]; then
    alias watch="batwatch --interval=1 --command --color"
fi

if [[ -e $(which bat) ]]; then
    alias cat="bat -p -P"
    alias less="bat --paging=always"
elif [[ -e $(which batcat) ]]; then
    alias cat="batcat -p -P"
    alias less="batcat --paging=always"
fi

# APT
if [[ -e $(which apt) ]]; then
    alias U="sudo apt update"
    alias UP="sudo apt upgrade"
    alias R="sudo apt autoremove"
    alias I="sudo apt install"
    alias UI="sudo apt update && sudo apt install"
fi

# Ansible
if [[ -e $(which ansible) ]]; then
    ap() {
        ansible-playbook ~/ansible/playbooks/"$@"
    }
    alias ac="ansible-console"
fi

# Tmux
if [[ -e $(which tmux) ]]; then
    alias T="sudo tmux attach -t $(hostname | cut -d. -f1) || sudo tmux new -s $(hostname | cut -d. -f1)"
fi

##############
### PROMPT ###
##############

# Remove user@host context from the prompt when DISPLAY is set
if [[ -n "$DISPLAY" ]]; then
    prompt_context() { }                    # Empty function to disable context
fi
