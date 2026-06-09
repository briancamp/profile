#!/usr/bin/env zsh
set -uo pipefail

sudoers_file="/etc/sudoers.d/${USER}"
rule="${USER} ALL=(ALL) NOPASSWD: ALL"

if sudo grep -qxF "$rule" "$sudoers_file" 2>/dev/null; then
  echo "ok: ${sudoers_file} already present"
  exit 0
fi

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT
printf '%s\n' "$rule" > "$tmp_file"

if ! sudo /usr/sbin/visudo -cf "$tmp_file"; then
  echo "FAIL: syntax check failed; not installing" >&2
  exit 1
fi

if ! sudo /usr/bin/install -o root -g wheel -m 0440 \
    "$tmp_file" "$sudoers_file"; then
  echo "FAIL: could not install ${sudoers_file}" >&2
  exit 1
fi

echo "installed ${sudoers_file}"
