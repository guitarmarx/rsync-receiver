#!/bin/bash

# config ssh
echo "PermitRootLogin No" >> /etc/ssh/sshd_config

# add public keys to authorized keys

# add user
useradd  $SSH_USER
echo $SSH_USER:$SSH_PASSWORD | chpasswd

#create home folder
mkdir /home/$SSH_USER && chown -R $SSH_USER $SSH_USER

# add public keys to authorized keys
rm  -r /home/$SSH_USER/.ssh/ | true
mkdir /home/$SSH_USER/.ssh/

keys=(/srv/keys/*)
if [ ${#files[@]} -gt 0 ]; then
    cat /srv/keys/* >> /home/$SSH_USER/.ssh/authorized_keys
else
    echo "key not found in /srv/keys/"
fi

# set folder permission
mkdir -p $TARGET_FOLDER
mkdir -p $TARGET_FOLDER/archiv
chown -R $SSH_USER $TARGET_FOLDER

# start cron and  ssh
service ssh start
cron -f

