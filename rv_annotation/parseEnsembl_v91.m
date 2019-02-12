

% parse all strings into tokens
% variants will be repeated

function ensembl_flattened = parseEnsembl_v91(ensembl, varargin)

    p = inputParser;
    checkInput1 = @(x) iscellstr(x);
    addParameter(p, 'annotation_identifier', [], checkInput1);


    p.KeepUnmatched = false; % not accepting additional parameters, not matching scheme
    parse(p, varargin{:});    
    
    annotation_identifier = p.Results.annotation_identifier;

    % We used SO terms by default since the Ensembl release 68.

    ensembl = myStandardName(ensembl, 'domain', 'vep');
    
    variant_identifier = {'chr', 'pos', 'ref', 'alt', 'allele'};
    if( isempty(annotation_identifier) )
        annotation_identifier = ...
            [variant_identifier, ...
            {'gene_id', 'Feature_type', 'Feature', 'BIOTYPE'}];    
    end
    
    
    uniq_anno = unique(ensembl(:, [annotation_identifier, {'Consequence'}]));
    uniq_anno.Properties.VariableNames{'Consequence'} = 'ensembl_vep';    
    
    
    joined2token = unique(uniq_anno.ensembl_vep);
    % there are many duplicate tokens for each vep
    joined2token = flattenSTRgroup(cellstr(joined2token), 'Delimiter', '&');
    joined2token = convertTableAllcell2categorical(joined2token);
    joined2token.Properties.VariableNames{'str'} = 'ensembl_tok';
    
    ensemblTable = ensembl_generic_categories();
    
    joined2token = outerjoin(joined2token, ensemblTable, 'Keys', {'ensembl_tok'}, 'type', 'left', 'RightVariables', {'parent_category'});    
    

    
    ensembl_flattened = outerjoin(uniq_anno, joined2token, 'LeftKeys', 'ensembl_vep', 'RightKeys', 'originalStr', 'type', 'left', 'RightVariables', {'ensembl_tok', 'parent_category'});  
    % remove duplicates
    ensembl_flattened = unique( ensembl_flattened(:, [annotation_identifier, {'ensembl_tok', 'parent_category'}]) );

    
    % clear duplicate annotations to those informative categories
    % w.r.t. the gene, chr_bps
    
    % 4 tiers, annoated in higher tiers will not be annotated later
    bitTier1 = ismember(ensembl_flattened.ensembl_tok, ...
        {'start_lost';'stop_gained';'stop_lost';   'splice_acceptor_variant';'splice_donor_variant';'splice_region_variant';   'frameshift_variant'});
    bit1 = ~ismember(ensembl_flattened(:, annotation_identifier), ensembl_flattened(bitTier1, annotation_identifier));
    ensembl_flattened = [ensembl_flattened(bitTier1,:); ensembl_flattened(bit1,:)];
    
    bitTier2 = ismember(ensembl_flattened.ensembl_tok, ...
        {'stop_retained_variant'; 'incomplete_terminal_codon_variant';'inframe_deletion';'inframe_insertion';'missense_variant';'protein_altering_variant';'synonymous_variant'});
    bit2 = ~ismember(ensembl_flattened(:, annotation_identifier), ensembl_flattened(bitTier2, annotation_identifier));
    ensembl_flattened = [ensembl_flattened(bitTier2,:); ensembl_flattened(bit2,:)];

    bitTier3 = ismember(ensembl_flattened.ensembl_tok, ...
        {'3_prime_UTR_variant';'5_prime_UTR_variant'});
    bit3 = ~ismember(ensembl_flattened(:, annotation_identifier), ensembl_flattened(bitTier3, annotation_identifier));
    ensembl_flattened = [ensembl_flattened(bitTier3,:); ensembl_flattened(bit3,:)];    

    bitTier4 = ismember(ensembl_flattened.ensembl_tok, ...
        {'intron_variant';'TFBS_ablation';'non_coding_transcript_exon_variant'});
    bit4 = ~ismember(ensembl_flattened(:, annotation_identifier), ensembl_flattened(bitTier4, annotation_identifier));
    ensembl_flattened = [ensembl_flattened(bitTier4,:); ensembl_flattened(bit4,:)];      
    
    ensembl_flattened = unique( ensembl_flattened(:, [annotation_identifier, {'ensembl_tok', 'parent_category'}]) );
    
end


function ensemblTable = ensembl_generic_categories()

    %%%%%
    ensemblTable = ensembl_generic_categories_v91();


end

% http://uswest.ensembl.org/info/genome/variation/predicted_data.html

% within coding region
% TSS to TES
% multiple annotation frequency
% 1, 2, 3, 4, 5, 6
% [1503842,679233,1129,1124,0,3]


% related to outlier
% {'splice_acceptor_variant';'splice_donor_variant';'splice_region_variant'}
% {'start_lost';'stop_gained';'stop_lost';'stop_retained_variant'}
% {'upstream_gene_variant'}
% {'3_prime_UTR_variant';'5_prime_UTR_variant'}
% {'missense_variant'}


% *	SO term	SO description	SO accession	Display term	IMPACT
% transcript_ablation	A feature ablation whereby the deleted region includes a transcript feature	SO:0001893	Transcript ablation	HIGH
% splice_acceptor_variant	A splice variant that changes the 2 base region at the 3' end of an intron	SO:0001574	Splice acceptor variant	HIGH
% splice_donor_variant	A splice variant that changes the 2 base region at the 5' end of an intron	SO:0001575	Splice donor variant	HIGH
% stop_gained	A sequence variant whereby at least one base of a codon is changed, resulting in a premature stop codon, leading to a shortened transcript	SO:0001587	Stop gained	HIGH
% frameshift_variant	A sequence variant which causes a disruption of the translational reading frame, because the number of nucleotides inserted or deleted is not a multiple of three	SO:0001589	Frameshift variant	HIGH
% stop_lost	A sequence variant where at least one base of the terminator codon (stop) is changed, resulting in an elongated transcript	SO:0001578	Stop lost	HIGH
% start_lost	A codon variant that changes at least one base of the canonical start codo	SO:0002012	Start lost	HIGH
% transcript_amplification	A feature amplification of a region containing a transcript	SO:0001889	Transcript amplification	HIGH
% inframe_insertion	An inframe non synonymous variant that inserts bases into in the coding sequenc	SO:0001821	Inframe insertion	MODERATE
% inframe_deletion	An inframe non synonymous variant that deletes bases from the coding sequenc	SO:0001822	Inframe deletion	MODERATE
% missense_variant	A sequence variant, that changes one or more bases, resulting in a different amino acid sequence but where the length is preserved	SO:0001583	Missense variant	MODERATE
% protein_altering_variant	A sequence_variant which is predicted to change the protein encoded in the coding sequence	SO:0001818	Protein altering variant	MODERATE
% splice_region_variant	A sequence variant in which a change has occurred within the region of the splice site, either within 1-3 bases of the exon or 3-8 bases of the intron	SO:0001630	Splice region variant	LOW
% incomplete_terminal_codon_variant	A sequence variant where at least one base of the final codon of an incompletely annotated transcript is changed	SO:0001626	Incomplete terminal codon variant	LOW
% stop_retained_variant	A sequence variant where at least one base in the terminator codon is changed, but the terminator remains	SO:0001567	Stop retained variant	LOW
% synonymous_variant	A sequence variant where there is no resulting change to the encoded amino acid	SO:0001819	Synonymous variant	LOW
% coding_sequence_variant	A sequence variant that changes the coding sequence	SO:0001580	Coding sequence variant	MODIFIER
% mature_miRNA_variant	A transcript variant located with the sequence of the mature miRNA	SO:0001620	Mature miRNA variant	MODIFIER
% 5_prime_UTR_variant	A UTR variant of the 5' UTR	SO:0001623	5 prime UTR variant	MODIFIER
% 3_prime_UTR_variant	A UTR variant of the 3' UTR	SO:0001624	3 prime UTR variant	MODIFIER
% non_coding_transcript_exon_variant	A sequence variant that changes non-coding exon sequence in a non-coding transcript	SO:0001792	Non coding transcript exon variant	MODIFIER
% intron_variant	A transcript variant occurring within an intron	SO:0001627	Intron variant	MODIFIER
% NMD_transcript_variant	A variant in a transcript that is the target of NMD	SO:0001621	NMD transcript variant	MODIFIER
% non_coding_transcript_variant	A transcript variant of a non coding RNA gene	SO:0001619	Non coding transcript variant	MODIFIER
% upstream_gene_variant	A sequence variant located 5' of a gene	SO:0001631	Upstream gene variant	MODIFIER
% downstream_gene_variant	A sequence variant located 3' of a gene	SO:0001632	Downstream gene variant	MODIFIER
% TFBS_ablation	A feature ablation whereby the deleted region includes a transcription factor binding site	SO:0001892	TFBS ablation	MODIFIER
% TFBS_amplification	A feature amplification of a region containing a transcription factor binding site	SO:0001892	TFBS amplification	MODIFIER
% TF_binding_site_variant	A sequence variant located within a transcription factor binding site	SO:0001782	TF binding site variant	MODIFIER
% regulatory_region_ablation	A feature ablation whereby the deleted region includes a regulatory region	SO:0001894	Regulatory region ablation	MODERATE
% regulatory_region_amplification	A feature amplification of a region containing a regulatory region	SO:0001891	Regulatory region amplification	MODIFIER
% feature_elongation	A sequence variant located within a regulatory region	SO:0001907	Feature elongation	MODIFIER
% regulatory_region_variant	A sequence variant located within a regulatory region	SO:0001566	Regulatory region variant	MODIFIER
% feature_truncation	A sequence variant that causes the reduction of a genomic feature, with regard to the reference sequence	SO:0001906	Feature truncation	MODIFIER
% intergenic_variant	A sequence variant located in the intergenic region, between genes	SO:0001628	Intergenic variant	MODIFIER

% 
% non_coding_transcript_exon_variant
% 0.02% splice_acceptor
% 0.99% splice_region
% ...
% they are passenger variants, not informative
% use a hierarchy



















