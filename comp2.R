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



#### Visualization: first set of graphs to explore ####
source('plotting.R')



#### Saving plots ####
source('plotggsave.r')



#### CODE TRASH BIN ####


# plot_sz_rel_emp <- ggplot(d_size_all, aes(y=d_size_all %>% group_by(country, year) %>% 
#                                             
#                                             x=year, colour=country))
#                   +geom_line(size=1)+facet_grid(.~szclass)+theme_bw()
# 
# print(plot_size_emp_20e);print(plot_size_emp_all); print(plot_sz_rel_emp)
# 
# 
# plot_avg_sectsize <- ggplot(data=d_ind_all %>% group_by(country,mac_sector,year) %>%
#                               summarise(avg_size=sum(szclass*l_count)/sum(l_count)),
#                             aes(x=year, y=avg_size))+geom_line(size=1, colour='blue') + theme_bw()+facet_wrap(~mac_sector)
# plot_avg_sectsize
# 
# 
# plot_avg_sz1 <- ggplot(data=d_size_all %>% group_by(country, year) %>% 
#                         subset(szclass==3) %>% 
#                         summarise(avg_size=sum(l_count)),
#                         aes(x=year, y=avg_size))+geom_line(size=1, colour='blue') + theme_bw()+facet_wrap(~country)#+stat_smooth()
# plot_avg_sz1

# # older graphs
# 
# plot_size_emp_20e <- ggplot(descriptive_size_20e, aes(y=log(tot_l), x=year, colour=country))+
#   geom_line(size=1)+facet_grid(.~szclass)+theme_bw()
# 
# plot_size_emp_all <- ggplot(d_size_all, aes(y=log(tot_l), x=year, colour=country))+
#   geom_line(size=1)+facet_grid(.~szclass)+theme_bw()
# 
# plot_macsec_20e <- ggplot(descriptive_macsec, aes(y=absconstrained, x=year, colour=country))+geom_point()+
#  facet_grid(.~mac_sector)+theme_bw()