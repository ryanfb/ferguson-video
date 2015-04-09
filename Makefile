all: youtube-dl.log

urls-only.txt: urls.csv
	cut -d, -f1 urls.csv > urls-only.txt

urls.csv: urls.tsv
	tr "\\t" , < urls.tsv > urls.csv

urls.tsv: ferguson-urls/urls.tsv.gz
	cp ferguson-urls/urls.tsv.gz . && gunzip urls.tsv.gz

youtube-dl.log: urls-only.txt
	mkdir -p youtube-dl
	cd youtube-dl && youtube-dl -w --write-description --write-info-json --write-annotations -i -a ../urls-only.txt &> ../youtube-dl.log

ferguson-urls/urls.tsv.gz:
	git submodule update --init --recursive
