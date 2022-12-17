wget -i ~/decont/data/urls -P ~/decont/data 

## C57BL_6NJ-12.5dpp.1.2s_sRNA.fastq.gz SPRET_EiJ-12.5dpp.1.1s_sRNA.fastq.gz 
	#-O  Para renombrar el archivo y cambiar ubicacion
	#-i Para obtener los archivos almacenados en un fichero texto
	#-P Fijar el directorio en donde se guardaran los ficheros

##Descargar genoma en resoruces  desde
# https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz


wget -P ~/decont/res https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz

#This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
# and *optionally*:
# - uncompress the downloaded file with gunzip if the third
#   argument ($3) contains the word "yes"
# - filter the sequences based on a word contained in their header lines:
#   sequences containing the specified word in their header should be **excluded**
#
gunzip -k  ~/decont/data/*.fastq.gz
mkdir -p ~/decont/data/descomprimidos
mv data/*.fastq data/descomprimidos

gunzip -k ~/decont/res/contaminants.fasta.gz

grep "small nuclear" ~decont/res/contaminants.fasta.gz > first_line

# Example of the desired filtering:
#
#   > this is my sequence
#   CACTATGGGAGGACATTATAC
#   > this is my second sequence
#   CACTATGGGAGGGAGAGGAGA
#   > this is another sequence
#   CCAGGATTTACAGACTTTAAA
#
#   If $4 == "another" only the **first two sequence** should be output
