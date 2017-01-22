#!/bin/sh
path=/run/media/jens/FREEAGENT/_Backup/
params='-rlptgoDiv --partial --inplace --delete'

exclude=/home/jens/bin/sync_freeagent_home.exclude
tmp_exclude=/tmp/rsync-excludes.txt

touch $tmp_exclude
>$tmp_exclude
cat $exclude > $tmp_exclude
find . -regextype posix-extended -regex '.*(tmp|temp|temporary|cache)/.*' -type d >> $tmp_exclude
echo "Excluding:"
cat $tmp_exclude;

source=/home/jens/
target=$path/Home/
echo "Backup: Home ($source : $target)"
rsync $params --exclude-from $tmp_exclude $source $target

#source=/cygdrive/c/Program\ Files\ \(x86\)/OpenVPN\ Technologies/OpenVPN\ Client/etc/profile/
#target=$path/OpenVPN/
#echo "Backup: VPN Profiles  ($source : $target)"
#rsync $params "$source" "$target"
