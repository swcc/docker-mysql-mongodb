#!/usr/bin/env sh

# If mysql db directory is empty
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  
  /usr/bin/mysql_install_db

  /usr/bin/mysqld_safe > /dev/null 2>&1 &
  /bin/sleep 2s

  /usr/bin/mysqladmin -u root password 'root'
  /usr/bin/mysqladmin -u root password 'root'
  
  /usr/bin/killall mysqld
  /bin/sleep 2s

fi

# Start Mysql
/usr/bin/mysqld_safe > /dev/null 2>&1 &
/bin/sleep 2s

# Create Database
mysql -uroot -proot -e "CREATE DATABASE a_database"

# Create (unsafe) HelpSpot user, who can connect remotely
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* to 'a_user'@'%' IDENTIFIED BY 'a_password';"

# Shutdown MySQL
mysqladmin -uroot -proot shutdown

/sbin/my_init
