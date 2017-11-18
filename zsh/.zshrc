# Load Antigen
source ~/.antigen.git/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

# Load the theme
antigen theme agnoster

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
antigen bundle zsh-users/zsh-completions

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
    fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
    antigen bundle cygwin
fi

#antigen bundle jdavis/zsh-files

#
# Plugin Settings
#

# Turn on agent forwarding
zstyle :omz:plugins:ssh-agent agent-forwarding yes

# Use the three identities
zstyle :omz:plugins:ssh-agent identities github pyrite arrakis

antigen apply

# COMPLETION SETTINGS
# # add custom completion scripts
fpath=(~/.zsh/completion $fpath)
# compsys initialization

export PATH="/usr/local/sbin:$PATH"

if [ -e ~/.zprofile ];then
  source ~/.zprofile
fi
