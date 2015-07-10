# Mail Responder

A Docker image builder and config to deploy a [Psiphon email auto responder](https://bitbucket.org/psiphon/psiphon-circumvention-system/src/860d7dd76509861b66895ba514ac66ab82cec332/EmailResponder?at=default)

## To build and run docker image
```
wget -qO- https://get.docker.com/ | sh
export AWS_ACCESS_KEY_ID=<key>
export AWS_SECRET_ACCESS_KEY=<secret>
./make.sh
./restart.sh
```

## To update response mail address and content
```
s3cmd put setacl --acl-public conf.json s3://mail_responder/conf.json
```

### If you want it to take effect immediately, login to each server running docker image and update config manually.
```
docker exec -ti mail-responder /bin/bash
> sudo -u mail_responder /usr/bin/env python ~mail_responder/conf_pull.py # default is to run daily
```

## To inspect logs
```
docker exec -ti mail-responder /bin/bash
> tail -f /var/log/mail-responder.log
> mysql responder
```

### A few SQL may helpful

```
# mail process time in last day
select addr, from_unixtime(processing_start/1000), from_unixtime(processing_end/1000), (processing_end-processing_start)/1000 from incoming_mail where created > UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 1 day))*1000 order by created;
# mail defered to send and the reason
select addr, from_unixtime(created/1000), defer_count, defer_last_reason from outgoing_mail where created > UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 1 day))*1000 order by created;
```

## DNS settings
1. An A record pointing to the server running docker image, you can point to more servers for DNS round robin.
2. A TXT record for DKIM, ref [Psiphon email auto responder documentation](https://bitbucket.org/psiphon/psiphon-circumvention-system/src/860d7dd76509861b66895ba514ac66ab82cec332/EmailResponder?at=default).
3. A MX record pointing to the domain in step 1.
4. A TXT record for the MX record of step 3, with content as follows: `v=spf a:<the domain name in step 1> ~all`. If the TXT record already exists, just append to it.

## Load testing

Refer part 2 of [this article](http://www.tothenew.com/blog/load-testing-an-smtp-application-using-jmeter-postal/) to create SMTP Samplers using as many mail addresses as possible (Gmail, Yahoo, Outlook, etc), set the "Address To" to the address of auto responder, and properly set thread count and interval to prevent mail provider from drop the requests.

It requires 3-5 seconds to process one mail on a $5 DO instance, which means 720+ mail per hour for one server.
