FROM ubuntu:trusty

RUN apt-get -y update && apt-get install -y openssh-server ntp fail2ban postfix logwatch build-essential mercurial python-pip mysql-server python-mysqldb python-sqlalchemy supervisor
RUN pip install --upgrade python-dateutil python-crontab boto dnspython
RUN pip install --allow-external pydkim --allow-unverified pydkim pydkim

RUN hg clone https://bitbucket.org/psiphon/psiphon-circumvention-system

#RUN /etc/ssh/sshd_config
#RUN /etc/fail2ban/jail.local
#RUN /etc/fail2ban/filter.d/sshd.conf
#RUN service ssh restart && service fail2ban restart

RUN useradd -s /usr/sbin/nologin mail_responder && mkdir /home/mail_responder && chown mail_responder:mail_responder /home/mail_responder
RUN useradd -s /usr/sbin/nologin forwarder && mkdir /home/forwarder && chown forwarder:forwarder /home/forwarder && sudo -uforwarder sh -c 'echo "manoto@firetweet.io" > /home/forwarder/.forward'
RUN useradd ubuntu # as normal user on this host, required by postfix
RUN echo postmaster: ubuntu root: ubuntu support: forwarder@localhost > /etc/aliases && newaliases
RUN mkdir -p /etc/ssl/private && chmod 710 /etc/ssl/private && openssl dhparam -out /etc/ssl/private/dhparams.pem 2048 && chmod 600 /etc/ssl/private/dhparams.pem
RUN mkdir -p /var/run/sshd

RUN wget -O postfix-logwatch-1.40.03.tgz "http://downloads.sourceforge.net/project/logreporters/postfix-logwatch/release/1.40.03/postfix-logwatch-1.40.03.tgz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flogreporters%2Ffiles%2Fpostfix-logwatch%2Frelease%2F1.40.03%2F&ts=1433163910&use_mirror=softlayer-ams"
RUN tar -xvf postfix-logwatch-1.40.03.tgz
RUN (cd postfix-logwatch-1.40.03 && make install-logwatch)

RUN service mysql start && mysql -uroot -e "CREATE USER 'responder'@'localhost' IDENTIFIED BY 'responder'; CREATE DATABASE responder; GRANT ALL ON responder.* TO 'responder'@'localhost';" && sleep 1 && mysqladmin -u root shutdown
RUN touch /home/mail_responder/postfix_address_maps /home/mail_responder/postfix_responder_domains

COPY main.cf /etc/postfix/main.cf
RUN sed -i "s/^bounce/#bounce/" /etc/postfix/master.cf
RUN echo 127.0.0.1:2525 inet n - - - - smtpd -o smtpd_tls_security_level=none >> /etc/postfix/master.cf
COPY boto.cfg /etc/boto.cfg
RUN chown mail_responder:mail_responder /etc/boto.cfg
COPY firetweet_io.ca-bundle STAR_firetweet_io.* /etc/postfix/
COPY dkim.key /home/mail_responder/dkim.key
COPY settings.py psiphon-circumvention-system/EmailResponder/settings.py

COPY run.sh /
COPY rsyslog.conf /etc/rsyslog.conf
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 25
ENTRYPOINT ["/run.sh"]
