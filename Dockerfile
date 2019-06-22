FROM  python:3.7-slim

LABEL maintainer="meteorIT GbR Marcus Kastner"
EXPOSE 22

ENV SSH_USER="rsync" \
	SSH_PASSWORD="password" \
	TARGET_FOLDER=/srv/backup \
	SLACK_WEBHOOK_URL="URL"

#install packages
RUN apt update \
	&& apt -y dist-upgrade \
	&& apt install -y --no-install-recommends openssh-server rsync cron \
	&& pip install requests \
	&& rm -rf  /var/cache/apt  /var/lib/apt/lists/*


ADD backup-checker /srv/backup-checker
ADD templates /srv/templates
ADD entrypoint.sh /srv

RUN chmod +x /srv/entrypoint.sh \
	&& cp /srv/templates/crontab /etc/crontab \
	&& cp /srv/templates/sshd_config /etc/ssh/

VOLUME $TARGET_FOLDER
VOLUME /srv/keys
ENTRYPOINT ["/srv/entrypoint.sh"]