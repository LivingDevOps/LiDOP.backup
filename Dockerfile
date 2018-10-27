FROM alpine

RUN apk update \
&& apk add postgresql \
&& apk add python py2-pip bash \
&& pip install awscli \
&& apk del py2-pip \
&& apk add curl \
&& curl -L --insecure https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz | zcat > /usr/local/bin/go-cron \
&& chmod u+x /usr/local/bin/go-cron \
&& apk del curl \
&& rm -rf /var/cache/apk/*

ENV TARGET backup
ENV BACKUP_DESTINATION local
ENV BACKUP_MODE folder

ENV BACKUP_FOLDER "/var/backups"

# If BACKUP_MODE = folder
ENV FOLDER_TOBACKUP '/var/tobackup'

# If BACKUP_MODE = postgres
ENV POSTGRES_DATABASE **None**
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD **None**
ENV POSTGRES_EXTRA_OPTS ''

ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no

ENV SCHEDULE **None**

ADD run.sh run.sh
ADD . .

CMD ["bash", "run.sh"]