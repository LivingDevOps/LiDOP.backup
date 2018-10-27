#! /bin/sh

set -e
set -o pipefail

if [ "${S3_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${S3_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

#!/bin/bash

if [ ! -n "${LAST_BACKUP}" ]; then
  echo "Find last backup file"
  aws s3 --region $S3_REGION ls s3://$S3_BUCKET/$BACKUP_MODE --recursive
  LAST_BACKUP=$(aws s3 --region $S3_REGION ls s3://$S3_BUCKET/$BACKUP_MODE --recursive | awk -F " " '{print $4}' | grep ^$BACKUP_MODE | sort -r | head -n1)
  echo "Found ${LAST_BACKUP}"
fi

# Download backup from S3
latest_backup=$BACKUP_FOLDER/$LAST_BACKUP
echo "Retrieving backup archive $LAST_BACKUP..."
aws s3 --region $S3_REGION cp s3://$S3_BUCKET/$LAST_BACKUP $latest_backup || (echo "Failed to download tarball from S3"; exit)
