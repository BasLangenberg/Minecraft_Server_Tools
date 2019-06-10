#!/usr/bin/env bash

## Backup script for minecraft
## Written by Bas Langenberg, 2019
## Part of https|//github.com/BasLangenberg/Minecraft_Server_Tools

## TODO: Support more sophisticated backup scheme
## For now we only support hourly backups, the script suggestes otherwise...

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
  echo "For now, only hourly is supported"
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

  if [ ! -d "$BASEDIR/backups/arch" ]; then
    mkdir "$BASEDIR/backups/arch"
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
cd $BASEDIR/backups/hot && tar -zcf ../arch/${runmode}_${DATE}_tar.gz . && cd -

mc "say World has been backupped!"

# retention
ls -tp $BASEDIR/backups/arch/ | grep -v '/$' | tail -n +25 | xargs -I {} rm -- {}

exit 0
