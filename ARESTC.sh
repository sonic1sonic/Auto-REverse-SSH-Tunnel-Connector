#!/bin/bash

# Program:
#	Program establishes a connection to gateway through reverse SSH tunnel on your server.
# History:
# 2017/03/03	Raul	First release

###################################
#### Create Your Own Parameter ####
###################################
RSA_KEY_FILENAME="id_rsa"         #
###################################
SSH_PORT="9876"                   #
SERVER_IP="xxx.xxx.xxx.xx"        #
SERVER_USERNAME="xxxxxxx"         #
###################################
REVERSE_SSH_TUNNEL_PORT="9140"    #
GATEWAY_USERNAME="xxxxxxx"        #
###################################

path=$(find /home -user $USER -name $RSA_KEY_FILENAME -print -quit 2>/dev/null)

if [[  $path == *$RSA_KEY_FILENAME* ]]; then
	echo "found $RSA_KEY_FILENAME in $path"	
else
	echo -e "\e[1m\e[41m$RSA_KEY_FILENAME not found... Try put it in $PWD\e[0m"
	exit
fi

status=$(ssh -i $path -p $SSH_PORT $SERVER_USERNAME@$SERVER_IP "netstat -nap | grep \":$REVERSE_SSH_TUNNEL_PORT\"")
if [[ -n "$status" ]]; then
	clear
	echo -e "\e[1m\e[5m\e[93mGateway is online, now logging...\e[0m"
	ssh -t -i $path -p $SSH_PORT $SERVER_USERNAME@$SERVER_IP "ssh -p $REVERSE_SSH_TUNNEL_PORT $GATEWAY_USERNAME@localhost"
else
	echo "Gateway is offline, please check..."
fi


