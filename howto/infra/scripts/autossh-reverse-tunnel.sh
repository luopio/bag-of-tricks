#!/bin/bash
USERNAME=lauri
SERVER=dev.citat.fi
SERVER_TUNNEL_PORT=2204

AUTOSSH_DEBUG=1 sudo -u pi autossh -nNT -R $SERVER_TUNNEL_PORT:localhost:22 $USERNAME@$SERVER 
