#!/usr/bin/env bash
HERE=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source ${HERE}/../ovh-api-lib.sh || exit 1

OvhRequestApi "/me"

if [ "${OVHAPI_HTTP_STATUS}" != "200" ]; then
  echo "profile error:"
  echo "${OVHAPI_HTTP_RESPONSE}"
  exit
fi

OvhRequestApi "/domain"

if [ "${OVHAPI_HTTP_STATUS}" -eq 200 ]; then
   domains=($(getJSONValues "${OVHAPI_HTTP_RESPONSE}"))
   echo "number of domains=${#domains[@]}"

   # for example, only list for first domain
   #for domain in "${domains[@]}"
   for domain in "${domains[0]}"
   do
     echo -e "\n== informations about ${domain} =="
     OvhRequestApi "/domain/${domain}"
     echo "-- single value --"
     # key can be passed with/without double quote
     getJSONValue "${OVHAPI_HTTP_RESPONSE}" lastUpdate
     getJSONValue "${OVHAPI_HTTP_RESPONSE}" '"transferLockStatus"'
     echo "-- get all values --"
     getJSONValues "${OVHAPI_HTTP_RESPONSE}"
   done
fi
