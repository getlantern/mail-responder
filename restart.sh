#! /bin/bash

echo "Removing existing container..."
docker rm -f mail-responder
echo "Starting..."
docker run --restart=always -dtip 25:25 -v `pwd`/data:/data --name=mail-responder -h `hostname` mail-responder
