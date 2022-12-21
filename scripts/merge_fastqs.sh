# Definir las variables

data=$1		# Directorio de entrada de datos a juntar
out_merged=$2	# Directorio de salida  merge en out/
sampleid=$3	# Conjunto de muestras a juntar o unir

cat $data/${sampleid}-*.fastq.gz > $out_merged/${sampleid}.fastq.gz
