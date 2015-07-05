#! /bin/bash
cat docker/boto.cfg.tmpl | envsubst > docker/boto.cfg
[ -f docker/dkim.key ] || cp ../too-many-secrets/mail-responder/dkim.key docker/dkim.key
docker build -t mail-responder docker/
