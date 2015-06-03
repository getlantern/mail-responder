# Mail Responder

A Docker image builder and config to deploy an [email auto responder](https://bitbucket.org/psiphon/psiphon-circumvention-system/src/860d7dd76509861b66895ba514ac66ab82cec332/EmailResponder?at=default)

## To build and run docker image
```
export AWS_ACCESS_KEY_ID=<key>
export AWS_SECRET_ACCESS_KEY=<secret>
cat docker/boto.cfg.tmpl | envsubst > docker/boto.cfg
docker build -t mail-responder docker/
rm docker/boto.cfg
docker run mail-responder 
```

## To update response mail address and content
```
s3cmd put setacl --acl-public conf.json s3://mail_responder/conf.json
```
