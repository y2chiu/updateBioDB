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
    #  BindingDB 
    #
    FTPSERVER=http://www.bindingdb.org  # remote server name
    LOCALDIR=${D_OUT}
    REMOTEDIR=/bind/
    LOGFILE=${D_LOG}/log.uniprot

    if [ ! -d ${LOCALDIR} ]; then
        mkdir -p ${LOCALDIR}
    fi

    #
    #  Check version
    #

    # fetch webpage
    tmppage=${D_OUT}"/.tmp_webpage"
    curl -s http://www.bindingdb.org/bind/chemsearch/marvin/SDFdownload.jsp?all_download=yes > ${tmppage}

    version=$(cat ${tmppage} | grep "BindingDB_All_" | tail -n 1 | awk '{print $7}')
    fn_vers=${D_OUT}"/VERSION_BD_"${version}

    if [ -e ${fn_vers} ]; then
        echo "# BindingDB version: ${version} updated"
        exit 1;
    fi

    fn_wget=$(cat ${tmppage} | grep "BindingDB_All_" | tail -n 3 | cut -d'"' -f2 | cut -d'=' -f2)

    cd ${LOCALDIR}

    for f in ${fn_wget}
    do
        o=$(basename $f)
        echo " downloading $f"
        ${WGET} -O $o ${FTPSERVER}$f
    done

    for f in CID SID CHEBI_ID
    do
        fn="BindingDB_${f}.txt"
        echo " downloading $fn"
        ${WGET} -O $fn ${FTPSERVER}${REMOTEDIR}${fn}
    done
        
    # Save an empty file with update-date info as its name
    ls ${LOCALDIR}/VERSION_BD_* | xargs rm -f
    touch ${fn_vers}

fi
