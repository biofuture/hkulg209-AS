#hkulg209-AS time series microbial community
The scripts were used to analysis time series microbial community data in environmental biotechnology lab of HKU.

##Assessing influence of time intervals on correlation coefficient

This analysis was done by scripts in "Sampling_intervals"

1. Generate all possible sampling for different time intervals iteratively using the following Perl script  
perl generate_all_possible_sampling_calculate_spearman.pl this script will used another script "insilic_sampling_intervals.pl" to generate the matrix for each interval.

2. Statistic the average and standard deviation for each intervals, e.g. for intervals 15
there should be 14 sampling iteratively overall, we calculate all the correlation coefficent
for each pair of OTUs and used these data to generate average and standard deviation
perl pair_cor_average_sd.pl <r.list>

The r.list file was the list correlation coefficient matrix in one text file

##Phylum stability analysis

Firstly Bray-Curtis distance for each phylum in different days were calculated , for example, when analyzed the stability of phylum Proteobacteria,
