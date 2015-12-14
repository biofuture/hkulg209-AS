#!/usr/bin/perl -w
use strict;

die "perl $0 <Intable> <date.list>\n" unless (@ARGV == 2);

my $datelist = $ARGV[1];
my $Intable = $ARGV[0];
my $days = 392;
#iterate from 1 to 15/ at least 25 samples for each experiment
my $op = "all_possible_sample.sh";
die "$!" unless open(T,">$op");

for(my $i = 1; $i <= 30; $i++){
        my $sindex = int($days/$i);
        print T         "perl insilic_sampling_for_banjo.pl $datelist $i $sindex $Intable\n";
}
close T;

##excute $op
my $of = "all_possible_sample.list";
die "$!" unless open(T,">$of");
`sh $op; ls $Intable*-*.txt > $of`;
close T;


##run corr for each file
##Using absolute value to caculate the correlation coefficient to relieave the composition biase
die "$!\n" unless open(I,"$of");
while(<I>){
	chomp;
	my $ofr = "$_\.spearman.rmatrix.r.txt";
	my $tempr="tem.R";
	die "$!\n" unless open(TEM,">$tempr");
	my $sc = <<TEMS;
library(Hmisc)
rtable <- read.table(file="$_", header=TRUE, row.names=1, sep="\\t")
rtable.m <- data.matrix(rtable)
rtab.cor <- rcorr(rtable.m,type="spearman")

matrix.cor.r <-rtab.cor\$r
matrix.cor.p<-rtab.cor\$P
#Multiple testing correction using Benjamini-Hochberg standard false discovery rate correction ("FDR-BH")
matrix.cor.p <- p.adjust(matrix.cor.p, method="BH")

#matrix.cor.r[which(matrix.cor.r>=(-0.6) & matrix.cor.r <= 0.6)]=0
matrix.cor.r[which(matrix.cor.p>0.05)]=0
    
# delete those rows and columns with sum = 0
matrix.cor.r<-matrix.cor.r[which(rowSums(matrix.cor.r)!=0),]
matrix.cor.r<-matrix.cor.r[,which(colSums(matrix.cor.r)!=0)]

write.csv(matrix.cor.r, file="$ofr")

TEMS
	print TEM $sc;
	close TEM;
	`R CMD BATCH $tempr`;

}
close I;
