case "$(hostname -s)" in
  dogan)
    xbacklight -set 40
    xrandr --dpi 220
    synclient TapButton2=3 TapButton3=2
    ;;
esac

if [ "$(uname -s 2> /dev/null)" == "OpenBSD" ]; then
    doas -n pkill xconsole
fi

xsetroot -solid \#111111
xautolock -corners 000+ -cornerdelay 2 -locker xlock &
exec ksh -lc "exec spectrwm"
