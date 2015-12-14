#hkulg209-AS time series microbial community
The scripts were used to analysis time series microbial community data in environmental biotechnology lab of HKU.

##Phylum stability analysis

For each phylum, we calculate the Bray-Curtis distance between differnt days with differnt intervals to observe the stability/variation of that phylum in a time course.  

We used scripts in phylum_stability to do this analysis. QIIME scripts were used while extracting the biom files of that phylum for every single time so before using these scripts to perform this analysis, the QIIME v1.8 should be installed on your services correctly.  

Before using the scripts, two files should be prepared: 1> the phylum list file contains all the phylum you want to observe; 2> the days intervals files for your sampling. Examples of our daily collected samples could be referred to folder "phylum_stability"  
Just running the following command. The rep.tre was the tree file generated by QIIME; otu.biom file was the OTUs table obtained by QIIME  

    perl phyla_dynamics.pipe.pl <phyla.txt> <otu.biom> <datelist.txt> <rep.tre>  

The above script will call the script "betadiversity_distribution.pl"  
After running, in each phylum folder generated, there would be a file end with suffix stability.txt, this was the phyla dynamics results, which was used to plot the dynamics of this phylum against temporal course. 
    


##Assessing influence of time intervals on correlation coefficient

This analysis was done by scripts in "Sampling_intervals"

1. Generate all possible sampling for different time intervals iteratively using the following Perl script "generate_all_possible_sampling_calculate_spearman.pl" this script will used another script "insilic_sampling_intervals.pl" to generate the matrix for each interval.

2. Statistic the average and standard deviation for each intervals, e.g. for intervals 15
there should be 14 sampling iteratively overall, we calculate all the correlation coefficent
for each pair of OTUs and used these data to generate average and standard deviation
perl pair_cor_average_sd.pl <r.list>

The r.list file was the list correlation coefficient matrix in one text file

