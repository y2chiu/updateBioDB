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
    #  SCOP
    #
    FTPSERVER=http://scop.berkeley.edu # remote server name
    LOCALDIR=${D_OUT}
    REMOTEDIR=/downloads/parse/
    LOGFILE=${D_LOG}/log.scop

    if [ ! -d ${LOCALDIR} ]; then
        mkdir -p ${LOCALDIR}
    fi

    # TODO: auto get lastest version
    cd ${LOCALDIR}
    for f in des cla hie com
    do 
        fn=dir.${f}.scope.2.03-stable.txt
        ${WGET} -O $fn dir.${f}.scope.txt ${FTPSERVER}/${REMOTEDIR}/$fn
    done

    #touch ${D_WORK}/VERSION_DB-SCOP_2.03
fi

