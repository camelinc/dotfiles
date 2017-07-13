tap "homebrew/bundle"

tap "homebrew/core"
# Install GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew "coreutils"
brew "binutils"
# Install some other useful utilities like `sponge`
brew "moreutils"
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew "findutils"
# Install GNU `sed`, overwriting the built-in `sed`
brew "gnu-sed", args: ["--default-names"]
#
brew "diffutils"
brew "ed", args: ["with-default-names"]
brew "python"
brew "file-formula"
brew "findutils", args: ["with-default-names"]
brew "fontconfig"
brew "gawk"
brew "git"
brew "gnu-indent", args: ["with-default-names"]
brew "gnu-sed", args: ["with-default-names"]
brew "gnu-tar", args: ["with-default-names"]
brew "gnu-which", args: ["with-default-names"]
brew "gnutls"
brew "grep", args: ["with-default-names"]
brew "gzip"
brew "nmap"
brew "openssh"
brew "rsync"
brew "screen"
brew "tmux"
brew "unzip"
brew "p7zip"
brew "vim", args: ["with-override-system-vi"]
brew "watch"
brew "wdiff", args: ["with-gettext"]
brew "wget"
brew "zsh"
brew 'zsh-completions'

# Powerline Fonts
tap "caskroom/fonts"
cask "font-hack-nerd-font"

# Cask
tap "caskroom/cask"
cask "osxfuse"
cask "macvim"
cask "dropbox"
cask "firefox"
cask "google-chrome"
cask "google-chrome-canary"
cask "gpgtools"
#cask  "imagealpha"
#cask  "imageoptim"
cask "iterm2"
cask "keepassxc"
cask "macvim"
cask "miro-video-converter"
#cask  "opera"
#cask  "opera-developer"
#cask  "opera-next"
#cask  "sublime-text"
#cask  "the-unarchiver"
#cask  "torbrowser"
#cask  "transmission"
cask  "tunnelblick"
#cask  "ukelele"
cask  "virtualbox"
cask 'virtualbox-extension-pack'
cask  "vlc"


# App Store integration
brew 'mas'

# Install Mac App Store apps
# mas '1Password', id: 443987910
mas zoiper

# Needs cask osxfuse
brew "sshfs"
