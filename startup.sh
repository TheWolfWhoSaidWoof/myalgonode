#!/bin/bash
[ $DEBUG='true' ] && set -x
./goal node start -d data -l 0.0.0.0:8080
 
./goal node status 
sleep 10
./goal node status 

#todo confirm this works when mid catchup last 1000 blocks.
#is a catchup required
CATCHUPREQ=FALSE
CURCATCH=$( ./goal node status | grep 'Catchpoint:' | cut -d':' -f2| cut -d'#' -f1 | tr -d ' ' )
LATCATCH=$( curl -s https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/${ALGORAND_NETWORK}/latest.catchpoint | cut -d'#' -f1 )
[ $DEBUG='true' ] && echo " Latest catchup $LATCATCH on ${ALGORAN_NETWORK}. Node is currently on ${CURCATCH}"
if [[ -z "${CURCATCH}" ]] ; then
# no current catchup in place find out what the latest catch is
# find the current latest block
CURCATCH=$( ./goal node status | grep 'Last committed block:' | cut -d':' -f2 )

[ $DEBUG='true' ] && echo "no catchup in progress, last commmited block $CURCATCH"
fi

if [[ $(( ${LATCATCH} - ${CURCATCH} )) -gt 20000 ]] ; then
#more than 10000 block behind do a catchup

  CATCHUPREQ=TRUE
fi

[ $DEBUG='true' ] && echo "Catchup required? $CATCHUPREQ"

if [[ "${CATCHUPREQ}" == "TRUE" ]] ; then

./goal node catchup $( curl -s https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/${ALGORAND_NETWORK}/latest.catchpoint ) -d data
fi
tail -f /root/node/data/algod-out.log /root/node/data/algod-err.log
