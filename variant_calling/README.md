# udn / variant filtering pipeline

The variant QC generally follows the pipeline in ref1 and ref2.

### variant based metrics:
1. keep only "PASS" variants, determined by the GATK variant quality score recalibration (VQSR)
2. 

### site based metrics: 
3. exclude variants with HWE p-value < 1e-6
4. exclude varriants with call rate < 0.80 (missing > 20%)



[ref1] Ganna, A., Satterstrom, F. K., Zekavat, S. M., Das, I., Kurki, M. I., Churchhouse, C., … Neale, B. M. (2018). Quantifying the Impact of Rare and Ultra-rare Coding Variation across the Phenotypic Spectrum. American Journal of Human Genetics, 102(6), 1204–1211. https://doi.org/10.1016/j.ajhg.2018.05.002

[ref2] Lek, M., Karczewski, K. J., Minikel, E. V, Samocha, K. E., Banks, E., Fennell, T., … Exome Aggregation Consortium. (2016). Analysis of protein-coding genetic variation in 60,706 humans. Nature, 536(7616), 285–91. https://doi.org/10.1038/nature19057
