#!/usr/bin/env bash
# This code is included in /hive/bin/custom function

[[ -z $CUSTOM_TEMPLATE ]] && echo -e "${YELLOW}CUSTOM_TEMPLATE is empty${NOCOLOR}" && return 1
[[ -z $CUSTOM_URL ]] && echo -e "${YELLOW}CUSTOM_URL is empty${NOCOLOR}" && return 1


[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1


conf="-o ${CUSTOM_URL} -u ${CUSTOM_TEMPLATE} -p ${CUSTOM_PASS} ${CUSTOM_USER_CONFIG}"


echo "address = ${CUSTOM_TEMPLATE}" > $CUSTOM_CONFIG_FILENAME
echo "damping = 95" >> $CUSTOM_CONFIG_FILENAME
echo "intensity = [100,100,100,100,100,100,100,100]" >> $CUSTOM_CONFIG_FILENAME



