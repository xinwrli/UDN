#!/bin/bash


# format varies within each institution

# CGS	GT:AD:DP:GQ:PL
# CHEO	GT:AD:DP:GQ:PL
# CHEO	GT:PL
# CHEO	GT:PL:DP:SP:GQ
# UDN	GT:AD:DP
# UDN	GT:AD:DP:GQ:PL
# UDN	GT:VR:RR:DP:GQ

# bcftools does not work on UDN vcfs, format not correct

parse_vcf_cmd=~/projects/udn/variant_filter/parse_1sample_vcf.sh
output_filter=~/projects/udn/variant_filter/vcf_combined/filter_byind/


instns=("CGS" "CHEO" "UDN")

# printf "sample_id\tCHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tGT\tDP\tGQ\tPL[0]\tPL[1]\tPL[2]\tAD[0]\tAD[1]\n"

for ins in "CGS" "CHEO" "UDN"
do
	for i in $(ls -1 vcf_all/${ins}/RD*.vcf.gz)
	do
		zcat $i | awk -F"\t" -vins=${ins} -vi=$i 'BEGIN{OFS="\t"}$2 ~ /[0-9]+/{print ins,i,$9;}' | sort | uniq >> udn_filter_FORMAT.txt &
		#bash ${parse_vcf_cmd} $i
	done
done







