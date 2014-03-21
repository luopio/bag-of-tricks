#!/bin/bash
USERNAME=lauri
SERVER=dev.citat.fi
SERVER_TUNNEL_PORT=2203

sudo -u pi ssh -nNT -R $SERVER_TUNNEL_PORT:localhost:22 $USERNAME@$SERVER 
