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
  tar
  tcpdump
  telnet
  tmux
  vi
  vim
  udisks2
  udisks2-btrfs
  udisks2-lvm2
  wget
  whois
  wireguard-tools
  zstd
'

if ! dnf repolist 2>&1 | grep -i epel; then
  dnf install -y --skip-broken epel-release oracle-epel-release-\*
fi

if [ -f /etc/oracle-release ]; then
  dnf config-manager --set-enabled ol*_codeready_builder > /dev/null 2>&1
fi

crb enable > /dev/null 2>&1

# shellcheck disable=SC2086
dnf install -y --skip-broken $packages
