# Postfix Docker Image for Relay Domains

Starts a container who can receive's rsync connections to transfer data.

## Build image
```sh
git clone https://github.com/guitarmarx/rsync-receiver.git
cd postfix-image
docker build -t <imagename:version> .
```
## Usage

```sh
docker run -d  \
    -p <port>:22 \
    -e SSH_KEY=<sender ssh public key> \
    -v <your path>:/srv/backup \
    <imagename>:<version>
```

# Configuration

Parameter | Function| Default Value|
---|---|---|
SSH_USER | ssh user for sync process | rsync
SSH_KEY | (required) public sender ssh key |
SLACK_WEBHOOK_URL | (required) slack url for notifactions | postfix
