#!/usr/bin/perl
use Getopt::Long;
use Pod::Usage;
use strict;

pod2usage("\nAnnotates GFF file intervals with read counts or reads per kilobase per million (RPKM) from a list of bam files. Requires samtools. \nUsage: -gff <9column GFF file> -file <Tab delimited file with list of bam files and labels> -rpkm <True/False - whether to generate read count or RPKM> \n") if (($#ARGV<0) && (-t STDIN));

&GetOptions ("file=s"=> \my $listfile,
             "gff=s"=> \my $gff,
             "rpkm=s"=> \my $rpkmstatement,
);


my $gffname = $gff;
   $gffname =~ s/.gff//;           
my $input = "$gffname.ANNOTATED.gff";   
   `cp $gff $input`;
   

open(IN, $listfile) or die "Could not open $listfile";

while(<IN>){
            chomp;
            my ($bamfile, $label)=split (/\t/,);
            print "$label\n";
            
			my $outfile = "$gffname\.tmp.$label\.gff";
			
			open(INPUT, $input) or die "Could not open $input";
			open(OUT, ">$outfile") or die "Could not open $outfile";
			
			
			if ($rpkmstatement =~ "True" || $rpkmstatement =~ "true" || $rpkmstatement =~ "T" ) {
						my $totalreadnumber = `samtools view -c $bamfile` or die "Could not perform total read count with samtools";           #counts total number of reads in bamfile1 using Samtools command
						my $totalpermil = $totalreadnumber/1000000; #normalises total read per million - can be adjusted to determine scale of output
		
						while (<INPUT>){
									chomp;
									my ($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9)=split (/\t+/); #chomps, splits and assigns bed file into three columns
									my $interval = "$col1:$col4-$col5"; 
									my $size = ($col5 - $col4)/1000;
									
									my $readcount = `samtools view -c $bamfile $interval` or die "Could not perform interval read count with samtool";    
												chomp $readcount;                                                                                      
									my $rpkm = sprintf("%.10f", ($readcount/$size)/$totalpermil);

									print OUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\t$col9;$label\_RPKM=$rpkm\n";
						}						
						`mv $outfile $input`;
						close OUT;
			}
			
			else{
						while (<INPUT>){
									chomp;
									my ($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9)=split (/\t+/); #chomps, splits and assigns bed file into three columns
									my $interval = "$col1:$col4-$col5"; #ucsc coordinates
									
									my $readcount = `samtools view -c $bamfile $interval` or die "Could not perform interval read count with samtools";    
												chomp $readcount;                                                                                      
			
									print OUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\t$col9;$label\_ReadCount=$readcount\n";
						}						
						`mv $outfile $input`;
						close OUT;
			}
			
			close INPUT;

}

close IN;
