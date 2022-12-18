#Download all the files specified in data/filenames
for url in $(cat data/urls) #TODO
do
    bash ~/decont/scripts/download.sh $url data
done
