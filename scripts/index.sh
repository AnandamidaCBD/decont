# Definir variables

genomefile=$1
out_direct=$2


mkdir -p res/contaminants_idx

# Introducir como variable el archivo de lectura y el directorio de salida


STAR \
    --runThreadN 8 \
    --runMode genomeGenerate \
    --genomeDir $out_direct \
    --genomeFastaFiles $genomefile \
    --genomeSAindexNbases 9
