#!/usr/bin/env bash
# This code is included in /hive/bin/custom function

echo $* > $0.log
set >> $0.log

[[ -z $CUSTOM_TEMPLATE ]] && echo -e "${YELLOW}CUSTOM_TEMPLATE is empty${NOCOLOR}" && return 1
[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1

(
   if [ -r "${CUSTOM_CONFIG_FILENAME}" ]; then
      cat "${CUSTOM_CONFIG_FILENAME}"
   fi
   if [ -r "${CUSTOM_LOG_BASENAME}.log" ]; then
      cat "${CUSTOM_LOG_BASENAME}.log"
   fi
) |
   grep batch_size |
   sed -r 's/^.+batch_size_/batch_size_/g' |
   sed -r 's/^.*batch_size_//g' |
   awk '{gputunes[$1]=$3} END{for(gpu in gputunes){print "batch_size_"gpu" = "gputunes[gpu]}}' > /tmp/tunes.$$
(
   echo "address = \"${CUSTOM_TEMPLATE}\"" 
   cat /tmp/tunes.$$
   rm /tmp/tunes.$$
)  > ${CUSTOM_CONFIG_FILENAME}

   (echo "damping = 95" ; printf "${CUSTOM_USER_CONFIG}\n") | grep damping | tail -1 >> ${CUSTOM_CONFIG_FILENAME}
   (echo "intensity = [100,100,100,100,100,100,100,100]" ; printf "${CUSTOM_USER_CONFIG}\n") | grep intensity | tail -1 >> ${CUSTOM_CONFIG_FILENAME}


