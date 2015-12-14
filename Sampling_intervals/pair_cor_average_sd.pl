#!/usr/bin/perl -w
use strict;

die "perl $0 <r.list>\n" unless (@ARGV == 1);
die "$!\n" unless open(I,"$ARGV[0]");


my %allcor; #this is the hash->hash->hash
my %allpair;


my $index = 1;
while(<I>){
	chomp;
	die "$_" unless open(TEM, "$_");
	my @tes = split("_",$_);
	my @na = split(/\./,$_);
	my $tindex = "Time$index\_$na[2]";
	
	my $head = <TEM>; chomp($head);
	my  @h = split(/\,/,$head);
	#print "$#h\n";
	while(<TEM>){
		chomp;
		my @pa = split /\,/;
		#print "$#pa\n";
		for(my $i = 1; $i <= $#pa; $i++){			
			my @temp = ();
			push @temp, $pa[0]; push @temp, $h[$i];
			@temp = sort @temp;
			my $cor = join("_",@temp);
			$allpair{$cor}{$tindex} = $pa[$i];
				
			$allcor{$tindex}{$pa[0]}{$h[$i]} = $pa[$i];
			#die;
		}
	}	
	close TEM;
	$index ++;
}#
close I;

my %select;

for my $pk (sort keys %allpair){
	my @outline = ();
	print "$pk";
	push @outline, $pk;
	my @allone = ();
	for my $tseq (sort keys %{$allpair{$pk}}){
		print "\t$allpair{$pk}{$tseq}";
		push @allone, $allpair{$pk}{$tseq};
		push @outline, $allpair{$pk}{$tseq};
	}

	my $ave = &average(@allone);
	my $sd = &stdev(@allone);
	if($sd >= 0.01){
		my @tem = split("_", $pk);
		foreach(@tem){
			$select{$_} = 1;
		}
	}

=head
	#Significant in Daily however do not significant in weekly biweekly and monthly
	if($allone[0] < 0.6 && $allone[0] > -0.6){
		shift @allone;
		my $av = &average(@allone);
		if($av >= 0.7 || $av <= -0.7){
			my $op = join("\t", @outline, $av);
			#print "$op\n";
		}
	}
=cut
	print "\t$ave\t$sd\n";
	
}
 
=head
for my $tk (sort keys %allcor){
	for my $otu1 (sort keys %{$allcor{$tk}}){
		for my $otu2 (sort keys %{$allcor{$tk}{$otu1}}){
			if(exists $select{$otu1} && exists $select{$otu2}){
				print "$tk,$otu1,$otu2,$allcor{$tk}{$otu1}{$otu2}\n";
			}			

		}
	}
}
=cut

sub average{
        my @data = @_;
        my $total = 0;
        foreach (@data) {
                $total += $_;
        }
        my $average = $total / @data;
        return $average;
}
sub stdev{
        my @data = @_;
       
        my $average = &average(@data);
        my $sqtotal = 0;
        foreach(@data) {
                $sqtotal += ($average-$_) ** 2;
        }
        my $std = ($sqtotal / (@data-1)) ** 0.5;
        return $std;
}

1;
#__END__
