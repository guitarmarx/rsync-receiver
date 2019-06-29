######### CONFIGURATION #############
#target
TARGET_SERVER=meteorit-leipzig.de
TARGET_PORT=43000
SSH_USER=rsync
SSH_KEY=/srv/sslkey.key

#source
BACKUP_DIR=/srv/backup

######### DO NOT EDIT AFTER THIS LINE #############
# Parameter
SSH_OPTS="-i $SSH_KEY -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p ${TARGET_PORT}"
TARGET_PATH=/srv/backup
DATE=$(date '+%Y-%m-%d_%H-%M')
ARCHIV_PATH="/var/log/rsync-backup"
LOGFILE=${ARCHIV_PATH}/${DATE}-backup.log

# create log file folder
mkdir -p ${ARCHIV_PATH}

# delete old log files
find ${ARCHIV_PATH}* -mtime +30 -exec rm {} \;


#start rsync backup
echo "start backup process..."
sshpass -p $SSH_PASSWORD rsync -a -E --human-readable --stats -e "ssh  $SSH_OPTS" $BACKUP_DIR ${SSH_USER}@${TARGET_SERVER}:${TARGET_PATH} > $LOGFILE 2>&1
exitcode=$?

#add metadata to logfile
echo "------------------------------------" | cat - $LOGFILE  > temp && mv temp $LOGFILE
echo exitcode=$exitcode | cat - $LOGFILE  > temp && mv temp $LOGFILE


#send logfile to server
echo "send logfile to server..."
sshpass -p $SSH_PASSWORD rsync -a -e "ssh  $SSH_OPTS" $LOGFILE ${SSH_USER}@${TARGET_SERVER}:${TARGET_PATH}/${DATE}-backup.log

