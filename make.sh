cat docker/boto.cfg.tmpl | envsubst > docker/boto.cfg
if [ ! -z docker/dkim.key ]; then
    cp ../too-many-secrets/mail-responder/dkim.key docker/dkim.key
fi
docker build -t mail-responder docker/
