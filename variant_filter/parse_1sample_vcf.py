
__author__ = 'xinli'

# install the python package first
# in miniconda environment, python setup.py

import vcf
import argparse
import gzip
import re
import sys


def main(args):
	# f = gzip.open(args.vcf) if args.vcf.endswith('.gz') else open(args.vcf)
	vcf_reader = vcf.Reader(filename=args.vcf)
	# print(vcf_reader.infos)
	samples = vcf_reader.samples
	print("sample_id\tCHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tGT\tDP\tGQ\tPL[0]\tPL_GT\tAD[0]\tAD_H1\tAD_H2\tH1\tH2\tvflag")
	for record in vcf_reader:
		FORMAT = record.FORMAT
		REF = record.REF
		ALT = record.ALT
		CHROM = record.CHROM
		POS = record.POS
		ID = record.ID
		QUAL = record.QUAL
		FILTER = record.FILTER
		INFO = record.INFO
		alleles = [vcf.model._Substitution(REF)]
		alleles.extend(ALT)
		for sample in samples:
			genotype = record.genotype(sample)
			# PL = record.genotype(sample)['PL']
		        #                PL[1]="NA";PL[2]="NA";\
                        # AD[1]="NA";AD[2]="NA";AD[3]="NA";\
			if 'GT' in FORMAT:
				GT = genotype['GT']
				H = re.split("[/|]", GT)
				H1a = alleles[int(H[0])]
				H2a = alleles[int(H[1])]
			else:
				continue
			# GT="NA";GQ="NA";DP="NA"; \
                        # H1=0;H2=0; \
                        # H1a="";H2a=""; \
                        # tempGT[1]="NA";tempGT[2]="NA"; \
                        # tempAD[1]="NA";tempAD[2]="NA";tempAD[3]="NA"; \
                        # split($9, FORMAT, ":"); \
                        # split($10, FIELD, ":"); \
                        # split($4","$5, ALT, ","); \
			print(sample, CHROM, POS, ID, REF, ALT, QUAL, FILTER, FORMAT, GT, H, H1a, H2a, sep = '\t')


if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--vcf', '--input', '-i', help='Input VCF file (from VEP+LoF); may be gzipped', required=True)
	parser.add_argument('--vep_field', '-v', help='Field of vep to output', required=False)
	args = parser.parse_args()
	main(args)


