#!/bin/sh

# Remove emacs keybindings from GTK apps
# https://www.youtube.com/watch?v=NpNDtth15dw

set -e
set -x

mkdir -p ~/.config/gtk-2.0 ~/.config/gtk-3.0 && \
echo 'gtk-key-theme-name="Default"' >> ~/.config/gtk-2.0/gtkrc-2.0
printf '[Settings]\ngtk-key-theme-name=Default\n' >> ~/.config/gtk-3.0/settings.ini
