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
    #  CATH
    #
    FTPSERVER=ftp://ftp.biochem.ucl.ac.uk/        # remote server name
    LOCALDIR=${D_OUT}
    REMOTEDIR=/pub/cath/latest_release/
    LOGFILE=${D_LOG}/log.cath

    if [ ! -d ${LOCALDIR} ]; then
        mkdir -p ${LOCALDIR}
    fi

    ${LFTP} -c "open ${FTPSERVER};lcd ${LOCALDIR};cd ${REMOTEDIR};mirror;" >${LOGFILE} 2>&1

    # Save an empty file with update-date info as its name
    find ${LOCALDIR} -type f -name 'VERSION_CATH_*' -delete
    touch ${LOCALDIR}/VERSION_CATH_`date +%Y%m%d`
fi

