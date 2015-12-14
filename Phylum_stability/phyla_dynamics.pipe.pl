#!/usr/bin/perl -w


die "perl $0 <phylum> <otu.biom> <datelist> <rep.tre>\n" unless(@ARGV == 3);
die "$!\n" unless open(I,"$ARGV[0]");

my $fbiom = $ARGV[1];
$fbiom =~s/\.biom//;
my $datelist = $ARGV[2];

while(<I>){
	chomp;

##Filter OTUs table by phylum
	`mkdir $_` unless (-d "$_");
	chdir $_;
	my $obiom = "$fbiom\.$_\.biom";
	`filter_taxa_from_otu_table.py -i ../$ARGV[1] -o $obiom -p $_`;
##beta-diversity analysis
	` beta_diversity.py -i $obiom -o matrix --metrics bray_curtis -t $ARGV[3]`;
	` beta_diversity.py -i $obiom -o matrix --metrics unweighted_unifrac -t $ARGV[3]`;
#analysis unifrac distance for each phylum
	$obiom =~ s/biom/txt/;
	my $womatrix = "matrix/bray_curtis_$obiom";
	my $unwomatrix = "matrix/unweighted_unifrac_$obiom";

	my $or = "$_\.stability.txt";	
	`perl  ../betadiversity_distribution.pl $womatrix $unwomatrix ../$datelist > $or`;
	my $orwei = "$_\.bray_curtis.txt";
	`head -1 $or > $orwei; less -S  $or | perl -ne 'chomp; if(/\tweighted/){print "\$_\n";}' >> $orwei`;
##R plot of the dynamics of phylum along time
	my $rfile = <<RS;
tab <- read.table(file="$orwei", sep="\\t", header=TRUE)
library(ggplot2)
pdf("intervals_$_.pdf")
bp <- ggplot(tab, aes(x=factor(Days_Interval),y=Distance)) + geom_boxplot()
bp
dev.off()
RS

	my $orscript = "$_\.Rscript.R";
	die "$orscript $!\n" unless open(T, ">$orscript");
	print T "$rfile"; close T;

	`R CMD BATCH $orscript`;

chdir "..";
	
}
close I;



