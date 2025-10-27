#!/bin/sh

xargs brew install <<'PACKAGES'
autossh
flake8
mas
nmap
pv
pwgen
reattach-to-user-namespace
shellcheck
telnet
tmux
wget
PACKAGES
