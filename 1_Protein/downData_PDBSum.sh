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
    #  PDBSum
    #
    FTPSERVER=http://www.ebi.ac.uk  # remote server name
    LOCALDIR=${D_OUT}
    REMOTEDIR=/thornton-srv/databases/pdbsum/data/
    LOGFILE=${D_LOG}/log.pdbsum


    if [ ! -d ${LOCALDIR} ]; then
        mkdir -p ${LOCALDIR}
    fi

    cd ${LOCALDIR}
    for f in protnames.lst pdblib.fasta seqdata.dat pdb_EC het2pdb.lst het_pairs.lst lig2pdb.lst lig_pairs.lst   
    do
        echo " > downloading ${f} ..."

        # "//" would cause problem in http URL
        ${WGET} -O $f ${FTPSERVER}${REMOTEDIR}$f 
    done
fi
