#! /bin/sh

set -e
set -o pipefail

if [ "${POSTGRES_DATABASE}" = "**None**" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ "${POSTGRES_HOST}" = "**None**" ]; then
  echo "You need to set the POSTGRES_HOST environment variable."
  exit 1
fi

if [ "${POSTGRES_USER}" = "**None**" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ "${POSTGRES_PASSWORD}" = "**None**" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

mkdir -p ${BACKUP_FOLDER}
mkdir -p ${BACKUP_FOLDER}/${BACKUP_MODE}

export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

backup_file_name=$(date +"%Y-%m-%dT%H:%M:%SZ").tar.gz
backup_file=${BACKUP_FOLDER}/${BACKUP_MODE}/${backup_file_name}

echo "Save dump to ${backup_file}"
pg_dump $POSTGRES_HOST_OPTS $POSTGRES_DATABASE | gzip > ${backup_file}

echo "List of Backups"
ls ${BACKUP_FOLDER}/${BACKUP_MODE}

echo "SQL backup created successfully"
echo "Folder backup created successfully"
. ./../backup_destination/${BACKUP_DESTINATION}/backup.sh