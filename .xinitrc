#exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
exec dbus-launch --sh-syntax --exit-with-session awesome
