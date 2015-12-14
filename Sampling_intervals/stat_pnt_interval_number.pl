#!/usr/bin/perl
use strict;

die "perl $0 <List>\n" unless(@ARGV == 1);
die "$!\n" unless open(I,"$ARGV[0]");
print "id\tinterval\tpositvie\tnegative\ttotal\n";
my $index =1;
while(<I>){
	chomp;
	my @s = split(/\./, $_);
	my $id = $s[2];
	my $ind = (split("-", $s[2]))[0];
	#print "$id\n";
	my $op = "Time_P_$index";
	my $on = "Time_N_$index";
		
	my %pn;
	die "$!\n" unless open(T,"$_");
	<T>;
	my $cp = 0;
	my $ct = 0;
	my $cn = 0;
	while(<T>){
		chomp; 
		my @ss = split /\,/;
		shift @ss;
		foreach (@ss){
			if($_ != 0 && $_ != 1 && ($_ <= -0.4 || $_ >= 0.4)){
				if($_ > 0 ){
					$pn{$op}{$_} = 1; 
					$cp ++;
				}else{
					$pn{$on}{$_} = 1;
					$cn ++;
				}
				$ct ++;
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

	#print "$op\t$cp\n$on\t$cn\n";
	$cp = $cp/2; $cn = $cn/2; $ct = $ct/2;
	
	my $o = join("\t", $cp, $cn, $ct);
	print "$id\t$ind\t$o\n";
	%pn = ();
	$index ++;
	#die;
}
close I;
