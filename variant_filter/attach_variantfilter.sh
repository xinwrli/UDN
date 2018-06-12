#!/bin/bash

filter_dir=~/projects/udn/variant_filter/vcf_processed/filter_byind/
rare_filter=~/projects/udn/feature_file/udn_rv_filter.txt
rare_variant=~/projects/udn/feature_file/udn_variant_annotation.txt
ase_variant=~/projects/udn/ase/ensembleids.ase.merged.txt
convert_contig=~/projects/tablejoin/contig/convert_contig.sh


cat <(tblmap -k"Chrom,Pos,indID" ${rare_variant} | tblsort | uniq) \
<(tblmap -k"Chr,POS,#SampID" ${ase_variant} | tblsort | uniq | awk '{if(NR > 1){print}}') | tblsort | uniq > temp_variant.txt

bash ${convert_contig} temp_variant.txt | tblsort -k"chr_numeric,pos/n,indid" > temp_variant_numeric.txt
rm temp_variant.txt


wait

ls -1 $filter_dir/*.filter_varsite.txt | awk -F"\t" 'BEGIN{OFS="\t"}{match($1, /(RD[0-9]+)\./, arr); print $1,arr[1]}' \
	| parallel --jobs 20 --replace {} --colsep "\t" 'tbljoin -k"sample_id=indid","chr_numeric","pos"' {1} temp_variant_numeric.txt ">" {2}"_temp"


wait


tblcat $(ls *_temp) | awk -F"\t" 'BEGIN{OFS="\t"}{print $1,$19,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$21,$22}' > ${rare_filter}


wait

rm temp_variant_numeric.txt
rm *_temp


