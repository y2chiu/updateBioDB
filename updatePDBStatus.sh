
if [ $# -ne 2 ] ; then
	echo "ERROR: Missing arguments!!"
	echo "USAGE: $0 path_to_mirror path_to_store"
	exit 1
else
    dir_MIRROR=$1
    dir_DATA=$2

    dir_STATUS=${dir_MIRROR}"/data/status/"
    file_SEQRES=${dir_MIRROR}"/derived_data/pdb_seqres.txt"

    list_PDB=${dir_DATA}'/pdb.id'
    list_PIDA=${dir_DATA}'/pdb.idch.all'
    list_PIDP=${dir_DATA}'/pdb.idch.pro'
    list_PIDN=${dir_DATA}'/pdb.idch.na'
    file_PSEQ=${dir_DATA}'/pdb.seqres'

    pdbVersion=`find ${dir_STATUS} -type d | sort -n | tail -1`
    pdbVersion=`basename ${pdbVersion}`
    echo "PDB Version: "${pdbVersion}

    # Save an empty file with PDB Version info as its name
    find ${dir_DATA} -type f -name 'VERSION_PDB_*' -delete
    touch ${dir_DATA}/VERSION_PDB_${pdbVersion}

    cp ${file_SEQRES} ${file_PSEQ}

    # update pdb id with chain list
    cat ${file_PSEQ} | grep ^">" | cut -d ' ' -f 1 | sed 's#[>_]##g' | sort > ${list_PIDA}
    cat ${file_PSEQ} | grep ^">" | grep "mol:protein"    | cut -d ' ' -f 1 | sed 's#[>_]##g' | sort > ${list_PIDP}
    cat ${file_PSEQ} | grep ^">" | grep "mol:protein" -v | cut -d ' ' -f 1 | sed 's#[>_]##g' | sort > ${list_PIDN}

    cat ${list_PIDA} | cut -b 1-4 | sort -u > ${list_PDB}

fi
