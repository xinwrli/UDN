
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
	print("sample_id\tCHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tGT\tDP\tGQ\tHa\tPL_00\tPL_GT\tAD_0\tAD_H1\tAD_H2\tvflag")
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
			GT = "NA";
			GQ = "NA";
			DP = "NA";
			H = ["NA","NA"];
			Ha = ["NA","NA"];
			PL = ["NA", "NA"]; #likelihood at 0/0 and H1/H2
			AD = ["NA", "NA", "NA"]; #depth at REF, H1 and H2
			genotype = record.genotype(sample)
			if 'GQ' in FORMAT:
				GQ = genotype['GQ']
			if 'DP' in FORMAT:
				DP = genotype['DP']

			if 'GT' in FORMAT:
				GT = genotype['GT']
				H = re.split("[/|]", GT)
				if len(H) == 2 and set(H) <= set(['0','1','2','3','4','5','6','7','8','9']):
					H0 = int(H[0])
					H1 = int(H[1])
					Ha[0] = alleles[H0]
					Ha[1] = alleles[H1]
					if 'AD' in FORMAT:
						tempAD = genotype['AD']
						AD = [tempAD[0],tempAD[H0],tempAD[H1]]
					if 'RR' in FORMAT and 'VR' in FORMAT and H0 <= 1 and H1 <= 1:
						tempAD = [genotype["RR"],genotype["VR"]]
						AD = [tempAD[0],tempAD[H0],tempAD[H1]]
					if 'PL' in FORMAT:
						tempPL = genotype['PL']
						if H0 >= H1:
							gt01=(H0+1)*H0/2+H1
						else:
							gt01=(H1+1)*H1/2+H0
						gt01 = int(gt01)
						PL = [tempPL[0],tempPL[gt01]]		
			bitF =  (not FILTER) or (FILTER == "NA") or (FILTER == '.') or (FILTER == "PASS") or (FILTER == "num prev seen samples > 30")
			bitGQ = (GQ == "NA") or (GQ == ".") or (GQ >= 20)
			bitPL = (PL[0] == "NA") or (PL[0] == ".") or (PL[1] < 20)
			bitGT = (GT != "NA")
			bitDP = (DP == "NA") or (DP == ".") or (DP >= 20)
			bitAD = (AD[0] == "NA") or (DP == "NA") or (DP == 0) or (AD[1]/DP >= 0.2 and AD[2]/DP >= 0.2 and (AD[1]+AD[2])/DP >= 0.8)
			bitA = bitF and bitGQ and bitPL and bitGT and bitDP and bitAD
			if bitA:
				flag = "PASS"
			else:
				flag = "FAIL"
			print(sample, CHROM, POS, ID, REF, ALT, QUAL, FILTER, FORMAT, GT, DP, GT, Ha, AD, PL, flag, sep = '\t')


if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument('--vcf', '--input', '-i', help='Input VCF file (from VEP+LoF); may be gzipped', required=True)
	parser.add_argument('--vep_field', '-v', help='Field of vep to output', required=False)
	args = parser.parse_args()
	main(args)


