#! /bin/bash
mysql_install_db --user=mysql -ldata=/data
service mysql start
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS responder; GRANT ALL ON responder.* TO 'responder'@'localhost' IDENTIFIED BY 'responder';"
service rsyslog start
service postfix start
# (cd psiphon-circumvention-system/EmailResponder && sh ./install.sh)
/bin/bash -c "cron -f" > /var/log/cron.log 2>&1 &
/bin/bash
