#!/bin/bash

vcf_combined=~/projects/udn/process_vcf/vcf_combined

# old vcf
# ls /srv/scratch/restricted/rare_diseases/data/vcfs/for_freeze/*_homogenized_short.vcf.gz | xargs vcf-merge --ref-for-missing 0/0 | bgzip -c >

combine_vcf="{ ls vcf_all/CGS/*_homogenized_short.vcf.gz; ls vcf_all/UDN/*_homogenized_short.vcf.gz; ls vcf_all/CHEO/*_homogenized_short.vcf.gz; } | xargs nohup vcf-merge | bgzip -c > ${vcf_combined}/udn_homogenized_short.vcf.gz"

# 1. try combining short format, only GT field, failed due to RD221, CNV field
short_format=vcf_filtered/vcf_filtered_homogenized/short_format/*.vcf.gz
# 2. try combining original filterd VCF, not indexed cannot merge
filtered_file3=vcf_filtered/vcf_processed/pilot_run1-2/filter_byind/*.filtered.vcf.gz
# 3. create temp folder filter RD221 individually
filtered_file2=${vcf_combined}/temp_filtered/*homogenized_short*.vcf.gz

combine_vcf_filtered="ls ${short_format} | xargs vcf-merge | bgzip -c > ${vcf_combined}/udn_homogenized_short.vcf.gz"
combine_vcf_filtered="ls ${filtered_file3} | xargs vcf-merge | bgzip -c > ${vcf_combined}/udn_homogenized_short.vcf.gz"
combine_vcf_filtered="ls ${filtered_file2} | xargs vcf-merge | bgzip -c > ${vcf_combined}/udn_homogenized_short.vcf.gz"


extract_id="{ ls vcf_all/CGS/*_homogenized_short.vcf.gz; ls vcf_all/UDN/*_homogenized_short.vcf.gz; ls vcf_all/CHEO/*_homogenized_short.vcf.gz; } | xargs nohup vcf-merge | nohup bcftools query --list-samples | sort > udn_vcfid.txt"

# fill in 0/0 for calculation of allele frequency
combine_vcf_fill="{ ls vcf_all/CGS/*_homogenized_short.vcf.gz; ls vcf_all/UDN/*_homogenized_short.vcf.gz; ls vcf_all/CHEO/*_homogenized_short.vcf.gz; } | xargs nohup vcf-merge --ref-for-missing 0/0 | nohup vcftools --vcf - --freq --stdout | bgzip -c > ${vcf_combined}/udn_homogenized_short.vcf.frq.gz"


# combine_vcf_fill="{ ls vcf_all/CGS/*_homogenized_short.vcf.gz; ls vcf_all/UDN/*_homogenized_short.vcf.gz; ls vcf_all/CHEO/*_homogenized_short.vcf.gz; } | xargs nohup vcf-merge --ref-for-missing 0/0 | bgzip -c > ${vcf_combined}/udn_homogenized_short_filmisw00.vcf.gz"


echo "${combine_vcf}"
echo "${combine_vcf_filtered}"
echo "${extract_id}"
echo "${combine_vcf_fill}"

# run nohup bash -c 'command_line'




