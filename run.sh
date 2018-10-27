#! /bin/bash

set -e

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

if [ "${SCHEDULE}" = "**None**" ]; then

    if [ "${TARGET,,}" = "restore" ]; then
        echo "Restore"
        bash backup_mode/${BACKUP_MODE,,}/restore.sh
    else
        echo "Backup"
        bash backup_mode/${BACKUP_MODE,,}/backup.sh
    fi

else
  echo "Create Cron"
  exec go-cron "$SCHEDULE" /bin/bash ${BACKUP_MODE,,}/backup.sh
fi