# Mail Responder

A Docker image builder and config to deploy a [Psiphon email auto responder](https://bitbucket.org/psiphon/psiphon-circumvention-system/src/860d7dd76509861b66895ba514ac66ab82cec332/EmailResponder?at=default)

## To build and run docker image
```
export AWS_ACCESS_KEY_ID=<key>
export AWS_SECRET_ACCESS_KEY=<secret>
./make.sh
docker run --restart=always -dtip 25:25 --name=mail-responder mail-responder
```

## To update response mail address and content
```
s3cmd put setacl --acl-public conf.json s3://mail_responder/conf.json
```

### If you want it to take effect immediately, login to the server running docker image and update config manually.
```
docker exec -ti mail-responder /bin/bash
> sudo -u mail_responder /usr/bin/env python ~mail_responder/conf_pull.py # default is to run daily
```

## To inspect logs
```
docker exec -ti mail-responder /bin/bash
> tail -f /var/log/syslog
```

## DNS settings
1. An A record pointing to the server running docker image
2. An TXT record for DKIM, ref [Psiphon email auto responder documentation](https://bitbucket.org/psiphon/psiphon-circumvention-system/src/860d7dd76509861b66895ba514ac66ab82cec332/EmailResponder?at=default).
3. An MX record pointing to the domain in step 1 (you can point more than one domain to the same server)
4. An TXT record for each records of step 3, with content as follows: `v=spf a:<the domain name in step 1> ~all`. If the TXT record already exists, just append to it.
