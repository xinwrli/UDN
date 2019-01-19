
v8_output=~/projects/gtex/vep/output_vep/v8/byChr/
# v8_output=~/projects/gtex_v8/data_tower/annotation/vep/
udn_sites=~/projects/udn/variant_filter/vcf_processed/


phylop_output=~/projects/gtex_v8/annotation/phylop_output
ccr_output=~/projects/udn/annotation/ccr_output

phylop_bedgraph=~/projects/gtex_v8/annotation/phylop/hg38.phyloP100way.bedgraph
ccr_bed=~/projects/conservation/ccr/ccrs.autosomes.v2.20180420.hg38.bed
# hg19, use the original ones
ccr_bed=~/projects/conservation/ccr/ccrs.autosomes.v2.20180420.bed.gz


bed_script=bedtools


# for vcf, bedtools automatically consider range of indels
echo "\
${bed_script} intersect -a <(zcat ${udn_sites}/udn_homogenized_short.vcf.gz | awk '\$2 ~ /^[0-9]+$/{print \"chr\"\$1\"\t\"\$2\"\t\"\$2}') -b ${ccr_bed} -wa -wb | cut -f1-5,9-12,16,17,24 > ${ccr_output}/gtex_ccr_chr${chr}.txt "


echo "\
${bed_script} intersect -a ${udn_sites}/udn_homogenized_short.vcf.gz -b ${ccr_bed} -wa -wb | cut -f1-5,153-165 > ${ccr_output}/udn_ccr.txt "


