#!/bin/sh

case "$(hostname -s)" in
    dogan)
        xrandr --dpi 220
        echo 'Xft.dpi: 220' | xrdb -merge -
        synclient TapButton2=3 TapButton3=2
        xbacklight -set 50
    ;;
    skull-canyon)
        xrandr --dpi 220
        echo 'Xft.dpi: 220' | xrdb -merge -
    ;;
esac

xsetroot -solid \#111111

xrdb -merge .Xdefaults

eval `ssh-agent -s`
ssh-add < /dev/null

xautolock -corners 000+ -cornerdelay 2 -locker 'xlock -mode blank' &
bash -lc "exec spectrwm"

ssh-agent -k
