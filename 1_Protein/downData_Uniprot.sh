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
    #  UniProt  
    #
    FTPSERVER=ftp://ftp.uniprot.org        # remote server name
    LOCALDIR=${D_OUT}
    REMOTEDIR=/pub/databases/uniprot/current_release/knowledgebase/
    LOGFILE=${D_LOG}/log.uniprot

    if [ ! -d ${LOCALDIR} ]; then
        mkdir -p ${LOCALDIR}
    fi

    cd ${LOCALDIR}
    ${WGET} -O uniprot_sprot.fasta.gz ${FTPSERVER}/$REMOTEDIR/complete/uniprot_sprot.fasta.gz
    gunzip -df uniprot_sprot.fasta.gz
    cp uniprot_sprot.fasta uniprot_sprot.fasta.`date +%Y%m%d`
    
    ${WGET} -O uniprot_sprot.dat.gz ${FTPSERVER}/$REMOTEDIR/complete/uniprot_sprot.dat.gz
    gunzip -df uniprot_sprot.dat.gz
    
    ${WGET} -O idmapping_selected.tab.gz ${FTPSERVER}/$REMOTEDIR/idmapping/idmapping_selected.tab.gz
    #gunzip -df idmapping_selected.tab.gz

fi
