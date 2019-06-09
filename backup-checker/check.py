import logging
import os
import requests
import sys
import time

def initLogging(logFormat, logLevel,  logFile):
    logger = logging.getLogger()
    logger.setLevel(logLevel)
    formatter = logging.Formatter(logFormat)

    # Init file logging
    handler = logging.FileHandler(logFile)
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    # Init console logging
    handler2 = logging.StreamHandler()
    handler2.setFormatter(formatter)
    logger.addHandler(handler2)
    return logger


def sendMessage(message):
    message = '{"text" : "' + message + '"}'
    requests.post(webhookURL, data=message)


# init logging
logFile = '/var/log/check.log'
logFormat = '%(asctime)s - %(levelname)s - %(message)s'
logLevel = 'INFO'

# Init Logger
logger = initLogging(logFormat, logLevel, logFile)


backupPath = os.environ['TARGET_FOLDER']
archivPath = os.path.join(backupPath, 'archiv/')
reportFile = os.path.join(backupPath, 'report.txt')
webhookURL = os.environ['SLACK_WEBHOOK_URL']


# check if report file is available
if not os.path.isfile(reportFile):
    sendMessage('Backup failed. Reportfile not transferred...')
    logger.error('Backup failed. Reportfile not transferred...')
    sys.exit(1)

# check statuscode
with open(reportFile) as f:
    first_line = f.readline()
    if not "code=0" in first_line:
        sendMessage('Backup failed. Backup failed in the process. ' + first_line +' See logfile for more Information...')
        logger.error('Backup failed. Backup failed in the process. ' + first_line +' See logfile for more Information...')
        sys.exit(1)
    else:
        #move file to archiv
        timestr = time.strftime("%Y-%m-%d_%H-%M")
        os.rename(reportFile, archivPath + timestr + "-report.txt")
        sys.exit(0)
