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
rm  -r /home/$SSH_USER/.ssh/
mkdir /home/$SSH_USER/.ssh/
cat /srv/keys/* >> /home/$SSH_USER/.ssh/authorized_keys

# set folder permission
mkdir -p $TARGET_FOLDER
mkdir -p $TARGET_FOLDER/archiv
chown -R $SSH_USER $TARGET_FOLDER

# start cron and  ssh
service ssh start
cron -f

