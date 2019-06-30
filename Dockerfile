FROM  python:3.7-slim

LABEL maintainer="meteorIT GbR Marcus Kastner"
EXPOSE 22

ENV SSH_USER="rsync" \
	SSH_KEY='' \
	SLACK_WEBHOOK_URL="URL"

#install packages
RUN apt update \
	&& apt -y dist-upgrade \
	&& apt install -y --no-install-recommends openssh-server rsync cron \
	&& pip install requests \
	&& rm -rf  /var/cache/apt  /var/lib/apt/lists/*


ADD templates /srv/script/templates
ADD check.py /srv/script
ADD entrypoint.sh /srv/script

RUN chmod +x /srv/script/entrypoint.sh \
	&& cp /srv/script/templates/crontab /etc/crontab \
	&& cp /srv/script/templates/sshd_config /etc/ssh/

VOLUME /srv/backup
ENTRYPOINT ["/srv/script/entrypoint.sh"]