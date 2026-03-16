#!/bin/sh

if [ $UID -ne 0 ]; then
  exec sudo -E "$0"
fi

packages='
  bind-utils
  bindutils
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
  ShellCheck
  swaks
  tcpdump
  telnet
  tmux
  vim
  udisks2
  udisks2-btrfs
  udisks2-lvm2
  wget
  whois
  wireguard-tools
  zstd
'

if ! rpm -q epel-release > /dev/null 2>&1; then
  dnf install -y epel-release
fi

crb enable > /dev/null 2>&1

# shellcheck disable=SC2086
dnf install -y --skip-broken $packages
