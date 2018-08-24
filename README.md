# gff-annotation-tools

Tools developed as part of analysis for the manuscript "Polycomb repressive complex 1 shapes the nucleosome landscape but not accessibility at target genes."

Please contact h.king@qmul.ac.uk or drhamishking@gmail.com with questions or problems.

Requirements differ between scripts but most involve the use of: 
- samtools  http://samtools.sourceforge.net/ 
- BEDtools  https://bedtools.readthedocs.io/en/latest/
- HOMER http://homer.ucsd.edu/homer/index.html
- st  https://github.com/nferraz/st

For nucleosome feature annotation, output from the following may be required.
- DANPOS2 https://sites.google.com/site/danposdoc/ (used for MNase-seq nucleosome analysis)
- NucleoATAC https://nucleoatac.readthedocs.io/en/latest/ (used for ATAC-seq nucleosome analysis)

Where list of files is used, tab-limited format is required as

file.bam	filename


# General GFF annotation scripts
# BED2GFF.pl
Used to annotate 3/4 column .bed file using HOMER's annotatePeaks.pl and convert it to 9 column .gff file. 

# GFF2TXT.pl
Converts 9 column .gff file to tab-delimited table for use in R or other database packages.

# GFF_BED.Overlap.pl
Intersects GFF intervals with .bed file and annotates overlap as TRUE/FALSE. 
Requires BEDtools.

# GFF_BAM.Count.pl
Annotates GFF file intervals with read counts or reads per kilobase per million (RPKM) from a list of indexed bam files.
Requires samtools.

# GFF_BedGraph.Coverage.pl
Annotates intervals in GFF file with mean coverage for bedgraph files in a provided list. 
Requires BEDtools. 

# GFF_BisulfitePercentMethylation.pl
Annotates intervals in GFF file with Percent Methylation using HOMER TagDirectories made from Bismark-derived bisulfite cytosine.cov files.
Requires HOMER.


# Annotation of GFF files with nucleosome features
# GFF_ATAC.FragSizes.pl
Annotates intervals in GFF file with median and average fragment sizes of paired-end ATAC-seq reads.
Requries samtools, st.

# GFF_MNase.DANPOS2.Fuzziness.pl
Annotates GFF file with statistics of nucleosome fuzziness score calculated by DANPOS2 dpos. Requires a list of .smooth.positions.xls outputs from DANPOS2 with corresponding sample names. 
NB. Not to be used with differential DANPOS2 files ie ref_adjust or integrative.xls.
Requires BEDtools, st, DANPOS2 output. 

# GFF_MNase.DANPOS2.InterDyadDistance.pl
Annotates GFF file with statistics of distances between nucleosome positions identified using DANPOS2 dpos command. Requires a list of .smooth.positions.xls outputs from DANPOS2 with corresponding sample names. 
NB. Not to be used with differential DANPOS2 files ie ref_adjust or integrative.xls.
Requires BEDtools, st, DANPOS2 output. 

# GFF_MNase.DANPOS2.Occupancy.pl
Annotates GFF file with statistics of nucleosome summit occupancy calculated by DANPOS2 dpos. Requires a list of .smooth.positions.xls outputs from DANPOS2 with corresponding sample names. 
NB. Not to be used with differential DANPOS2 files ie ref_adjust or integrative.xls.
Requires BEDtools, st, DANPOS2 output. 

# GFF_NucleoATAC.InterDyadDistance.pl
Annotates GFF file with statistics of distances between nucleosome positions identified using NucleoATAC. Requires a list of nucmap_combined.bed outputs from NucleoATAC with corresponding sample names.
Requires BEDtools, st, NucleoATAC output. 


# GFF_NucleoATAC.NucPosFuzziness.pl
Annotates GFF file with statistics of nucleosome fuzziness score calculated by NucleoATAC. Requires a list of nucpos.bed outputs from NucleoATAC with corresponding sample names.
Requires BEDtools, st, NucleoATAC output. 
