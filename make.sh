cat docker/boto.cfg.tmpl | envsubst > docker/boto.cfg
docker build -t mail-responder docker/
rm docker/boto.cfg
