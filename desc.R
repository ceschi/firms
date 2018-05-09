# Imports and merges two datasets, 4th and 5th releases of the CompNet data,
# merges them in a unique dataset. data present the full sample at a 
# country-size class level of aggregation, 
# this dataset is good for aggregated, preliminary investigation


###### Full DB import #####

# 5th
full_descr <- read.dta13(file.path(working, 'descriptive_all_countries_country_szclass_all.dta')) %>%  as_tibble()

# 4th
full_descr_2012 <- read.dta13(file.path(working, 'descriptive_all_countries_country_szclass_all_2012.dta')) %>%  as_tibble() %>% 
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

# diffing and sorting
new_info <- anti_join(full_descr_2012, full_descr, c('year', 'country', 'szclass'))
full_descr <- rbind(full_descr, new_info) %>% arrange(., year, country, szclass)


nomi <- c('year', 'country', 'szclass')
altrinomi <- setdiff(names(full_descr), nomi)

full_descr <- full_descr[,c(nomi,altrinomi)]
full_descr <- full_descr %>% arrange(year, country, szclass)

##### New variables #####

# adding relative share of firms' size
full_descr <- merge(full_descr, full_descr %>% 
                      group_by(country, year) %>% 
                      summarise(size_tot_count=sum(l_count)),
                    by=c('country', 'year'))%>% 
  arrange(year, country, szclass)
full_descr <- full_descr %>% mutate(size_rel_share = l_count/size_tot_count)

# adding relative share of firms' employment by size
full_descr <- merge(full_descr, full_descr %>% 
                      group_by(country, year) %>% 
                      summarise(tot_emp=sum(tot_l)),
                    by=c('country', 'year')) %>% 
  arrange(country, szclass,year)
full_descr <- full_descr %>% mutate(rel_emp_share = tot_l/tot_emp)

# dynamics of labour cost per worker by country and size
# normalization needed

full_descr <- merge(full_descr, 
                    full_descr %>% 
                      group_by(country, szclass) %>% 
                      filter(row_number(year)==1L) %>% 
                      select(lc_l_mean) %>% 
                      summarise(lc_l_mean_init=lc_l_mean),
                    by=c('country', 'szclass'))

full_descr <- full_descr %>% mutate(lc_l_mean_norm=lc_l_mean/lc_l_mean_init)


# reproducing labour cost per employee
full_descr <- full_descr %>% mutate(lcl_mean = lc_mean/l_mean)



#### Housekeeping ####

full_descr <- full_descr %>%  ungroup()

rm(new_info, full_descr_2012, nomi, altrinomi)
gc()
