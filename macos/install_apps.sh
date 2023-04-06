#!/bin/sh

if ! which brew > /dev/null 2>&1; then
  echo Homebrew must be installed.
  exit 1
fi

# update homebrew formulae
brew update

# install homebrew packages
packages='
  aria2
  bash
  glib
  nmap
  pwgen
  reattach-to-user-namespace
  telnet
  tmux
  wget
'
brew install $packages
