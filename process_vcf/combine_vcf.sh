#!/bin/bash

vcf_combined=~/projects/udn/process_vcf/vcf_combined

# old vcf
# ls /srv/scratch/restricted/rare_diseases/data/vcfs/for_freeze/*_homogenized_short.vcf.gz | xargs vcf-merge --ref-for-missing 0/0 | bgzip -c >

combine_vcf="{ ls vcf_all/CGS/*_homogenized_short.vcf.gz; ls vcf_all/UDN/*_homogenized_short.vcf.gz; ls vcf_all/CHEO/*_homogenized_short.vcf.gz; } | xargs nohup vcf-merge | bgzip -c > ${vcf_combined}/udn_homogenized_short.vcf.gz"


extract_id="{ ls vcf_all/CGS/*_homogenized_short.vcf.gz; ls vcf_all/UDN/*_homogenized_short.vcf.gz; ls vcf_all/CHEO/*_homogenized_short.vcf.gz; } | xargs nohup vcf-merge | nohup bcftools query --list-samples | sort > udn_vcfid.txt"

# fill in 0/0 for calculation of allele frequency
combine_vcf_fill="{ ls vcf_all/CGS/*_homogenized_short.vcf.gz; ls vcf_all/UDN/*_homogenized_short.vcf.gz; ls vcf_all/CHEO/*_homogenized_short.vcf.gz; } | xargs nohup vcf-merge --ref-for-missing 0/0 | nohup vcftools --vcf - --freq --stdout | bgzip -c > ${vcf_combined}/udn_homogenized_short.vcf.frq.gz"


combine_vcf_fill="{ ls vcf_all/CGS/*_homogenized_short.vcf.gz; ls vcf_all/UDN/*_homogenized_short.vcf.gz; ls vcf_all/CHEO/*_homogenized_short.vcf.gz; } | xargs nohup vcf-merge --ref-for-missing 0/0 | bgzip -c > ${vcf_combined}/udn_homogenized_short_filmisw00.vcf.gz"


echo "${combine_vcf}"
echo "${extract_id}"
echo "${combine_vcf_fill}"


