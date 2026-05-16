#!/bin/sh
if [ "$(id -u)" -ne 0 ]; then
  exec sudo -E "$0"
fi

packages='
  bind9-utils
  git
  iperf3
  lsof
  lz4
  net-tools
  nmap
  nvme-cli
  pciutils
  pv
  pwgen
  python3-flake8
  rsync
  screen
  shellcheck
  swaks
  tar
  tcpdump
  telnet
  tmux
  vim
  udisks2
  wget
  whois
  wireguard-tools
  zstd
'

apt-get update
# shellcheck disable=SC2086
apt-get install -y $packages
