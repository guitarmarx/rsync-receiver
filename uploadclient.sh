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
rsync -a -E --human-readable --stats -e "ssh -p ${TARGET_PORT}" $BACKUP_DIR ${SSH_USER}@${TARGET_SERVER}:${TARGET_PATH} >$LOGFILE
echo $(date) >> $LOGFILE

#write logfile with status code
returncode=$?
echo code=$returncode | cat - $LOGFILE  > temp && mv temp $LOGFILE

#send logfile to server
rsync -a  $LOGFILE ${TARGET_PATH}/report.txt
