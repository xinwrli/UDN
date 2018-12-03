#!/bin/bash

udn_vcf=~/projects/udn/process_vcf/vcf_combined/udn_homogenized_short.vcf.gz
# udn_vcf=~/projects/udn/process_vcf/vcf_filtered/vcf_processed/pilot_run1-2/all_homogenized_short.vcf.gz
# udn_vcf=/srv/scratch/restricted/rare_diseases/data/vcfs/vcf_filtered/vcf_filtered_homogenized/RD001_homogenized_gnomad_cadd.vcf.gz
udn_vcf_sites=~/projects/udn/process_vcf/vcf_combined/udn_homogenized_short_sites.vcf.gz

udn_vep=~/projects/udn/vep/output/udn_vep.vcf.gz
vep_dir=~/tools/ensembl-vep/
vep_output=STDOUT

vep_script=~/tools/ensembl-vep/vep
parse_vep=~/projects/vep/read_vep_vcf.py
python=/usr/bin/python2.7


vep_cache=~/tools/ensembl-vep/vep_cache
vep_fasta=${vep_cache}/homo_sapiens/93_GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
vep_fasta_37=${vep_cache}/homo_sapiens/91_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
vep_fasta_88=${vep_cache}/homo_sapiens/88_GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
vep_fasta_94=${vep_cache}/homo_sapiens/94_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz


# must be sorted, bgzip and tabix indexed
# vep does not use this, still uses the gencode in cache 88
# gencode26=~/projects/gtex/data_shared/GTEx_Analysis_2017-06-05_v8/references/gencode.v26.GRCh38.genes.gtf
gencode26=~/projects/gtex/reference/v8_durga/gencode.v26.GRCh38.genes.gtf.gz
gencode19=~/projects/gene_model/gencode.v19.annotation.gtf.gz

echo "\
bcftools view -G ${udn_vcf} | bgzip -c > ${udn_vcf_sites}"

echo "\
${vep_script} --species homo_sapiens --assembly GRCh37 --input_file ${udn_vcf} --format vcf --output_file ${vep_output} --cache --dir_cache ${vep_cache} --fasta ${vep_fasta_94} --cache_version 94 --gtf ${gencode19} --everything --allele_number --vcf --offline --force_overwrite --plugin LoF,loftee_path:/users/xli6/tools/loftee-0.3-beta --dir_plugins ~/tools/loftee-0.3-beta/"

exit

nohup ${vep_dir}/vep --species homo_sapiens --assembly GRCh37 --input_file ${udn_vcf} --format vcf --output_file STDOUT --cache --dir_cache ${vep_dir}/vep_cache --fasta ${vep_dir}/vep_cache/homo_sapiens/91_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz --cache_version 91 --everything --allele_number --vcf --offline --force_overwrite | bgzip > ${udn_vep}

${python} ~/projects/vep/read_vep_vcf.py --vcf ${udn_vdp} > output/udn_vep_parsed.txt

awk '{for(i = 44; i <= 61; i++){if($i ~ /&/){match($i, /(.+)&/, arr); $i=arr[1]}}print $0}'




