#! /bin/sh

set -e
set -o pipefail

echo "Start backup"
mkdir -p ${BACKUP_FOLDER}
mkdir -p ${BACKUP_FOLDER}/${BACKUP_MODE}

backup_file_name=$(date +"%Y-%m-%dT%H:%M:%SZ").tar.gz
backup_file=${BACKUP_FOLDER}/${BACKUP_MODE}/${backup_file_name}

echo "Backup file ${backup_file}"
tar -cvpzf ${backup_file} ${FOLDER_TOBACKUP}

echo "List of all backups"
ls ${BACKUP_FOLDER}/${BACKUP_MODE}

echo "Folder backup created successfully"
. ./../backup_destination/${BACKUP_DESTINATION}/backup.sh