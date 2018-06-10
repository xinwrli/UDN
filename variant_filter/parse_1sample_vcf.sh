#!/bin/bash

vcf_file=$1


# accomodate following FORMAT
# CGS	GT:AD:DP:GQ:PL
# CGS	GT:GQ:PL
# CHEO	GT
# CHEO	GT:AD:DP:GQ:PL
# CHEO	GT:GQ:PL
# CHEO	GT:PL
# CHEO	GT:PL:DP:SP:GQ
# UDN	GT:AD
# UDN	GT:AD:DP
# UDN	GT:AD:DP:GQ:PGT:PID:PL
# UDN	GT:AD:DP:GQ:PL
# UDN	GT:AD:DP:PGT:PID
# UDN	GT:AD:GQ:PGT:PID:PL
# UDN	GT:AD:GQ:PL
# UDN	GT:AD:PGT:PID
# UDN	GT:VR:RR:DP:GQ


printf "sample_id\tCHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tGT\tDP\tGQ\tPL[0]\tPL[1]\tPL[2]\tAD[0]\tAD[1]\n"

if [[ ${vcf_file} =~ (RD[0-9]+).vcf.gz ]]; then
	id=${BASH_REMATCH[1]};
	zcat ${vcf_file} | \
		awk -F'\t' -vID=$id \
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
				if(FORMAT[i]=="RR"){AD[1]=FIELD[i]}; \
				if(FORMAT[i]=="VR"){AD[2]=FIELD[i]}; \
                        }; \
                print ID,$1,$2,$3,$4,$5,$6,$7, \
                GT,DP,GQ,PL[1],PL[2],PL[3],AD[1],AD[2];}'
fi


