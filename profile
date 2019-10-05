cmd_exists() {
  while [ -n "$1" ]; do
    if ! which "$1" > /dev/null 2>&1; then
      return 1
    fi
    shift
  done
  return 0
}


lsb_version() {
  echo $(lsb_release -sir)
}


macos_version() {
  echo -n 'MacOS '
  sw_vers -productVersion  
}


os_release_version() {
  (
    . /etc/os-release > /dev/null 2>&1
    echo $PRETTY_NAME
  )
}


set -o vi
export VISUAL=vi
export EDITOR=vi

for dir in /bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin \
           "$HOME/bin" "$HOME/.local/bin"; do
  if [ -d "$dir" ] && [[ ":$PATH:" != *":$dir:"* ]]; then
    PATH="$dir:${PATH+"$PATH"}"
  fi
done
unset dir

if cmd_exists lsb_release; then
  os_version=$(lsb_version)
elif [ -f /etc/os-release ]; then
  os_version=$(os_release_version)
elif cmd_exists sw_vers uname && [ "$(uname)" = Darwin ]; then
  os_version=$(macos_version)
elif [ "$OSTYPE" = cygwin ] && cmd_exists uname sed; then
  os_version="Windows $(uname | sed 's/.*-//')"
  export DISPLAY=:0.0
  if cmd_exists ssh-pageant && [ -n "$TEMP" ]; then
    eval $(ssh-pageant -ra "$TEMP/.ssh-pageant")
  fi
elif cmd_exists uname; then
  os_version=$(uname -sr)
else
  os_version=Unknown
fi

if [ -n "$ZSH_NAME" ]; then
  PS1=$(echo -e "\033[0;32m%n@%m:%~ ($os_version)\033[0m\n\$ ")
else
  PS1=$(echo -e "\033[0;32m\u@\h:\w ($os_version)\[\033[0m\]\n\$ ")
fi

export CLICOLOR=yes
if cmd_exists colorls; then
  alias ls=colorls
elif ls --color > /dev/null 2>&1; then
  alias ls="ls --color"
fi

if cmd_exists doas && ! cmd_exists sudo; then
  alias sudo=doas
fi

if [ -n "$BASH_VERSION" ]; then
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

. ~/.profile.local 2> /dev/null
