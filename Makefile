all: youtube-dl-vines.log youtube-dl-non-vines.log

vines-only.txt: urls-only.txt
	grep vine\.co\/v\/ urls-only.txt > vines-only.txt

non-vines-only.txt: urls-only.txt
	grep -v vine\.co\/v\/ urls-only.txt > non-vines-only.txt

urls-only.txt: urls.csv
	cut -d, -f1 urls.csv > urls-only.txt

urls.csv: urls.tsv
	tr "\\t" , < urls.tsv > urls.csv

urls.tsv: ferguson-urls/urls.tsv.gz
	cp ferguson-urls/urls.tsv.gz . && gunzip urls.tsv.gz

youtube-dl-vines.log: vines-only.txt
	mkdir -p youtube-dl-vines
	cd youtube-dl-vines && youtube-dl -w --write-description --write-info-json --write-annotations -i -a ../vines-only.txt &> ../youtube-dl-vines.log

youtube-dl-non-vines.log: non-vines-only.txt
	mkdir -p youtube-dl
	cd youtube-dl && youtube-dl --no-playlist --datebefore 20140901 --dateafter 20140801 -w --write-description --write-info-json --write-annotations -i -a ../non-vines-only.txt &> ../youtube-dl-non-vines.log

ferguson-urls/urls.tsv.gz:
	git submodule update --init --recursive

.PRECIOUS: youtube-dl-vines.log youtube-dl-non-vines.log
