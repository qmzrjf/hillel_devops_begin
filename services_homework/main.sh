#!/bin/bash
declare -A GENERAL_CONFIG
declare -A CONFIG

CONFIG["port"]=8081
CONFIG["log_path"]="/var/log/nginx/access8081.log"
string=$(declare -p CONFIG)
GENERAL_CONFIG["1"]=${string}

CONFIG["port"]=8082
CONFIG["log_path"]="/var/log/nginx/access8082.log"
string=$(declare -p CONFIG)
GENERAL_CONFIG["2"]=${string}

for KEY in "${!GENERAL_CONFIG[@]}"; do 
   eval "${GENERAL_CONFIG["$KEY"]}"
   export PORT="${CONFIG["port"]}"
   export LOG_PATH="${CONFIG["log_path"]}"
   envsubst '${PORT} ${LOG_PATH}' < nginx-default-hw.conf > /etc/nginx-port${PORT}.conf
   envsubst '${PORT}' < nginx-port-example.service > /etc/systemd/system/nginx-port${PORT}.service
   systemctl enable nginx-port${PORT}.service
   systemctl start nginx-port${PORT}.service
done

