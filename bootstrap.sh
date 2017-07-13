#!/usr/bin/env bash

# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# https://github.com/vqv/dotfiles/
# http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming

#readonly DOTDIR="${HOME}/Documents/Dotfiles"
readonly DOTDIR="${HOME}/.dotfiles"
readonly PROGNAME=$(basename "$0")
tmp=$(dirname "$0")
if [[ "$(uname -s)" == "Darwin" ]]; then
  readonly PROGDIR=$(realpath "${tmp}")
else
  #Debian
  readonly PROGDIR=$(readlink -m "${tmp}")
fi
readonly ARGS=( "$@" )

info () {
  printf "  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] %s\n" "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
  echo ''
  exit
}
ask () {
    # http://djm.me/ask
    while true; do
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question - use /dev/tty in case stdin is redirected from somewhere else
        read -p "$1 [$prompt] " REPLY </dev/tty

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}
install_powerline() {
  local fontdir="${HOME}/.fonts/"

  #FIXME: pip list missing
    #pip install list
      #https://pip.pypa.io/en/latest/installing.html

  # (IOError: broken pipe)[https://github.com/pypa/pip/issues/3263]
  #if pip list | grep -q 'powerline'
  # shellcheck disable=SC2143
  if [[ -z $(pip list | grep powerline) ]]; then
    info 'installing powerline'
    #pip install --quiet --user git+git://github.com/powerline/powerline
    pip install --user powerline-status

  else
    info 'updating powerline'
    #pip install --quiet --user --upgrade git+git://github.com/powerline/powerline
    pip install --user --upgrade powerline-status

  fi

  if [[ ! -d ${fontdir} ]]; then
    mkdir "${fontdir}"
  fi
  cd "${fontdir}" \
      || fail "Could not change into ${fontdir}"

  src="${HOME}/.fonts/powerline-fonts/"
  if [[ ! -d ${src} ]]; then
    git clone https://github.com/Lokaltog/powerline-fonts.git "${src}" --quiet
  else
    cd "${src}" \
      || fail "Could not change into ${src}"
    git pull --quiet
  fi

  info 'installing powerline-fonts'
  fcchache_bin=$(which fc-cache)
  if [[ ! -x "${fcchache_bin}" ]]; then
    info 'installing fontconfig'

    if [[ "$(uname -s)" == "Darwin" ]]; then
      brew install fontconfig \
        || fail "Could not install fontconfig"
    else
      sudo apt-get install -y fontconfig \
        || fail "Could not install fontconfig"
    fi
  fi

  sudo "${fcchache_bin}" -vf "${fontdir}" >/dev/null
}
install_peda() {
  info 'installing gdb peda'
  local pedadir="${HOME}/peda"

  src="${HOME}/.fonts/powerline-fonts/"
  if [[ ! -d ${pedadir} ]]; then
    git clone https://github.com/longld/peda.git "${pedadir}" --quiet
  else
    cd "${pedadir}" \
      || fail "Could not change into ${pedadir}"
    git pull --quiet
  fi

  echo "source ~/peda/peda.py" >> "${HOME}/.gdbinit"

}
install_dotfiles () {
  info 'installing dotfiles'

  while IFS= read -r -d '' src
  do
    local dst
    dst="${HOME}/.$(basename "${src%.*}")"

    if [[ -f "$dst" || -d "$dst" ]]; then
      if [[ ! -L "$dst" ]] && \
        (ask "Delete $dst?" N);
      then
          continue
      fi

      rm -rf "$dst"
      success "removed $dst"
    fi

    CMD="ln -s \"${src}\" \"${dst}\""
    eval "${CMD}" \
      || fail "Could not link ${src} to ${dst}"
    success "linked ${src} to ${dst}"
  done <  <(find "${DOTDIR}" -maxdepth 2 -name '*.symlink' -print0)
}

install_antigen() {
  info 'installing antigen'

  src="${DOTDIR}/antigen/antigen.zsh"
  if [[ -e ${src} ]]; then
    info "antigen present"

    dst="$HOME/.antigen.zsh"
    if [[ -f "$dst" || -d "$dst" || -L "$dst" ]]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    CMD="ln -s \"${src}\" \"${dst}\""
    eval "${CMD}" \
      || fail "Could not link ${src} to ${dst}"
    success "linked ${src} to ${dst}"
  else
    fail "Antigen repository missing: ${src}"
  fi
}
prepare_tmux() {
  info 'preparing tmux'

  src="https://github.com/tmux-plugins/tpm"
  dst="~/.tmux/plugins/tpm"
  if [[ -e ${dst} ]]; then
    info "Tmux Plugin Manager present"

    CMD="cd \"${dst}\" && git pull"
    eval "${CMD}" \
      || fail "Could not update ${dst} from ${src}"
    success "linked ${dst} from ${src}"
  else
    info 'Cloning Tmux Plugin Manager'

    CMD="git clone ${src} \"${dst}\""
    eval "${CMD}" \
      || fail "Could not clone ${src} into ${dst}"
    fail ": ${src}"
  fi
}
do_dotfilerepo() {
  if [[ -d ${DOTDIR} ]]; then
    cd "${DOTDIR}" \
      || fail "Could not change into ${DOTDIR}"

    info "Updating ${DOTDIR}"
    git pull origin master --quiet \
      || fail "Could not update the repository: ${DOTDIR}"

    #update submodule
    cd antigen \
      || fail "Could not change into 'antigen'"
    git submodule update --quiet --init --recursive
  else
    info "Cloning ${DOTDIR}"
    # Quiet option not respected for submodules
    #git clone --quiet --recursive https://github.com/camelinc/Dotfiles.git "${DOTDIR}" \
    git clone --quiet https://github.com/camelinc/Dotfiles.git "${DOTDIR}" \
      || fail "Could not clone the repository to ${DOTDIR}"

    cd "${DOTDIR}" \
      || fail "Could not change into ${DOTDIR}"
    git submodule update --quiet --init --recursive \
      || fail "Could not clone submodules in ${DOTDIR}"
  fi
}
setup_macos() {
  # If we're on a Mac, let's install and setup homebrew.
  if [[ "$(uname -s)" == "Darwin" ]]; then
    info "configuring OSX system"
    #TODO: get latest version from https://mths.be/osx => https://github.com/mathiasbynens/dotfiles/blob/master/.osx
    if [[ -f ${DOTDIR}/osx ]] \
      && ask "Set the recommended OSx settings?" N;
    then
      # shellcheck source=./osx
      if [[ $(source ${DOTDIR}/osx) ]]; then
        success "OSX configured"
      else
        fail "error configuring OSX"
      fi
    fi

    if [[ ! -d "/usr/local/Cellar" ]]; then
      info "installing Homebrew"
      if [[ $(ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)") ]]; then
        success "Homebrew successfully installed"
      else
        fail "error installing command-line tools"
      fi
    else
      info "Updating Homebrew"

      CMD="brew update"
      eval "${CMD}"
      CMD="brew doctor"
      eval "${CMD}"
    fi

    info "installing command-line tools via Homebrew"
    if [[ -f Brewfile ]]; then
      if [[ $(brew bundle --file=Brewfile) ]]; then
        success "Tools successfully installed"
      else
        fail "error installing command-line tools"
      fi
    fi
  fi
}
setup_linux() {
  if [[ "$(uname -s)" == "Linux" ]]; then
    info "Configuring Linux system"

    #TODO: check flavor
    sudo apt install -y git-core python-pip
  fi
}
setup() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    setup_macos
  elif [[ "$(uname -s)" == "Linux" ]]; then
    setup_linux
  fi
}
main() {
  sudo -v \
    || fail "error configuring OSX"
  
  # Generic setup
  setup

  # Customization
  do_dotfilerepo
  install_antigen
  install_dotfiles
  install_powerline

  if ask "Install GDB Peda?" N; then
    install_peda
	fi;

  if [[ -e ${DOTDIR}/extra ]]; then
    # shellcheck disable=SC1090
    source "${DOTDIR}/extra"
  fi


}

main

