FROM phusion/baseimage:0.9.9

ENV HOME /root

# ### Generate SSH key for production usage
# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# === Some Environment Variables
ENV    DEBIAN_FRONTEND noninteractive

# === MySQL Installation
RUN apt-get update
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -y mysql-server

ADD build/my.cnf    /etc/mysql/my.cnf

RUN mkdir           /etc/service/mysql
ADD build/mysql.sh  /etc/service/mysql/run
RUN chmod +x        /etc/service/mysql/run

RUN mkdir -p        /var/lib/mysql/
RUN chmod -R 755    /var/lib/mysql/

ADD build/setup.sh  /etc/mysql/mysql_setup.sh
RUN chmod +x        /etc/mysql/mysql_setup.sh

EXPOSE 3306
# === END MySQL Installation

# === Mongodb Installation
# Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Install MongoDB
RUN apt-get update
RUN apt-get install -y mongodb-10gen
RUN mkdir -p /data/db
RUN chown -R mongodb:mongodb /data
RUN echo "bind_ip = 0.0.0.0" >> /etc/mongodb.conf

# Create a runit entry for mongo service
RUN mkdir /etc/service/mongo
ADD build/run_mongo.sh /etc/service/mongo/run
RUN chown root /etc/service/mongo/run
RUN chmod +x /etc/service/mongo/run

# Spin-docker currently supports exposing port 22 for SSH and
# one additional application port (Mongo runs on 27017)
EXPOSE 27017
# === END Mongodb Installation

# === UCARP Installation
RUN apt-get install -y ucarp
# === END UCARP Installation


# === Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/etc/mysql/mysql_setup.sh"]
