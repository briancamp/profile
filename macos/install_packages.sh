#!/bin/sh

xargs brew install <<'PACKAGES'
flake8
inetutils
mas
nmap
pv
pwgen
reattach-to-user-namespace
shellcheck
tmux
wget
PACKAGES
