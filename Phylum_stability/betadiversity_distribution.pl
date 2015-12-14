#!/use/bin/perl -w
use strict;


die "perl $0 <Matrix1> <Matrix2> <date.list>\n" unless (@ARGV == 3);



die "$!\n" unless open(Date,"$ARGV[2]");
my %date;
<Date>;
while(<Date>){
	chomp;
	my @tem = split(/\t/, $_);
	$date{$tem[0]} = $tem[2];
}
close Date;

my %dis;
my $wei = "weighted";
my $uwei = "unweighted";


my %days;
my %intervals;

die "$!\n" unless open(I,"$ARGV[0]");
my $h = <I>; chomp($h);
my @names = split(/\t/, $h);

while(<I>){
	chomp;
	my @tems = split(/\t/, $_);
	for(my $i = 1; $i <= $#tems; $i++){
		if($tems[$i] != 0){
			
			my $o = join("-", sort($tems[0], $names[$i]));
			#keep the distribution distance
			$dis{$wei}{$o} = $tems[$i];
			
			#keep the intervals distance
			die "$tems[$i]\n" unless (exists $date{$tems[0]}   &&  exists $date{$names[$i]});

			if($date{$tems[0]} > $date{$names[$i]}){
				my $d =  $date{$tems[0]} - $date{$names[$i]};
				$intervals{$d}{$o}{$wei} = $tems[$i];
			}else{
				my $d = $date{$names[$i]} - $date{$tems[0]};
                                $intervals{$d}{$o}{$wei} = $tems[$i];
			}


			##Keep distance with the first day
			if($tems[0] eq "D20131008"){
				 die "$tems[$i]\n" unless (exists $date{$tems[0]}   &&  exists $date{$names[$i]});
				 my $dist = abs($date{$names[$i]} -  $date{$tems[0]});
				 $days{$dist}{$wei} = $tems[$i];
			}
		}
		
	}
}
close I;




die "$!\n" unless open(II,"$ARGV[1]");
my $head = <II>; chomp($head);
my @names2 = split(/\t/, $head);

while(<II>){
	chomp;
	my @tems = split(/\t/, $_);
	for(my $i = 1; $i <= $#tems; $i++){
		if($tems[$i] != 0){
			
			my $o = join("-", sort($tems[0], $names2[$i]));
			#keep the distribution distance
			$dis{$uwei}{$o} = $tems[$i];
			
			#keep the intervals distance
			die "$tems[$i]\n" unless (exists $date{$tems[0]}   &&  exists $date{$names2[$i]});
			my $d = abs($date{$names2[$i]} -  $date{$tems[0]});
			if($date{$tems[0]} > $date{$names2[$i]}){
				my $d =  $date{$tems[0]} - $date{$names2[$i]};
				$intervals{$d}{$o}{$uwei} = $tems[$i];
			}else{
				my $d = $date{$names2[$i]} - $date{$tems[0]};
                                $intervals{$d}{$o}{$uwei} = $tems[$i];
			}


			##Keep distance with the first day
			if($tems[0] eq "D20131008"){
				 die "$tems[$i]\n" unless (exists $date{$tems[0]}   &&  exists $date{$names2[$i]});
				 my $dist = abs($date{$names2[$i]} -  $date{$tems[0]});
				 $days{$dist}{$uwei} = $tems[$i];
			}
		}
		
	}
}
close II;



##Out put data
=head1
print "UniFrac Distance\tSamples\tDistance\n";
for my $w (sort keys %dis){
	for my $pair (keys %{$dis{$w}}){
		print "$w\t$pair\t$dis{$w}{$pair}\n";
	}	
}
=cut
print "Days_Interval\tSamples\tUniFrac_Distance\tDistance\n";
for my $d (sort {$a <=>  $b} keys %intervals){
	for my $pair (keys %{$intervals{$d}}){
		for my $w ( keys %{$intervals{$d}{$pair}}){
			print "$d\t$pair\t$w\t$intervals{$d}{$pair}{$w}\n";
		}
	}
}

