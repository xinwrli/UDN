#!/bin/bash


# format varies within each institution

# CGS
# FORMAT/GT:AD:DP:GQ:PL

# CHEO
# FORMAT/GT:AD:DP:GQ:PL

# UDN
# FORMAT/GT:AD:DP:GQ:PL


instns=("CGS" "CHEO" "UDN")

printf "ID\tCHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tGT\tDP\tGQ\tPL[0]\tPL[1]\tPL[2]\tAD[0]\tAD[1]\n"

for ins in "CGS" "CHEO" "UDN"
do
	for i in $(ls -1 vcf_all/${ins}/RD*.vcf.gz)
	do
		[[ $i =~ (RD[0-9]+).vcf.gz ]];
		id=${BASH_REMATCH[1]};
		zcat $i | \
		awk -F'\t' -vID=$id\
		'BEGIN{OFS="\t"} \
		$2 ~ /[0-9]+/ { \
			PL[1]="NA";PL[2]="NA";PL[3]="NA";\
			AD[1]="NA";AD[2]="NA"; \
			GT="NA";GQ="NA";DP="NA"; \
			split($9, FORMAT, ":"); \
			split($10, FIELD, ":");
			for(i=1;i<=length(FORMAT);i++){ \
				if(FORMAT[i]=="DP"){DP=FIELD[i];}; \
				if(FORMAT[i]=="GT"){GT=FIELD[i]}; \
				if(FORMAT[i]=="GQ"){GQ=FIELD[i]}; \
				if(FORMAT[i]=="PL"){split(FIELD[i], PL, ",")}; \
				if(FORMAT[i]=="AD"){split(FIELD[i], AD, ",")}; \
			}; \
		print ID,$1,$2,$3,$4,$5,$6,$7, \
		GT,DP,GQ,PL[1],PL[2],PL[3],AD[1],AD[2];}'
	done
done

