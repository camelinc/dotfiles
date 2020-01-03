#
# ~/.zsh
#

alias vpnon='systemctl start openvpn-client@air.service'
alias vpnoff='systemctl stop openvpn-client@air.service'
alias steam="LD_PRELOAD='/usr/lib/libstdc++.so.6 /usr/lib/libgcc_s.so.1 /usr/lib/libxcb.so.1 /usr/lib/libgpg-error.so' /usr/bin/steam"

# Golang Path
export GOPATH=${HOME}/go
export PATH=$PATH:$GOPATH/bin

# Rust Path
export PATH=$PATH:${HOME}/.cargo/bin

# Load Antigen
source ~/.antigen.git/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Load the theme
#antigen theme ys

#POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k
#antigen theme bhilburn/powerlevel9k powerlevel9k
antigen theme romkatv/powerlevel10k

# Antigen Bundles
antigen bundle git
antigen bundle tmuxinator
# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
# Fish-like auto suggestions
antigen bundle zsh-users/zsh-autosuggestions
# Extra zsh completions
antigen bundle zsh-users/zsh-completions
#antigen bundle rupa/z
antigen bundle tmux
antigen bundle sudo

antigen bundle kennethreitz/autoenv

# For SSH, starting ssh-agent is annoying
antigen bundle ssh-agent

#virtualbox

# Python Plugins
antigen bundle pip
antigen bundle python
antigen bundle virtualenv

# OS specific plugins
if [[ $CURRENT_OS == 'OS X' || $(uname -s) == 'Darwin' ]]; then
#    antigen bundle brew
#    antigen bundle brew-cask
    antigen bundle gem
    antigen bundle osx

    export PATH="$HOME/Library/Python/2.7/bin:$PATH"
elif [[ $CURRENT_OS == 'Linux' ]]; then
    # None so far...

    if [[ $DISTRO == 'Debian' ]]; then
        antigen bundle debian
    elif [[ $DISTRO == 'Arch' ]]; then
        export TESTVAR="We are on ArchLinux"
    fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
    antigen bundle cygwin
fi

#antigen bundle jdavis/zsh-files

#
# Plugin Settings
#

# Turn on agent forwarding
#zstyle :omz:plugins:ssh-agent agent-forwarding yes

# Use the following identities
#zstyle :omz:plugins:ssh-agent identities github 

antigen apply

# COMPLETION SETTINGS
# # add custom completion scripts
fpath=(~/.zsh/completion $fpath)
# compsys initialization

export PATH="/usr/local/sbin:$PATH"

neofetch
echo -en "\n"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

if [ -e ~/.zprofile ];then
  source ~/.zprofile
fi
