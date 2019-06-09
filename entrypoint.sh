# config ssh
echo "PermitRootLogin No" >> /etc/ssh/sshd_config

# add user
useradd $SSH_USER
echo $SSH_USER:$SSH_PASSWORD | chpasswd

# set folder permission
mkdir -p $TARGET_FOLDER
chown -R $SSH_USER $TARGET_FOLDER

# start cron and  ssh
service cron start
service ssh start


# monitor check log
tail -f  /var/log/check.log

