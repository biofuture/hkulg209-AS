#!/usr/bin/perl
use strict;

die "perl $0 <List>\n" unless(@ARGV == 1);
die "$!\n" unless open(I,"$ARGV[0]");
print "time\tspearcor\n";
my $index =1;
while(<I>){
	chomp;
	my $op = "Time_P_$index";
	my $on = "Time_N_$index";
	
	my %pn;
	die "$!\n" unless open(T,"$_");
	<T>;
	my $cp = 0;
	my $cn = 0;
	while(<T>){
		chomp; 
		my @ss = split /\,/;
		shift @ss;
		foreach (@ss){
			if($_ != 0 && $_ != 1 && ($_ >= 0.6 || $_ <= -0.6)){
				if($_ > 0 ){
					$pn{$op}{$_} = 1; 
					$cp ++;
				}else{
					$pn{$on}{$_} = 1;
					$cn ++;
				}
			}
		}

	}
	close T;
	
=head
	for my $t (sort keys %pn){
		for my $v (keys %{$pn{$t}}){
			print "$t\t$v\n";
		}
			
	}
=cut

	print "$op\t$cp\n$on\t$cn\n";
	%pn = ();
	$index ++;
}
close I;
