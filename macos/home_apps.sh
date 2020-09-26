#!/bin/sh

if ! which brew > /dev/null 2>&1; then
  echo Homebrew must be installed.
  exit 1
fi

# update homebrew formulae
brew update

# install homebrew packages
packages='
  flake8
  nmap
  reattach-to-user-namespace
  tmux
  wget
'
brew install $packages

# cask-drivers is required for some items
brew tap homebrew/cask-drivers

# install homebrew casks
casks='
  1password
  bbedit
  google-backup-and-sync
  google-chrome
  firefox
  moonlight
  openemu
  parallels
  steam
  splashtop-personal
'
brew cask install $casks

# git profile, if needed
if ! [ -d ~/profile ]; then
  cd
  git clone git@github.com:briancamp/profile
  yes | ./profile/install-dot-files
fi
