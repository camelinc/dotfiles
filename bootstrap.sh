#!/bin/bash

# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# https://github.com/vqv/dotfiles/

dotdir="${HOME}/Documents/Dotfiles"
dotdir="${HOME}/.dotfiles"

info () {
  printf "  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1\n"
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
  fontdir="${HOME}/.fonts/"

  if [[ -z $(pip list | grep powerline) ]]; then
    info 'installing powerline'
    pip install --user git+git://github.com/Lokaltog/powerline
  else
    info 'updating powerline'
    pip install --user --upgrade git+git://github.com/Lokaltog/powerline
  fi

  if [[ ! -d ${fontdir} ]]; then
    mkdir ${fontdir}
  fi
  cd ${fontdir}

  src="${HOME}/.fonts/powerline-fonts/"
  if [[ ! -d ${src} ]]; then
    git clone https://github.com/Lokaltog/powerline-fonts.git ${src}
  else
    cd ${src}
    git pull
  fi

  info 'installing powerline-fonts'
  sudo fc-cache -vf ${fontdir}
}

install_dotfiles () {
  info 'installing dotfiles'

  for src in $(find "$dotdir" -maxdepth 2 -name '*.symlink'); do
    dst="$HOME/.$(basename "${src%.*}")"

    if [[ -f "$dst" || -d "$dst" || -L "$dst" ]]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    CMD="ln -s \"${src}\" \"${dst}\""
    eval "${CMD}" \
      || fail "Could not link ${src} to ${dst}"
    success "linked ${src} to ${dst}"
  done
}

install_antigen() {
  info 'installing antigen'

  src="${dotdir}/antigen/antigen.zsh"
  if [[ -e ${src} ]]; then
    info "antigen present"

    dst="$HOME/.antigen.zsh"
    if [[ -f "$dst" || -d "$dst" || -L "$dst" ]]; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    CMD="ln -s \"${src}\" \"${dst}\""
    eval ${CMD} \
      || fail "Could not link ${src} to ${dst}"
    success "linked ${src} to ${dst}"
  else
    fail "Antigen repository missing: ${src}"
  fi
}
do_dotfilerepo() {
  if [[ -d ${dotdir} ]]; then
    cd ${dotdir}

    info "Updating ${dotdir}"
    git pull origin master \
      || fail "Could not update the repository: ${dotdir}"

    #update submodule
    cd antigen
    git submodule update --init --recursive
  else
    info "Cloning ${dotdir}"
    git clone --recursive https://github.com/camelinc/Dotfiles.git "${dotdir}" \
      || fail "Could not clone the repository to ${dotdir}"
  fi
}

do_dotfilerepo
install_antigen
install_dotfiles
install_powerline

if [[ -e ${dotdir}/extra ]]; then
  # Clone Dotfiles
  source "${dotdir}/extra"
fi


# If we're on a Mac, let's install and setup homebrew.
if [[ "$(uname -s)" == "Darwin" ]]; then
  info "configuring OSX system"
  if [[ -f osx ]]; then
    if [[ $(source osx) ]]; then
      success "OSX configured"
    else
      fail "error configuring OSX"
    fi
  fi

  info "installing Homebrew"
  if [[ $(ruby -e "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)") ]]; then
    success "Tools successfully installed"
  else
    fail "error installing command-line tools"
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

