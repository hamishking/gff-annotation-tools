#!/usr/bin/perl
use Getopt::Long;
use Pod::Usage;
use strict;

pod2usage("\nIntersects GFF file with .bed file and provides TRUE/FALSE output of intersect for each GFF interval. Requires BEDtools. \nUsage: -gff <gff file> -bed <interval file> -label <label for annotation>\n") if (($#ARGV<0) && (-t STDIN));

&GetOptions ("gff=s"=> \my $gff_file,
             "bed=s"=> \my $interval_file,
	     "label=s"=> \my $label,

	     );

my $gff_file_name = $gff_file;
   $gff_file_name =~ s/.gff//;              #removes file extension

my $outfile = "$gff_file_name\_$label\.gff";
my $temp = "/tmp/temp.gff";

open(TEMP, ">$temp") or die "Could not open $temp";

	my $commandinterval = `intersectBed -c -a $gff_file -b $interval_file` or die "Could not perform intersect with bedtools";
	my $commandoutput = $commandinterval;
	print TEMP "$commandoutput\n";

close TEMP;

open(IN, $temp) or die "Could not open $temp";

open(OUTPUT, ">$outfile") or die "Could not open $outfile";

while (<IN>) {

	
	chomp;
	my ($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9, $col10)= split /[\t]+/,;

		my $TRUEFALSE_status;

		   if ($col10 > 0) {
		       $TRUEFALSE_status = "TRUE";
			print OUTPUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\t$col9;$label=$TRUEFALSE_status\n";
		   }
		    else {
		      $TRUEFALSE_status = "FALSE";
			print OUTPUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\t$col9;$label=$TRUEFALSE_status\n";
		}	
}

close OUTPUT;

my $command = `rm /tmp/temp.gff`;

my $lastline="\$d";
`sed '$lastline' $outfile > /tmp/temp.gff`;
`mv /tmp/temp.gff $outfile`;

exit
