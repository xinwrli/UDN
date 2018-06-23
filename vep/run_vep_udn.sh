#!/bin/bash

udn_vcf=~/projects/udn/process_vcf/vcf_combined/udn_homogenized_short.vcf.gz
udn_vep=~/projects/udn/vep/output/udn_vep.vcf.gz
vep_dir=~/tools/ensembl-vep/


nohup ${vep_dir}/vep --species homo_sapiens --assembly GRCh37 --input_file ${udn_vcf} --format vcf --output_file STDOUT --cache --dir_cache ${vep_dir}/vep_cache --fasta ${vep_dir}/vep_cache/homo_sapiens/91_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz --cache_version 91 --everything --allele_number --vcf --offline --force_overwrite | bgzip > ${udn_vep}



