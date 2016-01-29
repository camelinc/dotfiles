#!/usr/bin/env bash

# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# https://github.com/vqv/dotfiles/
# http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming

#readonly DOTDIR="${HOME}/Documents/Dotfiles"
readonly DOTDIR="${HOME}/.dotfiles"
readonly PROGNAME=$(basename "$0")
tmp=$(dirname "$0")
readonly PROGDIR=$(readlink -m "${tmp}")
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
    pip install --user git+git://github.com/Lokaltog/powerline
  else
    info 'updating powerline'
    pip install --user --upgrade git+git://github.com/Lokaltog/powerline
  fi

  if [[ ! -d ${fontdir} ]]; then
    mkdir "${fontdir}"
  fi
  cd "${fontdir}" \
      || fail "Could not change into ${fontdir}"

  src="${HOME}/.fonts/powerline-fonts/"
  if [[ ! -d ${src} ]]; then
    git clone https://github.com/Lokaltog/powerline-fonts.git "${src}"
  else
    cd "${src}" \
      || fail "Could not change into ${src}"
    git pull
  fi


  info 'installing powerline-fonts'
  fcchache_bin=$(which fc-cache)
  if [[ ! -x "${fcchache_bin}" ]]; then
    info 'installing fontconfig'
    sudo apt-get install -y fontconfig
  fi

  sudo "${fcchache_bin}" -vf "${fontdir}"  #FIXME: fc-cache installed?
}

install_dotfiles () {
  info 'installing dotfiles'

  while IFS= read -r -d '' src
  do
    local dst
    dst="${HOME}/.$(basename "${src%.*}")"

    if [[ -f "$dst" || -d "$dst" || -L "$dst" ]]; then
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
do_dotfilerepo() {
  if [[ -d ${DOTDIR} ]]; then
    cd "${DOTDIR}" \
      || fail "Could not change into ${DOTDIR}"

    info "Updating ${DOTDIR}"
    git pull origin master \
      || fail "Could not update the repository: ${DOTDIR}"

    #update submodule
    cd antigen \
      || fail "Could not change into 'antigen'"
    git submodule update --init --recursive
  else
    info "Cloning ${DOTDIR}"
    git clone --recursive https://github.com/camelinc/Dotfiles.git "${DOTDIR}" \
      || fail "Could not clone the repository to ${DOTDIR}"
  fi
}

main() {
  sudo -v

  do_dotfilerepo
  install_antigen
  install_dotfiles
  install_powerline

  if [[ -e ${DOTDIR}/extra ]]; then
    # shellcheck disable=SC1090
    source "${DOTDIR}/extra"
  fi


  # If we're on a Mac, let's install and setup homebrew.
  if [[ "$(uname -s)" == "Darwin" ]]; then
    info "configuring OSX system"
    if [[ -f ${DOTDIR}/osx ]]; then
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
        success "Tools successfully installed"
      else
        fail "error installing command-line tools"
      fi
    else
      info "updating homebrew"

      CMD="brew update"
      eval "${CMD}"
      CMD="brew doctor"
      eval "${CMD}"
    fi

    info "installing command-line tools via Homebrew"
    if [[ -f Brewfile ]]; then
      if [[ $(brew bundle Brewfile) ]]; then
        success "Tools successfully installed"
      else
        fail "error installing command-line tools"
      fi
    fi

    info "installing GUI tools via Cask"
    if [[ -f Brewfile ]]; then
      if [[ $(brew bundle Caskfile) ]]; then
        success "GUI tools successfully installed"
      else
        fail "error installing GUI tools"
      fi
    fi

  fi
}

main

