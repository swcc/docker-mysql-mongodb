#!/bin/sh
# Use the exec command to start the app you want to run in this container.
# Don't let the app daemonize itself.

# `/sbin/setuser memcache` runs the given command as the user `memcache`.
# If you omit that part, the command will be run as root.

# Read more here: https://github.com/phusion/baseimage-docker#adding-additional-daemons
exec /sbin/setuser mongodb /usr/bin/mongod
