#!/usr/bin/env bash

cd "`dirname $0`"

. colors

. h-manifest.conf

[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && exit 1
[[ ! -f $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}Custom config ${YELLOW}$CUSTOM_CONFIG_FILENAME${RED} is not found${NOCOLOR}" && exit 1
CUSTOM_LOG_BASEDIR=`dirname "$CUSTOM_LOG_BASENAME"`
[[ ! -d $CUSTOM_LOG_BASEDIR ]] && mkdir -p $CUSTOM_LOG_BASEDIR


version_dir="/hive/custom/${CUSTOM_NAME}/${CUSTOM_VERSION}"

#Checking CUDA version
DRV_VERS=`nvidia-smi --help | head -n 1 | awk '{print $NF}' | sed 's/v//' | tr '.' ' ' | awk '{print $1}'`
echo "Driver version is ${BCYAN}${DRV_VERS}${NOCOLOR}"

if [ ${DRV_VERS} -ge 396 ]; then
   cudaver="9.2"
   exesuffix="zjazz_cuda${cudaver}_linux/zjazz_cuda"
   echo -e "(${BCYAN}CUDA ${cudaver}${NOCOLOR} compatible)"
   minerexe="${version_dir}/${exesuffix}"
else
   cudaver="9.1"
   exesuffix="zjazz_cuda${cudaver}_linux/zjazz_cuda"
   echo -e "(${BCYAN}CUDA ${cudaver}${NOCOLOR} compatible)"
   minerexe="${version_dir}/${exesuffix}"
fi

miner_archive="zjazz_cuda${cudaver}_linux_suqa_0.991.tar.gz"
miner_url="https://github.com/zjazz/zjazz_cuda_miner_experimental/releases/download/x22i_0991/${miner_archive}"

download_n_unpack(){
   mkdir -p "${version_dir}" > /dev/null 2>&1
   if [ ! -d "${version_dir}" ]; then
      echo "Unable to create version working directory: ${version_dir}"
      exit 1
   fi

   cd "${version_dir}"
   echo "Downloading ${miner_archive}..."
   rm "$exesuffix" > /dev/null 2>&1
   wget -c -t 1 "${miner_url}"
   if [ $? -ne 0 ]; then
      echo "Failed to download miner from ${miner_url}"
      exit 1
   fi
   echo Done.
   echo "Unpacking ${miner_archive}..."
   tar xvzf "${miner_archive}" "${exesuffix}"
   if [ $? -ne 0 ]; then
      echo "Failed to unpack miner archive from ${miner_archive}"
      exit 1
   fi
   echo Done.
   cd ..
}

if [ ! -x "${minerexe}" ]; then
   echo "Miner ${miner_archive} required to download."
   download_n_unpack
fi

   ./zjazz_cuda_run "${minerexe}" $(< $CUSTOM_CONFIG_FILENAME) -L "${CUSTOM_CONFIG_FILENAME}" $@

