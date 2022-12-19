CI_JOB_STARTED_AT=$date

echo "#####################################################################################"
echo "#####################################################################################"
echo "##### Iniciando script depurado de muestras de raton de secuenciacion de RNA ########"
echo "#####################################################################################"
echo "##### C.Borja Romero Domínguez ##### srcit comenzado a las : $CI_JOB_STARTED_AT #####"
echo "#####################################################################################"
echo "#####################################################################################"


echo "##### Descargando las secuencias de ARN archivo.fastq.gz ##### "
echo "##### descomprimiendo secuencias fastq #####"

for url in $(cat data/urls)
do
    bash scripts/download.sh $url data/
done

echo



echo "##### Descargando el genoma de referencia archivo.fasta.gz #####"
echo "##### Descompriendo el genoma .fasta #####"
echo "##### Filtrando la secuencia #####"
bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz res/ yes

echo



echo "##### Generando indice STAR del genoma #####"
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx

echo



mkdir -p  out/merged

echo "##### Unión de las muestras_ARN en un único archivo #####"
for sid in $(ls data/*.fastq.gz | cut -d"-" -f1 | sed 's:data/::')
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done

echo




mkdir -p out/trimmed
mkdir -p log/cutadapt

echo "##### Eliminando los adaptadores de la Secuencia_unión en CutAdapt #####"
for sampleid in $()
do  cutadapt \
    	-m 18 \
    	-a TGGAATTCTCGGGTGCCAAGG \
    	--discard-untrimmed \
    	-o ~/decont/out/trimmed/${sampleid}.trimmed.fastq.gz ~/decont/out/merged/${sampleid}.fastq.gz > ~/decont/log/cutadapt/${sampleid}.log

echo



echo "##### Alineamiento de las secuencias_recortadas con el genoma de referencia #####"
for fname in out/trimmed/*.fastq.gz
do
    # you will need to obtain the sample ID from the filename
    sid= $($fname) #TODO
     mkdir -p out/star/$sid
     STAR \
	--runThreadN 4 \
	--genomeDir ~/decont/res/contaminants_idx \
        --outReadsUnmapped Fastx \
	--readFilesIn <fname> \
        --readFilesCommand gunzip -c \
	--outFileNamePrefix out/start/$sid
done 

echo

# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in
