#!/usr/bin/env bash

cd `dirname $0`

[ -t 1 ] && . colors
. h-manifest.conf

#[[ -z $CUSTOM_ALGO ]] && echo -e "${YELLOW}CUSTOM_ALGO is empty${NOCOLOR}" && return 1
#[[ -z $CUSTOM_TEMPLATE ]] && echo -e "${YELLOW}CUSTOM_TEMPLATE is empty${NOCOLOR}" && return 1
#[[ -z $CUSTOM_URL ]] && echo -e "${YELLOW}CUSTOM_URL is empty${NOCOLOR}" && return 1
[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1
[[ ! -f $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No $CUSTOM_CONFIG_FILENAME is found${NOCOLOR}" && return 1

DRV_VERS=`nvidia-smi --help | head -n 1 | awk '{print $NF}' | sed 's/v//' | tr '.' ' ' | awk '{print $1}'`

#echo $DRV_VERS

echo -e -n "${GREEN}NVidia${NOCOLOR} driver ${GREEN}${DRV_VERS}${NOCOLOR}-series detected "
if [ ${DRV_VERS} -ge 396 ]; then
   echo -e "(${BCYAN}CUDA 9.2${NOCOLOR} compatible)"
   ./zjazz_cuda_v.0.991_cuda9.2 -c ${CUSTOM_CONFIG_FILENAME}
else
   echo -e "(${BCYAN}CUDA 9.1${NOCOLOR} compatible)"
   ./zjazz_cuda_v.0.991_cuda9.1 -c ${CUSTOM_CONFIG_FILENAME}
fi

