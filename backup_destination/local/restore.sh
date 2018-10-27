#! /bin/sh

set -e
set -o pipefail
echo "Finding latest backup from:"
ls ${BACKUP_FOLDER}/${BACKUP_MODE}

latest_backup=${BACKUP_FOLDER}/${BACKUP_MODE}/$(ls ${BACKUP_FOLDER}/${BACKUP_MODE} | sort | tail -n 1)