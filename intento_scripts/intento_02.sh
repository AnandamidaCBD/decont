#Download all the files specified in data/filenames
for url in $(<list_of_urls>) #TODO
do
    bash ~/decont/scripts/download.sh $url data
done
