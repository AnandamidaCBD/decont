# This script should index the genome file specified in the first argument ($1),
# creating the index in a directory specified by the second argument ($2).

# The STAR command is provided for you. You should replace the parts surrounded
# by "<>" and uncomment it.



genomefile=$1
out_direct=$2


mkdir -p res/contaminants_idx

STAR \
    --runThreadN 8 \
    --runMode genomeGenerate \
    --genomeDir $out_direct \
    --genomeFastaFiles $genomefile \
    --genomeSAindexNbases 9
