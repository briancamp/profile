#!/bin/sh

xargs brew install <<'PACKAGES'
flake8
inetutils
macmon
mas
nmap
pv
pwgen
reattach-to-user-namespace
shellcheck
tmux
wget
PACKAGES
