#!/bin/bash


bash generate_variantfilters.sh | parallel --jobs 20

wait

# should not be used for individually combined vcf
# if combining individual vcfs, vcf-merge --ref-for-missing 0/0
# need to fill in 0/0

# generate_sitefilters.sh

wait

bash combine_filters.sh

wait

bash filter_allvcf.sh | parallel --jobs 20

wait

# bash attach_variantfilter.sh



