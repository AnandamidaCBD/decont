NOW=$(date +"%r-%m-%d-%Y")
my_name=$(basename -- "$0")

echo "##############################################################################################"
echo "##############################################################################################"
echo "##### Iniciando ${my_name} script depurado de muestras de secuenciacion de RNA de raton #####"
echo "##############################################################################################"
echo "##### C.Borja Romero Domínguez ##### script comenzado a las:${NOW} #####"
echo "##############################################################################################"
echo "##############################################################################################"


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

mkdir -p res/contaminants_idx

echo "##### Generando indice STAR del genoma #####"
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx

echo 



mkdir -p  out/merged

echo "##### Unión de las muestras_ARN en un único archivo #####"
for sampleid in $(ls data/*.fastq.gz | cut -d"-" -f1 | sed 's:data/::')
do
    bash scripts/merge_fastqs.sh data out/merged $sampleid
done

echo "##### Se han unido las secuencias en un único archivo satisfactoriamente! #####"




mkdir -p out/trimmed
mkdir -p log/cutadapt

echo "##### Eliminando los adaptadores de la Secuencia_unión en CutAdapt #####"
for sampleid in $(ls out/merged/*.fastq.gz | cut -d "." -f1 | sed 's:out/merged/::')
do  cutadapt \
    	-m 18 \
    	-a TGGAATTCTCGGGTGCCAAGG \
    	--discard-untrimmed \
    	-o out/trimmed/${sampleid}.trimmed.fastq.gz out/merged/${sampleid}.fastq.gz > log/cutadapt/${sampleid}.log
done

echo "##### Se han generado las secuencias $sampleid recortadas satisfactoriamente! #####"



echo "##### Alineamiento de las secuencias_recortadas con el genoma de referencia #####"

mkdir -p out/star

for fname in out/trimmed/*.fastq.gz
do

	sampleid=$(echo $fname | sed 's:out/trimmed/::' | cut -d "." -f1)
	mkdir -p out/star/$sampleid

	STAR \
		--runThreadN 8 \
		--genomeDir res/contaminants_idx \
       		--outReadsUnmapped Fastx \
		--readFilesIn $fname \
        	--readFilesCommand gunzip -c \
		--outFileNamePrefix out/start/$sampleid
done

echo " ##### Alineamiento de la secuencia $sampleid ha finalizado satisfactoriamente #####"



echo "##### Creando archivo_resumen .log contiendo la información de cutadapt y star #####"

for fname in log/cutadapt/*.log
do
	sampleid=$(basename $fname .log)

	echo "${sampleid}" >> log/summary.log

	echo $(cat log/cutadapt/${sampleid}.log | egrep "Reads with |Total basepairs") >> log/summary.log
	echo $(cat out/star/${sampleid}/${sampleid}Log.final.out | egrep "% of reads mapped to (multiple|too)") >> log/summary.log
	echo $(cat out/star/${sampleid}/${sampleid}Log.final.out | egrep " Uniquely mapped reads % ") >> log/summary.log
	echo >> log/summary.log
done

echo "##### Archivo_resumen.log creado #####"



END=$(date +"%r-%m-%d-%Y")
echo " ###### el ${my_name} script finalizo satisfactoriamente a las ${END} #####"
