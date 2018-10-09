#!/usr/bin/env bash
#testgit

cd "`dirname $0`"

[ -t 1 ] && . colors

. h-manifest.conf

[[ -z $CUSTOM_LOG_BASENAME ]] && echo -e "$0: ${RED}No CUSTOM_LOG_BASENAME is set${NOCOLOR}" && exit 1
[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "$0: ${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && exit 1
[[ ! -f $CUSTOM_CONFIG_FILENAME ]] && echo -e "$0: ${RED}Custom config ${YELLOW}$CUSTOM_CONFIG_FILENAME${RED} is not found${NOCOLOR}" && exit 1
CUSTOM_LOG_BASEDIR=`dirname "$CUSTOM_LOG_BASENAME"`
[[ ! -d $CUSTOM_LOG_BASEDIR ]] && mkdir -p $CUSTOM_LOG_BASEDIR

#Checking CUDA version
DRV_VERS=`nvidia-smi --help | head -n 1 | awk '{print $NF}' | sed 's/v//' | tr '.' ' ' | awk '{print $1}'`
echo -e "Nvidia driver version is ${BCYAN}${DRV_VERS}${NOCOLOR}"

version_dir="/hive/custom/${CUSTOM_NAME}/${CUSTOM_VERSION}"
exesuffix="EggPool-Lin/eggminer"
minerexe="${version_dir}/${exesuffix}"

miner_archive="EggPool-Lin-4092.tar.gz"
miner_url="https://github.com/EggPool/EggMinerGpu/releases/download/4.0.92/${miner_archive}"

download_n_unpack(){
   mkdir -p "${version_dir}" > /dev/null 2>&1
   if [ ! -d "${version_dir}" ]; then
      echo "${RED}Unable to create version working directory: "${version_dir}" ${NOCOLOR}"
      exit 1
   fi
   cd "${version_dir}"
   echo "Downloading $(miner_archive)..."
   rm "$exesuffix" > /dev/null 2>&1
   rm "${miner_archive}" > /dev/null 2>&1
   wget -c -t 5 "${miner_archive}" "${miner_url}"
   echo "Unpacking ${miner_archive}..."
   tar xvzf "${miner_archive}" 
   if [ $? -ne 0 ]; then
      echo "Failed to unpack miner archive from ${miner_archive}"
      exit 1
   fi
   echo Done.
   cd ..
}

if [ ! -x "$minerexe" ]; then
   echo "Miner ${miner_archive} required to download."
   download_n_unpack
fi

cd /hive/custom/${CUSTOM_NAME}/${CUSTOM_VERSION}/EggPool-Lin

"/hive/custom/${CUSTOM_NAME}/miner_run" "${minerexe}"  2>&1 | tee "${CUSTOM_LOG_BASENAME}.log"


