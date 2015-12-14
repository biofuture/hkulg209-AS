#!/usr/bin/perl -w
use strict;

##This program do sampling from daily samples 
##Get monthly samples/biweekly samples/weekly samples/any samples with a defined time window
##
##The input is a daily sample OTUs table with two extra line (total days from the first day) days interval from
##the previous day
##any days are compared with the first day of sampling


die "perl $0 <date.list> <sample interval>  <sample times> <OTUs table>\n" unless (@ARGV == 4);

##weekly number
my $inter = $ARGV[1];
my $times = $ARGV[2];
##All the possible weekly sampling methods for all these daily data
my %week;
for(my $shift = 1; $shift <= ($inter -1); $shift++ ){
	for(my $i=0; $i <= $times; $i++){
		my $o = $inter * $i + $shift;
		$week{$shift}{$o} = 1;
	}
}

=head
my @biweek;
$inter = 14;
for(my $i=0; $i <= 18; $i++){
        my $o = $inter * $i + 1;
        push @biweek, $o;
}

my @month;
$inter = 30;
for(my $i=0; $i <= 9; $i++){
        my $o = $inter * $i + 1;
        push @month, $o;
}
=cut

my %obtain;
die "$! \n" unless open(I,"$ARGV[0]");
<I>;
while(<I>){
	chomp;
	my @tm = split(/\s+/,$_);
	$obtain{$tm[2]} = $tm[0];
}
close I;


die "$! \n" unless open(II,"$ARGV[3]");
my %daysH;
my $head = <II>;
my @mm = split(/\t/, $head,2);
while(<II>){
	chomp;
	my @tm = split(/\t/,$_,2);
	$daysH{$tm[0]} = $_;
}
close II;

my @tes = ();
for my $sf (sort {$a <=> $b} keys %week){
	##For each shift generate a files
	my $of = "$ARGV[3].$inter-$times-$sf.txt";	
	die "$! \n" unless open(TM,">$of");
	#print TM $head;
	print TM "\t$mm[1]";
	for my $v (sort {$a <=> $b} keys %{$week{$sf}} ){
	
		if(exists $obtain{$v}){
			#print TM "$obtain{$v}\t$v\n";
			if(exists $daysH{$obtain{$v}}){
				@tes = split(/\s+/,$daysH{$obtain{$v}}, 2);
				print TM "$tes[0]\t$tes[1]\n";
			}else{
				die "$obtain{$v}";
			}
		}else{
			##find the nearest value to $v in %obatin
			##the value must difference must less than inter				
			my $diff = $inter;
			my $objv = 0;
			my $objn = "";
			my $vars = 0;
				
			for my $kk (keys %obtain){
				$vars = abs($kk - $v);
				if($vars < $diff){
					$diff = $vars;
					$objv = $kk;
					$objn = $obtain{$kk};	
				}
			}
		
			if($objv != 0 && $objn ne "" && $diff < $inter/2){
				
				if(exists $daysH{$objn}){
					@tes = split(/\s+/,$daysH{$objn},2);
					print TM "$tes[0]\t$tes[1]\n";
					#print TM "$daysH{$objn}\n";
				}else{
					die "$objn\n";
				}
				#print TM "$objn\t$objv\n";
			}else{
				#die "Error: $v\t$diff\t$objv\n";
			}
			
		}		
	
	}
	close TM;
	#print "\n************************************************************************\n";
}


