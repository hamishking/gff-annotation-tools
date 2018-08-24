#!/usr/bin/perl
use Getopt::Long;
use Pod::Usage;
use strict;

pod2usage("\nAnnotates GFF file with median and average fragment sizes of paired-end ATAC-seq reads within each interval.\nUsage: -gff <9column GFF file> -file <Tab delimited file with list of .bam files and labels>\n") if (($#ARGV<0) && (-t STDIN));

&GetOptions ("file=s"=> \my $file,
             "gff=s"=> \my $gff,
	          );

my $gffname = $gff;
   $gffname =~ s/.gff//;           
my $input = "$gffname.FragSizes.ANNOTATED.gff";   
   `cp $gff $input`;
   

open(IN, $file) or die "Could not open $file";

while(<IN>){
            chomp;
            my ($bamfile, $label)=split (/\t/,);
            print "$label\n";
            
			my $outfile = "$gffname\.tmp.$label\.gff";
			
			open(INPUT, $input) or die "Could not open $input";
			open(OUT, ">$outfile") or die "Could not open $outfile";
			
			
		

			while (<INPUT>){
 chomp;
                        my ($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9)=split (/\t+/); 
                        my $interval = "$col1:$col4-$col5"; 
                
# count reads in intervals for bamfile
	       my $dollar9 = '$9';
		my $dollar1 = '$1';

            my $commandinterval = `samtools view -@ 20 $bamfile $interval | awk ' { if($dollar9>=0) { print $dollar9"\t"$dollar1} else {print $dollar9*-1"\t"$dollar1 }}' | sort -h -k 2,2 | uniq | cut -f 1 | st --complete | sed -n 2p`;

	chomp $commandinterval;

		 my ($number, $min, $q1, $median, $q3, $max, $sum, $mean, $stddev, $stderr)=split (/\t+/,$commandinterval); 

		if($number > 0){
		print OUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\t$col9;$label\_MedFragSize=$median;$label\_MeanFragSize=$mean\n";
		}
		else{
		print OUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\t$col9;$label\_MedFragSize=NA;$label\_MeanFragSize=NA\n";
		}
			}						
			`mv $outfile $input`;
			close OUT;


close INPUT;

}

close IN;
