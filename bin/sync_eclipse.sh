#!/bin/sh
#rsync -aiz --partial --links --delete --exclude-from /cygdrive/c/Users/jens/bin/sync_eclipse.exclude //pazuzu/eclipse/* /cygdrive/c/eclipse4/
#rsync -aiz --partial --links --delete --exclude-from /cygdrive/c/Users/jens/bin/sync_eclipse.exclude rsync://pazuzu.attensity.zz:873/eclipse/* /cygdrive/c/eclipse4/

rsync -rltgoDiz --delete --exclude-from /cygdrive/c/Users/jens/bin/sync_eclipse.exclude rsync://10.20.11.58:873/eclipse/* /cygdrive/c/eclipse/