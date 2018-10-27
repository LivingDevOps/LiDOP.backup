#! /bin/sh

set -e

. ./backup_destination/${BACKUP_DESTINATION}/restore.sh
echo "Restore from ${latest_backup}"

echo "Fetching ${latest_backup} from ${BACKUP_FOLDER}/${BACKUP_MODE}/"

tar -xvpzf ${latest_backup}

echo "Restore complete"
