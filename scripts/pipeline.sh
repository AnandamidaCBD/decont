echo "Iniciando script depurado de muestras de raton de secuenciacion de RNA... por C.Borja Romero Domínguez... a las $CI_JOB_STARTED_AT" "

echo "Descargando las secuencias de ARN archivo.fastq"
for url in $(cat ~decont/data/urls)
do
    bash ~/decont/scripts/download.sh $url ~/decont/data
done

echo



echo "Descargando el genoma de referencia archivo.fasta, descompriendo y filtrando la secuencia ... "
bash ~/decont/scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz ~/decont/res yes 

echo



echo "Realizando alineamiento sobre secuencia de referencia STAR ...."
bash ~/decont/scripts/index.sh res/contaminants.fasta ~/decont/res/contaminants_idx

echo



mkdir -p  ~/decont/out/merged

echo "Unión de las muestras_ARN en un único archivo ... "
for sid in $((ls data/*.fastq.gz | cut -d"-" -f1 | sed 's:data/::') 
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done

echo




mkdir -p ~/decont/out/trimmed
mkdir -p ~/decont/ log/cutadapt

echo "Eliminando los adaptadores de la Secuencia_unión en CutAdapt..."
for sampleid in $()
do  cutadapt \
    	-m 18 \
    	-a TGGAATTCTCGGGTGCCAAGG \
    	--discard-untrimmed \
    	-o ~/decont/out/trimmed/${sampleid}.trimmed.fastq.gz ~/decont/out/merged/${sampleid}.fastq.gz > ~/decont/log/cutadapt/${sampleid}.log

echo



echo "Generando indice STAR apartir de las secuencias_recortadas ..."
for fname in ~/decont/out/trimmed/*.fastq.gz
do
    # you will need to obtain the sample ID from the filename
    sid= $($fname) #TODO
     mkdir -p ~/decont/out/star/$sid
     STAR \
	--runThreadN 4 \
	--genomeDir ~/decont/res/contaminants_idx \
        --outReadsUnmapped Fastx \
	--readFilesIn <fname> \
        --readFilesCommand gunzip -c \
	--outFileNamePrefix ~/decont/out/start/$sid
done 

echo

# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in
