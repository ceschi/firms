##### COMPNET DATA ANALYSIS #####
# chosen slice of data is descriptive_all_countries_country_szclass_all.dta
# which contains descriptive statistics and has a granular level of firm 
# size within each sector

#### Loading packages, functions, directories ####




#### Dictionary to interpret variable names #####

# suffixes:
#   _count - number of firms used to compute statistics in such class
#   _iqr - interquartile range, a measure of dispersion
#   _pXX - percentile, different bins 
#   _sd - standard deviation
#   _mean - mean of the firms
#   _skew - skewness
# 
# prefixes:
#   g_ - growth rate of such variable

#### Setting up the environment #####
source('dirfunc.R')


#### Importing and tidying EU data ####

source('d_size_all.r')
# picks 'descriptive_all_countries_country_szclass_all.dta' and imports selected columns,
# data present the full sample at a country-size-class level of aggregation, no industry involved
# this dataset is good for aggregated, preliminary investigation
# Produces also relative shares of employment by firm size and
# relative shares of firms' population by size


source('d_ind_all.r')
# picks 'descriptive_all_countries_macsec_szclass_all.dta' and imports selected columns,
# data present the full sample at a country-size-class-NACE2 industry level of aggregation, 
# this dataset is good for less aggregated, sophisticated investigation

# !!!!!! Add conversion of year column to date
# !!!!!! Add relative vars in d_ind_all dataset

##### Scraping and tidying QCEW data ####

##### Import WDN data #####
source('wdn.R')


##### Exploratory panel regressions #####
#source('ekn_expl.R')


#### Visualization: first set of graphs to explore ####
source('plotting.R')



#### Saving plots ####
source('plotggsave.r')