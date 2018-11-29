#!/bin/bash

vcftools --gzvcf  /users/xli6//projects/udn/process_vcf/vcf_combined/udn_homogenized_short.vcf.gz --extract-FORMAT-info GT --stdout --positions temp_all_sites.txt > output_genotype/udn_eqtl_sites.GT



