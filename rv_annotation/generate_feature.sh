#!/bin/bash


## set the folder where the input and intermediate files will be saved
export RAREVARDIR=/users/xli6/data/xin/udn/RIVER


## all bed.gz, vcf.gz files are indexed by tabix, with associated .tbi files

#### [step 0]
## tabix indexed WGS vcf file
WGS_VCF_FILE=/users/xli6/data/xin/udn/vcf/all_homogenized_short.vcf.gz
## list of individuals (VCF ids) to be included in the analysis. if all use (vcf-query -l ${WGS_VCF_FILE})
IND_LIST=/users/xli6/data/xin/udn/vcf/udn_all_VCFid.txt
# /users/xli6/data/xin/udn/vcf/all_homogenized_short.vcf.gz
## VEP annotation
VEP_ANNOTATION=/mnt/lab_data/montgomery/xli6/udn/vep/all_homogenized_short.vep_everything.vcf.gz
VEP_ANNOTATION=/users/xli6/data/xin/udn/vep/all_homogenized_short.vep_everything.vcf.gz
## computed 1KG allele frequency
AF_1KG_EUR=/users/xli6/data/xin/gtex/RIVER_input/data/wgs/1KG_xin/EUR.chrALL.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz.frq.gz
AF_1KG=/users/xli6/data/xin/1000genomes/AF/ALL.chrALL.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz.frq.gz
## DANN annotation
DANN_ANNOTATION=/users/xli6/data/xin/gtex/RIVER_input/annotation/DANN_whole_genome_SNVs.tsv.bgz
## CADD annotation
CADD_SNP=/mnt/lab_data/montgomery/shared/CADD/whole_genome_SNVs_inclAnno.tsv.gz
CADD_INDEL=/mnt/lab_data/montgomery/shared/CADD/InDels_inclAnno.tsv.gz
## other annotations
CHROMHMM=/users/xli6/data/xin/gtex/RIVER_input/annotation/wgEncodeBroadHmmGm12878HMM.bed.gz
PHYLOP=/users/xli6/data/xin/phyloP/phyloP100way/hg19.100way.phyloP100way.bedgraph.gz


#### [step 2]
## retain high quality variant calls (VQSLOD = PASS) were considered, only sites having <= 10 individuals in terms of missing genotypes were considered, and only autosomes were considered, and only European subjects were considered.
<<skipped
vcftools --gzvcf ${WGS_VCF_FILE} --keep ${IND_LIST} --remove-filtered-all --max-missing-count 10 --not-chr X --recode --recode-INFO-all --stdout | bgzip -c > ${RAREVARDIR}/data/wgs/a_filtered_and_compressed_GTEx_WGS_vcf_file
tabix -p vcf ${RAREVARDIR}/data/wgs/a_filtered_and_compressed_GTEx_WGS_vcf_file
skipped


#### [Step 4] gerate the regions around gene, where the variants will be extracted
## /users/xli6/data/xin/gtex/RIVER_input/preprocessing/rvsite/region.tss10k.txt

#### [Step 5] In each subject of interest, extract a list of individual-specific rare variant sites based on AFs of both GTEx and EUR 1K population
<<skipped
count_ind=0
for ID in $(cat ${IND_LIST})
do
count_ind=$(( $count_ind + 1 ))
echo "\
cat /users/xli6/data/xin/gtex/RIVER_input/preprocessing/rvsite/region.tss10k.txt | python /users/xli6/data/xin/gtex/RIVER_input/RIVERgtex_xin/extract_rvsites_ByInd.py -n $count_ind --id $ID --WGSvcf_in ${RAREVARDIR}/data/wgs/a_filtered_and_compressed_GTEx_WGS_vcf_file_MAF002 --GTExvcf_in /users/xli6/data/xin/udn/vcf/all_homogenized_short.vcf.gz.frq.gz --EURvcf_in ${AF_1KG} --AFcutoff 0.02 --site_out ${RAREVARDIR}/data/indiv/${ID}.${count_ind}.rvsites.txt"
done
skipped

#### [Step 6] Extract all the features simulataneously (CADD, chromHMM, phylop, DANN).

count_ind=0
for ID in $(cat ${IND_LIST})
do
count_ind=$(( $count_ind + 1))
echo "\
cat ${RAREVARDIR}/data/indiv/${ID}.$count_ind.rvsites.txt | python /users/xli6/data/xin/gtex/RIVER_input/RIVERgtex_xin/extract_scores_combined.py -n $count_ind --id $ID --af_in /users/xli6/data/xin/udn/vcf/all_homogenized_short.vcf.gz.frq.gz --wgs_in ${RAREVARDIR}/data/wgs/a_filtered_and_compressed_GTEx_WGS_vcf_file_MAF002 --anno_in ${VEP_ANNOTATION} --cadd_in ${CADD_SNP} --cadd_indel_in ${CADD_INDEL}  --dann_in ${DANN_ANNOTATION} --chromHMM_in ${CHROMHMM} --phylop_in ${PHYLOP} --score_out /mnt/lab_data/montgomery/xli6/udn/score/${ID}.${count_ind}.score.nuc.txt"
done




