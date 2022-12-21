# Definir Variables

download_file=$1
sampleid=$(basename $1)
out_directory=$2
sampleid_filtrada=$(basename $sampleid .gz)

##if [ -e $out_directory/$sampleid ] # Tengo las muestras ya descargadas en el directorio?
##then
##	echo '##### El archivo ya se encuentra descargado ! #####'
##	exit 0
##fi

# Descargar Secuencias ARN y genoma de referencia
wget -P $2 $1
echo '##### Descarga de las secuencias completada satisfactoriamente ! #####'
echo '##### Descarga del genoma de referencia completada satisfactoriamente ! #####'

##if [ -e $out_directory/sec_fastq/$sampleid ]
##then
##	echo '##### La secuencia ya se encuentra descomprimida ! #####'
##	exit 0
##fi

# Descomprimir secuencias ARN
gunzip -k  data/*.fastq.gz
echo '##### Archivos.fastq de las secuencias descomprimidos satisfactoriamente ! #####'

# Ordenar secuencias.fastq
mkdir -p data/sec_fastq
mv data/*.fastq data/sec_fastq

##if [ -e $out_directory/$sampleid ]
##then
##	echo '##### El genoma de referencia ya se encuentra descomprimido ! #####'
##	exit 0
##fi

# Llamar al script descarga con un tercer argumento=SI para descomprimir el genoma de referencia
if [ "$3" == "yes" ]
then
	gunzip -k $out_directory/$sampleid
fi
echo '##### Archivo.fasta del genoma descomprimido satisfactoriamente ! #####'

##if [ -e $out_directory/${sampleid_filtrada}_* ]
##then
##	echo '##### El genoma ya se encuentra filtrado ! #####'
##	exit 0
##fi

# Si se llama al script con un ultimo argumento con la palabra filtrar, se eliminara las secuencias pequeñas de ARN nuclear
# y se guardara en el directorio resources como contaminantes_limpia
if [ "$4" == "filtrar" ]
then
	seqkit grep -v -r -p  ".*small nuclear.*" -n $out_directory/$sampleid > $out_directory/$sampleid_filtrada
fi
echo '###### Filtrado del genoma finalizado satisfactoriamente! #####'

