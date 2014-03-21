#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "ERROR: Missing arguments!!"
	echo "USAGE: $0 path_to_store"
	exit 1
elif [ ! -d $1 ] ; then 
	echo "ERROR: No such directory!!"
	echo "USAGE: $0 path_to_store"
	exit 1
else

    D_PROG=$(dirname $(readlink -f $0))
    D_WORK=$(dirname $(readlink -f $1))
    D_OUT=$(readlink -f $1)
    
    D_LOG=${D_WORK}"/.log"
    if [ ! -d ${D_LOG} ]; then
        mkdir -p ${D_LOG}
    fi

    WGET="wget -o /dev/null"
    LFTP="lftp"

    #
    #  Additional RCSB PDB FTP services
    #
    FTPSERVER=ftp://resources.rcsb.org/        # remote server name
    LOCALDIR=${D_OUT}
    REMOTEDIR=/sequence/clusters/
    LOGFILE=${D_LOG}/log.pdb-cluster

    if [ ! -d ${LOCALDIR} ]; then
        mkdir -p ${LOCALDIR}
    fi
    ${LFTP} -c "open ${FTPSERVER};lcd ${LOCALDIR};cd ${REMOTEDIR};mirror;" >${LOGFILE} 2>&1
    #${LFTP} -c "open ${FTPSERVER};lcd ${LOCALDIR};cd ${REMOTEDIR};mirror --delete;" >${LOGFILE} 2>&1

fi
