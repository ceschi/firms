#### CompNet Data Analyses ####
#### data tidying file ####

#### Load pkgs ####
rm(list=ls())

library('readstata13')
library('ggplot2')
library('dplyr')
library('magrittr')

#### preliminaries ####

working <- getwd()
graphs_dir <- file.path(working, 'Plots')
dir.create(graphs_dir)

#### import data ####

# there are multiple files containing the data,
# our first goal is to assemble a unique database
# to perform our analyses


descriptive_size_20e <- read.dta13(file.path(working, 'descriptive_all_countries_country_szclass_20e.dta')) %>%  as_tibble() %>% 
  select(country, 
         szclass,       # size class
         year, 
         tot_l,         # total employment
         tot_lc,        # total labour cost per size class, yearly
         SAFE,          # share of financially constrained firms in the sample
         absconstrained # share of firms affected by fincons when planning inv
  )
# picks 'descriptive_all_countries_country_szclass_20e.dta' and imports selected columns,
# the file slices the data along the firm size dimension, without sectoral or industrial detail.
# The smaller sample makes so that lower two size classes are excluded

descriptive_size_all <- read.dta13(file.path(working, 'descriptive_all_countries_country_szclass_all.dta')) %>%  as_tibble() %>% 
  select(country, 
         szclass,       # size class
         year, 
         tot_l,         # total employment
         tot_lc,        # total labour cost per size class, yearly
         SAFE,          # share of financially constrained firms in the sample
         absconstrained # share of firms affected by fincons when planning inv
  )
# picks 'descriptive_all_countries_country_szclass_20e.dta' and imports selected columns,
# data sliced as above but with the full 5 size classes range

descriptive_sec <- read.dta13(file.path(working, 'descriptive_all_countries_sec_20e.dta')) %>%  as_tibble() %>% 
  select(country,
         sector,
         year,
         tot_l,
         tot_lc,
         SAFE,
         absconstrained
  )
# picks 'descriptive_all_countries_sec_20e.dta' and imports selected columns, 
# data for smaller sample with information on the NACE 2 detail level

descriptive_macsec <- read.dta13(file.path(working, 'descriptive_all_countries_macsec_szclass_20e.dta'))  %>%  as_tibble()%>% 
  select(country,
         mac_sector,
         year,
         tot_l,
         tot_lc,
         SAFE,
         absconstrained
  )
# picks 'descriptive_all_countries_macsec_szclass_20e.dta' and imports selected columns,
# data for smaller sample, binned in size classes and macrosector

labour_macsec <- read.dta13(file.path(working, 'Labour_l_all_countries_macsec_20e.dta'))  %>%  as_tibble() %>% 
  select(country,
         mac_sector,
         year,
         tot_l,
         tot_lc,
         SAFE,
         absconstrained
  )
# picks 'Labour_l_all_countries_macsec_20e.dta' and imports selected columns
# this data cut contains labour indicators in principle

total_emp = descriptive_size_all %>% group_by(country, year) %>%  summarise(total_emp=sum(tot_l))
# computes total employment by country and by year

descr_sz_all <- merge(descriptive_size_all, total_emp,
                      by=c('country', 'year')
                      # merging along country and year
) %>% 
  arrange(country, szclass, year)
# sorting

descr_sz_all$rel_emp <- 100*descr_sz_all$tot_l/descr_sz_all$total_emp



#### Data vis ####

plot_size_emp_20e <- ggplot(descriptive_size_20e, aes(y=log(tot_l), x=year, colour=country))+
  geom_line(size=1)+facet_grid(.~szclass)+theme_bw()

plot_size_emp_all <- ggplot(descriptive_size_all, aes(y=log(tot_l), x=year, colour=country))+
  geom_line(size=1)+facet_grid(.~szclass)+theme_bw()

# plot_macsec_20e <- ggplot(descriptive_macsec, aes(y=absconstrained, x=year, colour=country))+geom_point()+
#   facet_grid(.~mac_sector)+theme_bw()

plot_sz_rel_emp <- ggplot(descr_sz_all, aes(y=rel_emp, x=year, colour=country))+
  geom_line(size=1)+facet_grid(.~szclass)+theme_bw()

print(plot_size_emp_20e);print(plot_size_emp_all); print(plot_sz_rel_emp)


#### Saving plots ####
ggsave('size_emp_20e.pdf', plot_size_emp_20e,'pdf', graphs_dir)
ggsave('size_emp_all.pdf', plot_size_emp_all, 'pdf', graphs_dir)
ggsave('sz_rel_emp.pdf', plot_sz_rel_emp, 'pdf', graphs_dir)


#### housekeeping ####
rm(total_emp
   
)









