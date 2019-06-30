#!/bin/bash

# config ssh
echo "PermitRootLogin No" >> /etc/ssh/sshd_config

# add public keys to authorized keys

# add user
useradd  $SSH_USER

#create home folder
mkdir -p /home/$SSH_USER/.ssh/ && chown -R $SSH_USER /home/$SSH_USER
mkdir /srv/log

# add public keys to authorized keys
rm -r  /home/$SSH_USER/.ssh/* &> /dev/null

keys=(/srv/keys/*)
if [ ${#keys[@]} -gt 0 ]; then
    cat /srv/keys/* >> /home/$SSH_USER/.ssh/authorized_keys
else
    echo "key not found in /srv/keys/"
fi

# set folder permission
mkdir -p $TARGET_FOLDER
mkdir -p $TARGET_FOLDER/archiv
chown -R $SSH_USER $TARGET_FOLDER

#set webhook url
sed -i "s|webhookURL =.*|webhookURL = '$SLACK_WEBHOOK_URL'|g" /srv/script/check.py

# start cron and  ssh
service ssh start
cron -f

