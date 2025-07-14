#!/bin/bash

# Define ip address file's path

IP_FILE="./ip.list"

# Genrate sshkey

expect <<EOF
spawn ssh-keygen -t rsa
expect "(/root/.ssh/id_rsa):" {send "\r"; exp_continue}
expect "(y/n)?" {send "y\r"; exp_continue}
expect "(empty for no passphrase):" {send "\r"; exp_continue}
expect "again:" {send "\r";}
expect "#" {send exit}
EOF

# Copy sshkey to another host and local host
cat $IP_FILE | grep -v '^$' | while read line
do
    ipaddr=`echo "$line" | awk -F"," {'print $1'}`
    port=`echo "$line" | awk -F"," {'print $2'}`
    user=`echo "$line" | awk -F"," {'print $3'}`
    password=`echo "$line" | awk -F"," {'print $4'}`


expect <<EOF
spawn ssh-copy-id -f -p $port $user@$ipaddr

# expect "(yes/no)" {send "yes\r"; exp_continue}

expect "password:" {send "$password\r";}
expect "#" {send exit}
EOF

done
