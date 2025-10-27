#!/bin/sh

# ssh, with deprecated / insecure options enabled
badssh() {
  ssh -o Ciphers=+aes128-cbc,aes192-cbc,aes256-cbc \
      -oKexAlgorithms=+diffie-hellman-group-exchange-sha1 \
      -oKexAlgorithms=+diffie-hellman-group1-sha1 \
      -oKexAlgorithms=+diffie-hellman-group14-sha1 \
      -oHostKeyAlgorithms=+ssh-rsa \
      -oHostKeyAlgorithms=+ssh-dss \
      -oPubkeyAcceptedAlgorithms=+ssh-rsa \
      "$@"
}


cmd_exists() {
  for cmd do
    command -v -- "$cmd" >/dev/null 2>&1 || return 1
  done
  return 0
}


is_cygwin_like() {
  command -v uname >/dev/null 2>&1 || return 1
  case "$(uname -s 2>/dev/null)" in
    CYGWIN*|MSYS*|MINGW*) return 0 ;;
    *)                    return 1 ;;
  esac
}


lsb_version() {
  lsb_release -sir
}


macos_version() {
  echo "MacOS $(sw_vers -productVersion)"
}


os_release_version() {
  (
    . /etc/os-release > /dev/null 2>&1
    echo "$NAME $VERSION_ID"
  )
}


set -o vi
export VISUAL=vi
export EDITOR=vi

for dir in /bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin \
           "$HOME/bin" "$HOME/.local/bin" /opt/homebrew/bin
  do
    [ -d "$dir" ] || continue
    case ":$PATH:" in
      *":$dir:"*) : ;;                           # already present
      *) PATH="$dir${PATH:+:$PATH}" ;;           # prepend
    esac
done
unset dir

if cmd_exists lsb_release; then
  os_version=$(lsb_version)
elif [ -f /etc/os-release ]; then
  os_version=$(os_release_version)
elif cmd_exists sw_vers uname && [ "$(uname)" = Darwin ]; then
  os_version=$(macos_version)
elif is_cygwin_like && cmd_exists uname sed; then
  os_version="Windows $(uname | sed 's/.*-//')"
  export DISPLAY=:0.0
  if cmd_exists ssh-pageant && [ -n "$TEMP" ]; then
    eval "$(ssh-pageant -ra "$TEMP/.ssh-pageant")"
  fi
elif cmd_exists uname; then
  os_version=$(uname -sr)
else
  os_version=Unknown
fi

if cmd_exists uname; then
  os_platform="/$(uname -m)"
else
  os_platform=
fi

os_label="$os_version$os_platform"

if [ -n "$ZSH_NAME" ]; then
  # shellcheck disable=SC3003
  PS1='%F{green}%n@%m:%~ ('"$os_label"')%f'$'\n$ '
else
  PS1="\[\e[0;32m\]\u@\h:\w ($os_label)\[\e[0m\]\n\$ "
fi

if [ -n "$ZSH_NAME" ]; then
  # Enable bash-like ctrl-r search
  bindkey "^R" history-incremental-search-backward
  # keep zsh from getting in the way of rm -f ./blah/*
  setopt rmstarsilent
  # disable undesirable zsh glob behavior
  unsetopt nomatch
  # make tab completion more like ksh
  setopt bash_autolist
fi

export CLICOLOR=yes
have_colorls='' have_gnuls='' have_bsdls=''
if command -v colorls >/dev/null 2>&1; then
  have_colorls=1
elif command ls --color=auto -d . >/dev/null 2>&1; then
  have_gnuls=1
elif command ls -G -d . >/dev/null 2>&1; then
  have_bsdls=1
fi
if [ -n "$have_colorls" ]; then
  alias ls='colorls'
elif [ -n "$have_gnuls" ]; then
  alias ls='ls --color=auto'
elif [ -n "$have_bsdls" ]; then
  export CLICOLOR=1
  alias ls='ls -G'
fi

if cmd_exists doas && ! cmd_exists sudo; then
  alias sudo=doas
fi

if [ -n "$BASH_VERSION" ]; then
  # shellcheck disable=SC3044
  complete -r > /dev/null 2>&1
  if ! [ -f ~/.bash_sessions_disable ]; then
    touch ~/.bash_sessions_disable 2> /dev/null
  fi
  unset command_not_found_handle
fi

# Link a predictible path to ssh-agent's socket, to keep tmux
# re-attaches from breaking ssh.
if [ -n "$SSH_AUTH_SOCK" ]; then
  persist_sock="$HOME/.ssh/agent.sock"
  if [ "$SSH_AUTH_SOCK" != "$persist_sock" ]; then
    ln -sf "$SSH_AUTH_SOCK" "$persist_sock" && \
    export SSH_AUTH_SOCK="$persist_sock"
  fi
  unset persist_sock
fi

# (try to) disable core dumps
# shellcheck disable=SC3045
ulimit -c 0 > /dev/null 2>&1

. ~/.profile.local 2> /dev/null
