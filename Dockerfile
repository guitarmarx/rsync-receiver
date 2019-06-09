FROM  python:3.7-slim

LABEL maintainer="meteorIT GbR Marcus Kastner"
EXPOSE 22

ENV SSH_USER="user" \
	SSH_PASSWORD="password" \
	TARGET_FOLDER=/srv/backup \
	SLACK_WEBHOOK_URL="https://hooks.slack.com/services/<TOKEN>"

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
	&& cp /srv/templates/crontab /etc/crontab

VOLUME $TARGET_FOLDER
ENTRYPOINT ["/srv/entrypoint.sh"]


#docker run -p 4022:22 --rm --entrypoint "/usr/bin/tail" rsync-checker:latest -f /etc/resolv.conf
#docker run -p 4022:22 -it --rm  rsync-checker:latest