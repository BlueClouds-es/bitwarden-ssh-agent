#!/usr/bin/env bash
rm ${SSH_AUTH_SOCK} ${SSH_AUTH_PROXY_SOCK} > /dev/null 2>&1
socat UNIX-LISTEN:${SSH_AUTH_PROXY_SOCK},perm=0666,fork UNIX-CONNECT:${SSH_AUTH_SOCK} & > /dev/null 2>&1

if [ ! -d "/home/ssh-agent/.config/Bitwarden CLI/" ]
then
	if [[ "$BW_CLIENTID" == "" && "$BW_CLIENTSECRET" == "" ]]
	then
		bw login --apikey
	fi
else
	bw login
fi

./bw_add_sshkeys.py

exec /usr/bin/ssh-agent -a ${SSH_AUTH_SOCK} -d
