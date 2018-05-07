##### COMPNET DATA ANALYSIS #####
# chosen slice of data is descriptive_all_countries_country_szclass_all.dta
# which contains descriptive statistics and has a granular level of firm 
# size within each sector

#### Flags ####

# set to 0 to mute plots,
# set to 1 to print plots
flag___plot = 1



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

source('desc.R')
# picks 'descriptive_all_countries_country_szclass_all.dta' and imports selected columns,
# data present the full sample at a country-size-class level of aggregation, no industry involved
# this dataset is good for aggregated, preliminary investigation
# Produces also relative shares of employment by firm size and
# relative shares of firms' population by size.
# Creates also a richer dataset called full_descr that shall be
# used for sake of simplicity


source('indust.R')
# picks 'descriptive_all_countries_macsec_szclass_all.dta' and imports selected columns,
# data present the full sample at a country-size-class-NACE2 industry level of aggregation, 
# this dataset is good for less aggregated, sophisticated investigation
# Creates also a richer dataset called full_ind that shall be
# used for sake of simplicity

# !!!!!! Add conversion of year column to date
# !!!!!! Add relative vars in d_ind_all dataset


### Vars names without pre- or suffixes
var.list <- list(descr = full_descr%>% 
                   select(-contains('_p'), 
                          -ends_with('_count'), 
                          -ends_with('_skew'), 
                          -ends_with('_sd'), 
                          -ends_with('_iqr'), 
                          -ends_with('_ow'), 
                          -starts_with('g_')) %>%
                   names() %>% 
                   sort(),
                 ind =  full_ind %>% 
                        select(-contains('_p'), 
                          -ends_with('_count'), 
                          -ends_with('_skew'), 
                          -ends_with('_sd'), 
                          -ends_with('_iqr'), 
                          -ends_with('_ow'), 
                          -starts_with('g_')) %>%
                        names() %>% 
                        sort())

##### Scraping and tidying QCEW data ####

##### Import WDN data #####
source('wdn.R')


##### Exploratory panel regressions #####
source('ekn_expl.R')


#### Visualization: first set of graphs to explore ####
source('plotting.R')

