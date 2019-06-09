######### CONFIGURATION #############
#target
TARGET_SERVER=meteorit-leipzig.de
TARGET_PORT=43000
SSH_USER=fortis
SSH_PASSWORD=fortis

#source
BACKUP_DIR=/srv/backup

######### DO NOT EDIT AFTER THIS LINE #############
TARGET_PATH=/srv/backup
LOGFILE=/tmp/backup.log

#start rsync backup
echo "start backup process..."
sshpass -p $SSH_PASSWORD rsync -a -E --human-readable --stats -e "ssh  -o StrictHostKeyChecking=no -p ${TARGET_PORT}" $BACKUP_DIR ${SSH_USER}@${TARGET_SERVER}:${TARGET_PATH} >$LOGFILE

#write logfile with status code
returncode=$?
echo $(date) >> $LOGFILE
echo code=$returncode | cat - $LOGFILE  > temp && mv temp $LOGFILE

#send logfile to server
echo "send logfile to server..."
sshpass -p $SSH_PASSWORD rsync -a -e  "ssh -o StrictHostKeyChecking=no -p ${TARGET_PORT}" $LOGFILE ${SSH_USER}@${TARGET_SERVER}:${TARGET_PATH}/report.txt

