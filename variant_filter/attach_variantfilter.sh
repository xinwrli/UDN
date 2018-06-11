#!/bin/bash

filter_dir=~/projects/udn/variant_filter/vcf_combined/filter_byind/
rare_filter=~/projects/udn/feature_file/variant_filter.txt
rare_variant=~/projects/udn/feature_file/udn_variant_annotation.txt


cut -f2,3,5,7,13 ${rare_variant} > temp_variant.txt


wait

ls -1 $filter_dir/*.filter_varsite.txt | awk -F"\t" 'BEGIN{OFS="\t"}{match($1, /(RD[0-9]+)\./, arr); print $1,arr[1]}' \
	| parallel --jobs 20 --replace {} --colsep "\t" 'tbljoin -k"sample_id=indid","chr_numeric=chrom","pos"' {1} temp_variant.txt ">" {2}"_temp"


wait

head -1 RD001_temp | awk -F"\t" 'BEGIN{OFS="\t"}{if(NR == 1){print $1,$17,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$19,$20}}' > ${rare_filter}
cat $(ls *_temp) | awk -F"\t" 'BEGIN{OFS="\t"}{if($3 ~ /[0-9]+/){print $1,$17,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$19,$20}}'  >> ${rare_filter}


wait

rm temp_variant.txt
rm *_temp


