#!/usr/bin/perl
use Getopt::Long;
use Pod::Usage;
use strict;

pod2usage("\nAnnotates intervals in GFF file with mean coverage for bedgraph files in a provided list. Requires BEDtools. \nUsage: -gff <9column GFF file> -file <Tab delimited file with list of bedgraph files and labels>\n") if (($#ARGV<0) && (-t STDIN));

&GetOptions ("file=s"=> \my $file,
             "gff=s"=> \my $gff,
	          );

my $gffname = $gff;
   $gffname =~ s/.gff//;           
my $input = "$gffname.ANNOTATED.gff";   
   `cp $gff $input`;
my $dollar2 = '$2';my $dollar3 = '$3';my $dollar4 = '$4';
   

open(IN, $file) or die "Could not open $file";

while(<IN>){
            chomp;
            my ($bedgraphfile, $label)=split (/\t/,);
            print "$label\n";
            
	my $outfile = "$gffname\.tmp.$label\.gff";

	my $temp = "/tmp/temp.gff";
	`bedtools map -a $input -b $bedgraphfile -c 4 -o mean > $temp`;
	open(TMP, $temp) or die "Could not open $temp";
	open(OUTPUT, ">$outfile") or die "Could not open $outfile";

	while(my $line = <TMP>){
			chomp $line;		
		my ($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9, $col10)= split (/\t+/,$line);
	
		if ($col10 > 0) {
			my $mean = sprintf("%.5f", ($col10));
			print OUTPUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\t$col9;$label\_BedGraphMeanCoverage=$mean\n";
		}
		 else {
		         print OUTPUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\t$col9;$label\_BedGraphMeanCoverage=0\n";
		}	
	}
	close TMP;
	close OUTPUT;
	`mv $outfile $input`;
	my $command = `rm /tmp/temp.gff`;
}

close IN;
