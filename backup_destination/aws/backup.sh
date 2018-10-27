#!/bin/bash
echo "Upload backup to S3"
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
# Create bucket, if it doesn't already exist (only try if listing is successful - access may be denied)

bucket_ls=$(aws s3 --region $S3_REGION ls)
if [ $? -eq 0 ]; then
  echo "Test if bucket exists"
  export bucket_exists=$(echo $bucket_ls | grep $S3_BUCKET | wc -l)
  if [ $bucket_exists -eq 0 ]; then
    echo "create bucket ${S3_BUCKET}"
    aws s3 --region $S3_REGION mb s3://$S3_BUCKET
  fi
fi

# Upload the backup to S3 with timestamp
s3_url=s3://${S3_BUCKET}/${BACKUP_MODE}/${backup_file_name}
echo "Uploading ${backup_file_name} the archive to S3 ${s3_url}"
time aws s3 --region $S3_REGION cp ${backup_file} "${s3_url}"