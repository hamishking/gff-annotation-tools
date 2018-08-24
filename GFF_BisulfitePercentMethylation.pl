#!/usr/bin/perl
use Getopt::Long;
use Pod::Usage;
use strict;

pod2usage("\nAnnotates GFF file with Percent Methylation using HOMER TagDirectories made from Bismark-derived bisulfite cytosine.cov files. \nUsage: -gff <.gff file> -cytosine <HOMER TagDirectory for cytosine.cov file> -genome <genome eg. mm10> -label <label>\n") if (($#ARGV<0) && (-t STDIN));

&GetOptions ("gff=s"=> \my $gfffile,
             "cytosine=s"=> \my $cytosine,
             "label=s"=> \my $label,
             "genome=s"=> \my $genome,
	     );


my $gfffilename = $gfffile;
   $gfffilename =~ s/.gff//;

my $bedfile = "$gfffilename.bed";
my $outfile = "$gfffilename\_$label.gff";

`cut -f 1,4,5 $gfffile > $bedfile`;


my $homerfile = "$gfffilename.homer.txt";
my $homercommand = `annotatePeaks.pl $bedfile $genome -mC -d $cytosine > $homerfile`;

`cut -f 2,3,4,11,20 $homerfile > $homerfile.cut.txt`;


my %hash;

open(IN, "$homerfile.cut.txt") or die "Cannot read $homerfile.cut.txt";
while (<IN>){
	chomp;
	my ($chr, $start, $stop,$id, $methylationscore) = split(/\t/);
	$hash{$chr}{$start-1}{$stop}=$_;
}
close IN;

open(OUT, ">$outfile") or die "Could not open $outfile";

open(INFO, "$gfffile") or die "Cannot read $gfffile";

while (<INFO>){
	chomp;
	my ($col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9) = split(/\t/);
			
        
	if (exists $hash{$col1}{$col4}{$col5}){
		my $storedgene = $hash{$col1}{$col4}{$col5};
			chomp $storedgene;

		my ($chr, $start, $stop,$id, $methylationscore) = split /[\t]+/,$storedgene;

		print OUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\t$col9;$label\_PercentMethylation=$methylationscore\n";

        }
}

close INFO;
close OUT;

`rm $gfffilename.bed`;
`rm $homerfile`;
`rm $homerfile.cut.txt`;
