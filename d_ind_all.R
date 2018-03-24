# Imports and merges two datasets, 4th and 5th releases of the CompNet data,
# merges them in a unique dataset. data present the full sample at a 
# country-size-class-NACE2 industry level of aggregation, 
# this dataset is good for less aggregated, sophisticated investigation


###### Full DB import #####

# 5th
full_ind <- read.dta13(file.path(working, 'descriptive_all_countries_macsec_szclass_all.dta')) %>%  as_tibble()

# 4th
full_ind_2012 <- read.dta13(file.path(working, 'descriptive_all_countries_macsec_szclass_all_2012.dta')) %>%  as_tibble() %>% 
  select(-WW_count, -WW, -DIV_min, -cash_flow_ta_min, -cash_holdings_min, -collateral_min, 
         -debt_burd_min, -depr_k_min, -equity_debt_min, -equity_ratio_min, -financial_gap_min, 
         -g_DIV_min, -g_cash_flow_ta_min, -g_cash_holdings_min, -g_collateral_min, -g_debt_burd_min, 
         -g_depr_k_min, -g_equity_debt_min, -g_equity_ratio_min, -g_financial_gap_min, -g_implicit_rate_min, 
         -g_inv_turnover_min, -g_invest_ratio_min, -g_kprod_min, -g_l_min, -g_lc_l_min, -g_lc_min,
         -g_leverage_min, -g_lprod_min, -g_lprod_rev_min, -g_mrpk_min, -g_mrpl_min, -g_profitmargin_min,
         -g_rk_l_min, -g_rk_min, -g_roa_min, -g_rturnover_min, -g_rva_min, -g_tfp_min, -g_trade_credit_min,
         -g_trade_debt_min, -g_ulc_min, -g_wageshare_min, -implicit_rate_min, -inv_turnover_min,
         -invest_ratio_min, -kprod_min, -l_min, -lc_l_min, -lc_min, -leverage_min, -lprod_min, -lprod_rev_min,
         -mrpk_min, -mrpl_min, -profitmargin_min, -rk_l_min, -rk_min, -roa_min, -rturnover_min, -rva_min,
         -tfp_min, -trade_credit_min, -trade_debt_min, -ulc_min, -wageshare_min)

# setdiff(names(full_ind_2012), names(full_ind)) -> list of vars missing in full_ind that are present in full_ind_2012

# diffing and sorting
new_info <- anti_join(full_ind_2012, full_ind, c('country', 'mac_sector', 'szclass', 'year'))
full_ind <- rbind(full_ind, new_info) %>% arrange(., country, mac_sector, szclass, year)

##### Selected vars ##### 

d_ind_all <- full_ind %>% 
  select(country, 
         mac_sector,    # NACE2 industry
         szclass,       # size class
         year, 
         tot_l,         # total employment  MEAN
         tot_lc,        # total labour cost per size class, yearly  MEAN
         
         SAFE,          # share of financially constrained firms in the sample  MEAN
         SAFE_count,
         absconstrained, # share of firms affected by fincons when planning inv  MEAN
         absconstrained_count,
         
         # Collateral statistics, growth rates and percentiles
         collateral_count,
         collateral_mean,
         collateral_iqr,
         collateral_ow,
         collateral_p1,
         collateral_p10,
         collateral_p20,
         collateral_p30,
         collateral_p40,
         collateral_p50,
         collateral_p60,
         collateral_p70,
         collateral_p80,
         collateral_p90,
         collateral_p99,
         collateral_sd,
         collateral_skew,
         # growth rate statistics
         g_collateral_count,
         g_collateral_mean,
         g_collateral_iqr,
         g_collateral_ow,
         g_collateral_p1,
         g_collateral_p10,
         g_collateral_p20,
         g_collateral_p30,
         g_collateral_p40,
         g_collateral_p50,
         g_collateral_p50_ow,
         g_collateral_p60,
         g_collateral_p70,
         g_collateral_p80,
         g_collateral_p90,
         g_collateral_p99,
         g_collateral_sd,
         
         # Financial gap data
         financial_gap_count,
         financial_gap_mean,
         financial_gap_iqr,
         financial_gap_ow,
         financial_gap_p1,
         financial_gap_p10,
         financial_gap_p20,
         financial_gap_p30,
         financial_gap_p40,
         financial_gap_p50,
         financial_gap_p60,
         financial_gap_p70,
         financial_gap_p80,
         financial_gap_p90,
         financial_gap_p99,
         financial_gap_sd,
         financial_gap_skew,
         # growth rate statistics
         g_financial_gap_count,
         g_financial_gap_mean,
         g_financial_gap_iqr,
         g_financial_gap_ow,
         g_financial_gap_p1,
         g_financial_gap_p10,
         g_financial_gap_p20,
         g_financial_gap_p30,
         g_financial_gap_p40,
         g_financial_gap_p50,
         g_financial_gap_p50_ow,
         g_financial_gap_p60,
         g_financial_gap_p70,
         g_financial_gap_p80,
         g_financial_gap_p90,
         g_financial_gap_p99,
         g_financial_gap_sd,
         
         
         # interest rate paid on debt, statistics
         implicit_rate_count,
         implicit_rate_mean,
         implicit_rate_iqr,
         implicit_rate_p50,
         implicit_rate_sd,
         implicit_rate_skew,
         # growth rate statistics
         g_implicit_rate_count,
         g_implicit_rate_mean,
         g_implicit_rate_iqr,
         g_implicit_rate_p50,
         g_implicit_rate_sd,
         
         
         # Wage share over value added: statistics 
         wageshare_count,
         wageshare_mean,
         wageshare_iqr,
         wageshare_ow,
         wageshare_p1,
         wageshare_p10,
         wageshare_p20,
         wageshare_p30,
         wageshare_p40,
         wageshare_p50,
         wageshare_p60,
         wageshare_p70,
         wageshare_p80,
         wageshare_p90,
         wageshare_p99,
         wageshare_sd,
         wageshare_skew,
         # growth rate statistics
         g_wageshare_count,
         g_wageshare_mean,
         g_wageshare_iqr,
         g_wageshare_ow,
         g_wageshare_p1,
         g_wageshare_p10,
         g_wageshare_p20,
         g_wageshare_p30,
         g_wageshare_p40,
         g_wageshare_p50,
         g_wageshare_p50_ow,
         g_wageshare_p60,
         g_wageshare_p70,
         g_wageshare_p80,
         g_wageshare_p90,
         g_wageshare_p99,
         g_wageshare_sd,
         
         
         # Labour: labour employed
         l_count,
         l_mean,
         l_iqr,
         l_ow,
         l_p1,
         l_p10,
         l_p20,
         l_p30,
         l_p40,
         l_p50,
         l_p60,
         l_p70,
         l_p80,
         l_p90,
         l_p99,
         l_sd,
         l_skew,
         # growth rate statistics
         g_l_count,
         g_l_mean,
         g_l_iqr,
         g_l_ow,
         g_l_p1,
         g_l_p10,
         g_l_p20,
         g_l_p30,
         g_l_p40,
         g_l_p50,
         g_l_p50_ow,
         g_l_p60,
         g_l_p70,
         g_l_p80,
         g_l_p90,
         g_l_p99,
         g_l_sd,
         
         
         # Labour cost: nominal labour cost including ss
         lc_count,
         lc_mean,
         lc_iqr,
         lc_ow,
         lc_p1,
         lc_p10,
         lc_p20,
         lc_p30,
         lc_p40,
         lc_p50,
         lc_p60,
         lc_p70,
         lc_p80,
         lc_p90,
         lc_p99,
         lc_sd,
         lc_skew,
         # growth rate statistics
         g_lc_count,
         g_lc_mean,
         g_lc_iqr,
         g_lc_ow,
         g_lc_p1,
         g_lc_p10,
         g_lc_p20,
         g_lc_p30,
         g_lc_p40,
         g_lc_p50,
         g_lc_p50_ow,
         g_lc_p60,
         g_lc_p70,
         g_lc_p80,
         g_lc_p90,
         g_lc_p99,
         g_lc_sd,
         
         
         # labour cost per employee: nominal labour cost over number of employees
         lc_l_count,
         lc_l_mean,
         lc_l_iqr,
         lc_l_ow,
         lc_l_p1,
         lc_l_p10,
         lc_l_p20,
         lc_l_p30,
         lc_l_p40,
         lc_l_p50,
         lc_l_p60,
         lc_l_p70,
         lc_l_p80,
         lc_l_p90,
         lc_l_p99,
         lc_l_sd,
         lc_l_skew,
         # growth rate statistics
         g_lc_l_count,
         g_lc_l_mean,
         g_lc_l_iqr,
         g_lc_l_ow,
         g_lc_l_p1,
         g_lc_l_p10,
         g_lc_l_p20,
         g_lc_l_p30,
         g_lc_l_p40,
         g_lc_l_p50,
         g_lc_l_p50_ow,
         g_lc_l_p60,
         g_lc_l_p70,
         g_lc_l_p80,
         g_lc_l_p90,
         g_lc_l_p99,
         g_lc_l_sd,
         
         
         # unit labour cost: nominal wage bill over value added
         ulc_count,
         ulc_mean,
         ulc_iqr,
         ulc_ow,
         ulc_p1,
         ulc_p10,
         ulc_p20,
         ulc_p30,
         ulc_p40,
         ulc_p50,
         ulc_p60,
         ulc_p70,
         ulc_p80,
         ulc_p90,
         ulc_p99,
         ulc_sd,
         ulc_skew,
         # growth rate statistics
         g_ulc_count,
         g_ulc_mean,
         g_ulc_iqr,
         g_ulc_ow,
         g_ulc_p1,
         g_ulc_p10,
         g_ulc_p20,
         g_ulc_p30,
         g_ulc_p40,
         g_ulc_p50,
         g_ulc_p50_ow,
         g_ulc_p60,
         g_ulc_p70,
         g_ulc_p80,
         g_ulc_p90,
         g_ulc_p99,
         g_ulc_sd
  )

##### New variables #####
# adding relative share of firms' size, by country, size class, macro sector
# this sort of information is good to perform country specific analysis
# a second part, summing over countries should be added later on
d_ind_all <- merge(d_ind_all, d_ind_all %>%
                      group_by(country, year, mac_sector) %>%
                      summarise(country_ind_tot_count=sum(l_count)),
                    by=c('country', 'year', 'mac_sector'))%>%
  arrange(country, mac_sector, szclass, year)
d_ind_all$country_ind_rel_share <- d_ind_all$l_count/d_ind_all$country_ind_tot_count


## Full dataset
full_ind <- merge(full_ind, full_ind %>%
                     group_by(country, year, mac_sector) %>%
                     summarise(country_ind_tot_count=sum(l_count)),
                   by=c('country', 'year', 'mac_sector'))%>%
  arrange(country, mac_sector, szclass, year)
full_ind$country_ind_rel_share <- full_ind$l_count/full_ind$country_ind_tot_count

# # relative share of firms within each macrosector
# # sums over countries and is good for sectoral analysis
# d_ind_all <- merge(d_ind_all, d_ind_all %>% 
#                      group_by(year, mac_sector) %>% 
#                      summarise(sect_ind_tot=sum(l_count)),
#                    by=c('year', 'mac_sector')) %>% 
#   arrange(country, mac_sector, szclass, year)
# #d_ind_all$sec_rel_share <- d_ind_all$l_count/d_ind_all$sect_ind_tot
# d_ind_all2 <- full_join(d_ind_all,
#                         d_ind_all %>% group_by(year, mac_sector, szclass) %>% 
#                         summarise(sec_rel_share=l_count*100/sect_ind_tot))

# 
# 
# # adding relative share of firms' size, by macro sector, sizeclass
# d_ind_all <- merge(d_ind_all, d_ind_all %>%
#                      group_by(mac_sector, year) %>%
#                      summarise(mac_tot_count=sum(l_count)),
#                    by=c('year', 'mac_sector'))%>%
#   arrange(country, mac_sector, szclass, year)
# d_ind_all$mac_rel_share <- d_ind_all$l_count/d_ind_all$mac_tot_count
# 
# # adding relative share of firms' employment by size
# d_size_all <- merge(d_size_all, d_size_all %>% 
#                       group_by(country, year) %>% 
#                       summarise(tot_emp=sum(tot_l)),
#                     by=c('country', 'year')) %>% 
#   arrange(country, szclass,year)
# d_size_all$rel_emp_share <- d_size_all$tot_l/d_size_all$tot_emp
# 
# # dynamics of labour cost per worker by country and size
# # normalization needed
# 
# 
# d_size_all <- merge(d_size_all, 
#                     d_size_all %>% 
#                       group_by(country, szclass) %>% 
#                       filter(row_number(year)==1L) %>% 
#                       select(lc_l_mean) %>% 
#                       summarise(lc_l_mean_init=lc_l_mean),
#                     by=c('country', 'szclass'))
# 
# d_size_all <- d_size_all %>% mutate(lc_l_mean_norm=lc_l_mean/lc_l_mean_init)


# creates variable averaging over contries within same year, sector, size class
# the values for collaterals
# d_ind_all <- left_join(d_ind_all,
#                        d_ind_all %>% 
#                           group_by(year, mac_sector, szclass) %>% 
#                           summarise(collateral_mean_macsec=collateral_mean %>% na.omit(.) %>% mean()),
#                        by=c('year', 'mac_sector', 'szclass'))


#### Housekeeping ####

rm(new_info, full_ind_2012)












