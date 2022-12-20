# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).

##  for sid in $($(ls data/*.fastq.gz | cut | sed -s )
data=$1
out_merged=$2
sampleid=$3

cat $data/${sampleid}-*.fastq.gz > $out_merged/${sampleid}.fastq.gz
