#============================================
# Desc: .zshrc config for oh-my-zsh 
# Author: Ivan Cherniy
# Main site: https://r4ven.me
# Config note: https://r4ven.me/zshrc-config
#============================================

#######################
### COMMON SETTINGS ###
#######################

# Add custom directories to the PATH variable
if [[ -d "$HOME/bin" ]]; then PATH="$HOME/bin:$PATH"; fi
if [[ -d "$HOME/.bin" ]]; then PATH="$HOME/.bin:$PATH"; fi
if [[ -d "$HOME/.local/bin" ]]; then PATH="$HOME/.local/bin:$PATH"; fi
export PATH

export ZSH="$HOME/.config/oh-my-zsh"       # Path to Oh My Zsh installation
export ZSH_CUSTOM="$ZSH/custom"            # Path to Oh My Zsh custom dir
export TERM="xterm-256color"               # Set terminal type for better color support
# export TERM="screen-256color"            # Alternative terminal type (commented out)

# Oh-my-zsh theme selection
# Find more themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
if [[ -n "$DISPLAY" || $(tty) == /dev/pts* ]]; then
    ZSH_THEME="agnoster"                   # Use this theme in GUI mode
    export VIRTUAL_ENV_DISABLE_PROMPT=1    # Disable default virtualenv prompt
else
    ZSH_THEME="dpoggi"                     # Use the 'noicon' theme in other cases, e.g. in console (tty)
fi

# Powerlevel10k theme (requires installation)
# https://github.com/romkatv/powerlevel10k
# ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_AUTO_UPDATE="true"                  # Disable automatic updates for Oh My Zsh (cmd: omz update)
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

###############
### PLUGINS ###
###############

plugins=(
    fzf                        # Fuzzy finder integration (Ctrl+r)
    git                        # Git aliases and functions
    sudo                       # Run/repeat last command with sudo (duble Esc)
    docker                     # Docker command-line helper
    kubectl                    # Kubernetes command-line helper
    cmdtime                    # Measure time spent on commands
    zsh-completions            # Additional completion scripts (Tab)
    zsh-autosuggestions        # Suggest commands based on history
    fast-syntax-highlighting   # Syntax highlighting for commands
    history-substring-search   # Search history with substring matches (up/down arrows)
)

# Plugin to auto-close parentheses and quotes
# Fix: disable this plugin in MidnightCommander
if ! [[ $(ps -o comm -h $PPID) =~ "^mc" ]]; then
    plugins+=(zsh-autopair)
fi

# Example to install custom plugins manually:
# git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# Autoinstall oh-my-zsh framework
if [[  ! -d "$ZSH" && -x $(which git) ]]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
fi

# Autoinstall selected plugins
if [[ -d "$ZSH_CUSTOM" && -x $(which git)  ]]; then
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
        
        reset
    fi
fi

######################
### INIT OH-MY-ZSH ###
######################

source "${ZSH}"/oh-my-zsh.sh                # Init Oh My Zsh framework

autoload -Uz compinit && compinit           # Initialize and enable completion system

if [[ -r "${HOME}"/.profile ]]; then
    source "${HOME}"/.profile               # Source '.profile' if it exists
fi

######################
### APPS AND UTILS ###
######################

# Python
alias python="python3"

# Network
alias p8="ping -c3 8.8.8.8"
alias ip="ip --color"

# Configure code editor
if [[ -x $(which nvim) ]]; then
    export EDITOR="$(which nvim)"
    export VISUAL="$(which nvim)"
    alias vim="nvim"
    alias n="nvim"
    alias N="sudo nvim"
elif [[ -x $(which vim) ]]; then
    export EDITOR="$(which vim)"
    export VISUAL="$(which vim)"
    alias v="vim"
    alias V="sudo vim"
fi

# Configure FZF with Nord theme colors
if [[ -x $(which fzf) ]]; then
    export FZF_DEFAULT_OPTS="--exact"
    export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
        --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
        --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
        --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
        --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'
fi

# Defining a variable with the name of the utility: bat or batcat
if [[ -e $(which batcat) ]]; then
    export bat="batcat"
    alias bat="batcat"
elif [[ -e $(which bat) ]]; then
    export bat="bat"
fi

# Usage bat instead of cat, less, man, --help, tail -f
# See more: https://r4ven.me/bat-exa-config
if [[ -n $bat ]]; then
    export COLORTERM="truecolor"
    export BAT_THEME="Nord"
    export MANPAGER="sh -c 'col -bx | $bat --language=man --style=plain'"  # Command to view man pages
    export MANROFFOPT="-c"  # Disabling line wrapping in man
    alias cat="$bat --style=plain --paging=never"
    alias less="$bat --paging=always"
    if [[ $SHELL == *zsh ]]; then # global alias "--help" if zsh
        alias -g -- --help='--help 2>&1 | $bat --language=help --style=plain'
    fi
    help() { "$@" --help 2>&1 | $bat --language=help --style=plain; }
    tailf() { tail -f "$@" | $bat --paging=never --language=log; }
    batdiff() { git diff --name-only --relative --diff-filter=d | xargs $bat --diff; }
fi

# Usage exa instead of ls
# See more: https://r4ven.me/bat-exa-config
if [[ -x $(which exa) ]]; then
    if [[ -n "$DISPLAY" || $(tty) == /dev/pts* ]]; then # display icons if pseudo terminal
        alias ls="exa --group --header --icons"
    else
        alias ls="exa --group --header"
    fi
    alias ll="ls --long"
    alias l="ls --long --all"
    alias lm="ls --long --all --sort=modified"
    alias lmm="ls -lbHigUmuSa --sort=modified --time-style=long-iso"
    alias lt="ls --tree"
    alias lr="ls --recurse"
    alias lg="ls --long --git --sort=modified"
fi

# APT
if [[ -x $(which apt) ]]; then
    alias AU="sudo apt update"
    alias AUP="sudo apt upgrade"
    alias AR="sudo apt autoremove"
    alias AI="sudo apt install"
    alias AUI="sudo apt update && sudo apt install"
fi

# Ansible
if [[ -e $(which ansible) ]]; then
    ap() { ansible-playbook ~/ansible/playbooks/"$@"; }
    alias ac="ansible-console"
fi

# Tmux
if [[ -e $(which tmux) ]]; then
    alias t="tmux attach -t Work || tmux new -s Work"
    alias T="sudo tmux attach -t Work! || sudo tmux new -s Work!"
fi

# Define the 'cmd' function, which exec cistom commands form list
# It takes one argument - the command name and insert it to command line
cmd() {
    local cmd_name="${1}"
    typeset -A cmd_list

    # Associative array to store the list of commands
    # Keys are command names, values are the actual commands
    cmd_list=(
        ps_zombie "ps -eo user,pid,ppid,state,comm | awk '\$4=="Z" {print \$3}'"
        ps_top5_cpu "ps --sort=-%cpu -eo user,pid,ppid,state,comm | head -n6"
        ps_top5_mem "ps --sort=-%mem -eo user,pid,ppid,state,comm | head -n6"
        cron_add '{ crontab -l; echo "0 3 * * 0 ls -l &> dirs.txt"; } | crontab -'
        du_top20 'du -h / 2> /dev/null | sort -rh | head -n 20'
        df_80 "df -h | awk '\$5 ~ /^8[0-9]%/ {print $6}'"
        git_init 'git init --initial-branch=main && git remote add origin ssh://git@github.com/r4ven-me/reponame.git'
        journal_vacuum 'journalctl --vacuum-size=800M'
        lsof_opened 'lsof +D /opt'
        ossl_connect 'openssl s_client -connect r4ven.me:443'
        ossl_info 'openssl x509 -in ./ca-cert.pem -text -noout'
        ossl_encrypt_tar 'tar -czf - /var/log/apt | openssl enc -aes-256-cbc -pbkdf2 -e -out ./logs.tar.gz.enc'
        ossl_decrypt_file 'openssl enc -aes-256-cbc -pbkdf2 -d -in ./logs.tar.gz.enc -out ./logs.tar.gz'
        ss_listen "ss -tuln | awk '{print \$5}' | grep -Eo ':[0-9]+$' | sort -t: -k2 -n -u"
        ipt_recent_icmp1 "iptables -A INPUT -p icmp --icmp-type echo-request -m recent --set --name PING_LIST"
        ipt_recent_icmp2 "iptables -A INPUT -p icmp --icmp-type echo-request -m recent --update --seconds 10 --hitcount 5 --name PING_LIST -j DROP"
        uptime_unix 'date -d "$(uptime -s)" +%s'
        history_top10 "history | awk '{print \$4}' | sort | uniq -c | sort -rn | head"
        urandom_str "cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1"
        sed_replace "sed -i 's/old_text/new_text/g' file.txt"
        find_chmod_d "find /path -type f -exec chmod 644 {} \\;"
        find_chmod_f "find /path -type d -exec chmod 755 {} \\;"
        tcpdump_dhost_dport "tcpdump -i any -nn -q dst host 10.11.12.13 and dst port 443"
        tcpdump_stout "tcpdump -nn -i any host 10.11.12.13 >> ./tcpdump.txt"
        tcpdump_wrtie_pacp "tcpdump -nn -i any host 10.11.12.13 -w ./tcpdump.pacp"
        tcpdump_read_pcap "tcpdump -qns 0 -X -r ./tcpdump.pacp | less"

    )

    # Check if the command exists in the array, or if help is requested
    if [[ -z ${cmd_list[$cmd_name]} || -z "$cmd_name" || "$cmd_name" == "-h" ]]; then
        # Display the list of available commands
        echo "AVAILABLE COMMANDS:\n"
        printf "%-20s %s\n" "Key" "Command"
        echo "----------------------------"
        # Iterate over all keys in the array and display them
        for key in "${(@k)cmd_list}"; do
            printf "%-20s %s\n" "$key" "${cmd_list[$key]}"
            # echo "------------------"
        done | sort
        return 0
    else
        # If the command is found, insert it into the command line
        print -zr "${cmd_list[$cmd_name]}"
        return 0
    fi
}

# Function for command autocompletion
_cmd_completion() {
    local -a keys
    keys=($(cmd -h | awk 'NR>4 {print $1}'))  # Извлекаем ключи из вывода справки
    compadd "$@" -- "${keys[@]}"
}

# Register the autocompletion function for the `cmd` command
compdef _cmd_completion cmd


##############
### PROMPT ###
##############

# Remove user@host context from the prompt when DISPLAY is set
if [[ -n "$DISPLAY" ]]; then
    prompt_context() { }                    # Empty function to disable context
fi
