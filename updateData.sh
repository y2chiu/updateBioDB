#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "ERROR: Missing arguments!!"
	echo "USAGE: $0 path_to_store"
	exit 1
else

    D_PROG=$(dirname $(readlink -f $0))
    D_WORK=$(readlink -f $1)
    D_PROT="1_Protein"
    D_COMP="2_Compound"

    WGET="wget -o /dev/null"
    LFTP="lftp"

    # check store directories
    for d in PDB clusters PDBSum SIFTS Uniprot SCOPe CATH 
    do
        do=${D_WORK}/${D_PROT}/$d
        if [ ! -d ${do} ]; then
            echo "# create ${do}"
            mkdir -p ${do}
        fi
    done

    # update PDB sequence
    DIR_MIRROR='/data/public/mirror/pdb/'
    echo '#update PDB SEQ and list'
    bash ${D_PROG}/updatePDBStatus.sh ${DIR_MIRROR} ${D_WORK}/${D_PROT}/PDB


    # Additional RCSB PDB FTP services
    echo "# download PDB-cluster"
    bash ${D_PROG}/downData_PDB-cluster.sh ${D_WORK}/${D_PROT}/clusters/
    
    # PDBSum
    echo "# download PDBSum"
    bash ${D_PROG}/downData_PDBSum.sh ${D_WORK}/${D_PROT}/PDBSum/

    # EBI SIFTS
    echo "# download EBI SIFTS"
    bash ${D_PROG}/downData_EBI-SIFTS.sh ${D_WORK}/${D_PROT}/SIFTS/
    
    # UniProt  
    echo "# download UniProt"
    bash ${D_PROG}/downData_Uniprot.sh ${D_WORK}/${D_PROT}/Uniprot/

    # SCOP
    echo "# download SCOP"
    bash ${D_PROG}/downData_SCOP.sh ${D_WORK}/${D_PROT}/SCOPe/

    # CATH
    echo "# download CATH"
    bash ${D_PROG}/downData_CATH.sh ${D_WORK}/${D_PROT}/CATH/


    # Save an empty file with update-date info as its name
    find ${D_WORK} -type f -name 'VERSION_DB_*' -delete
    touch ${D_WORK}/VERSION_DB_`date +%Y%m%d`
fi
