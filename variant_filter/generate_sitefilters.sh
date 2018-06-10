#!/bin/bash

vcftools --gzvcf vcf_combined/all_homogenized_short.vcf.gz --missing-site --stdout | bgzip > vcf_combined/udn_vcf_missing.txt.gz
# tabix -p vcf vcf_combined/udn_vcf_missing.txt.gz
vcftools --gzvcf vcf_combined/all_homogenized_short.vcf.gz --hardy --stdout | bgzip > vcf_combined/udn_vcf_hwe.txt.gz
# tabix -p vcf vcf_combined/udn_vcf_hwe.txt.gz

# bedtools intersect -a <(vcftools --gzvcf vcf_combined/all_homogenized_short.vcf.gz --missing-site --stdout | awk 'BEGIN{OFS="\t"}{print $1,$2,$2,$6}' | head) \
#	-b <(vcftools --gzvcf vcf_combined/all_homogenized_short.vcf.gz --hardy --stdout | awk 'BEGIN{OFS="\t"}{print $1,$2,$2,$6}' | head) \
#	-wa -wb -loj -f 1


# tbljoin can only use lower case column names
tbljoin -k"chr","pos" \
	-lr \
	vcf_combined/udn_vcf_missing.txt.gz \
	vcf_combined/udn_vcf_hwe.txt.gz \
	| awk 'BEGIN{OFS="\t"}{if(NR > 1){$1="chr"$1};if($1=="chrMT"){$1="chrM"};print $1,$2,$6,$10;}' > vcf_combined/udn_site_filters.txt

tbljoin -k"chrom"="chr","pos" \
	-l \
	vcf_combined/udn_vcf_filters.txt.gz \
	vcf_combined/temp_site.txt | gzip > vcf_combined/udn_vcf_filters_all.txt.gz	

rm temp_site.txt
rm udn_vcf_missing.txt.gz
rm udn_vcf_hwe.txt.gz




