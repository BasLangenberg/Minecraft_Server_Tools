#!/usr/bin/env bash

## Backup script for minecraft
## Written by Bas Langenberg, 2019
## Part of https|//github.com/BasLangenberg/Minecraft_Server_Tools

# Variables
HOURLY_KEEP=12
DAILY_KEEP=4
WEEKLY_KEEP=1
MONTHLY_KEEP=1

BASEDIR=$(dirname "$0")
DATE=$(date +"%d%m%y%H%M")
# Funcions
usage() {
  echo "USAGE: `basename $0` {hourly|daily|weekly|monthly}"
  exit 1
}

mc () {
    /usr/bin/tmux send-keys -t mc:0.0 "$1" Enter
}

check_backup_dirs() {
  if [ ! -d "$BASEDIR/backups" ]; then
    mkdir "$BASEDIR/backups"
  fi

  if [ ! -d "$BASEDIR/backups/hot" ]; then
    mkdir "$BASEDIR/backups/hot"
  fi
}

# Main
if [[ $# != 1 ]]; then
  usage
fi

case $1 in
  daily|hourly|monthly|weekly)
    runmode=$1
    ;;
  *)
    usage
    exit 1
    ;;
esac

check_backup_dirs

mc "say Backup starting now"
mc "save-off"
mc "save-all"

sync

sleep 1

rsync -av $BASEDIR/world/ $BASEDIR/backups/hot/

mc "save-on"
mc "save-all"

# zip
echo $DATE
echo $runmode
cd $BASEDIR/backups/hot && tar -zcf ../${runmode}_${DATE}_tar.gz . && cd -

mc "say World has been backupped!"

# retention
cleanup

exit 0
