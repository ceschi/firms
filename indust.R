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

nomi <- c('year', 'country', 'mac_sector', 'szclass')
altrinomi <- setdiff(names(full_ind), nomi)


full_ind <- full_ind[,c(nomi,altrinomi)]
full_ind <- full_ind %>% arrange(year, country, mac_sector, szclass)

##### New variables #####
# adding relative share of firms' size, by country, size class, macro sector
# this sort of information is good to perform country specific analysis
# a second part, summing over countries should be added later on


full_ind <- merge(full_ind, full_ind %>%
                     group_by(country, year, mac_sector) %>%
                     summarise(country_ind_tot_count=sum(l_count)),
                   by=c('country', 'year', 'mac_sector'))%>%
  arrange(country, mac_sector, szclass, year)
full_ind <- full_ind %>% mutate(country_ind_rel_share = l_count/country_ind_tot_count)

# adding relative share of firms' size, by macro sector, sizeclass
full_ind <- merge(full_ind, full_ind %>%
                     group_by(mac_sector, year) %>%
                     summarise(mac_tot_count=sum(l_count)),
                   by=c('year', 'mac_sector'))%>%
  arrange(country, mac_sector, szclass, year)
full_ind <- full_ind %>% mutate(mac_rel_share = l_count/mac_tot_count)


# raw measure of labour cost per employee
full_ind <- full_ind %>% mutate(lcl_mean = lc_mean/l_mean)

# select and store mean/median of cross-sector mean/median for each country vars.
# ideally render this a funct and map over a list of financial vars
temp_ind <- full_ind %>% group_by(country, szclass, year) %>% 
            summarise(collateral_mean_crossect=mean(na.omit(collateral_mean))) %>% 
            mutate(collateral_mean_crossect_first=first(collateral_mean_crossect))

temp_ind_bis <- full_ind %>% group_by(country, szclass, year) %>% 
  summarise(lc_l_mean_crossect=mean(na.omit(lc_l_mean))) %>% 
  mutate(lc_l_mean_crossect_first=first(lc_l_mean_crossect))
            
full_ind <- full_join(full_ind, temp_ind, by=c('year', 'country', 'szclass'))
full_ind <- full_join(full_ind, temp_ind_bis, by=c('year', 'country', 'szclass'))


##### Rebasing variables #####
# Rebasing of vars to first obs=1
# this washes levels effect for each country,
# does it kill variation?

# in alternative, use growth rates, 
# already available in the dataset -> yield no
#                                     result whatsoever

full_ind <- full_ind %>% 
  group_by(country, mac_sector, szclass) %>%
  mutate(collateral_mean_rebased = collateral_mean/first(collateral_mean), 
         lc_l_mean_rebased = lc_l_mean/first(lc_l_mean),
         lc_mean_rebased = lc_mean/first(lc_mean),
         lprod_mean_rebased = lprod_mean/first(lprod_mean), 
         lcl_mean_rebased = lcl_mean/first(lcl_mean),
         leverage_mean_rebased = leverage_mean/first(leverage_mean),
         ulc_mean_rebased = ulc_mean/first(ulc_mean),
         cash_flow_ta_mean_rebased = cash_flow_ta_mean/first(cash_flow_ta_mean),
         cash_holdings_mean_rebased = cash_holdings_mean/first(cash_holdings_mean),
         implicit_rate_mean_rebased = implicit_rate_mean/first(implicit_rate_mean))




##### Unconditional distributions #####
# reshaping DF to get additional obs from qtiles
# WARN: these are unconditional distributions for
# each variable

unconditional_vars = list(
# gathering TFP
uncond_tfp = full_ind %>% select(year, country, mac_sector, szclass, 
                                contains('tfp'),-ends_with('_ow'),
                                -ends_with('_iqr'), -ends_with('_sd'),
                                -ends_with('_skew'), -ends_with('_count'),
                                -starts_with('g_')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=tfp, tfp_mean:tfp_p99) %>% 
  mutate(qtiles=gsub('tfp_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('tfp_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering labour cost per employee
uncond_lc_l = full_ind %>% select(year, country, mac_sector, szclass, 
                                 contains('lc_l'),-ends_with('_ow'), 
                                 -ends_with('_iqr'), -ends_with('_sd'),
                                 -ends_with('_skew'), -ends_with('_count'), 
                                 -starts_with('g_'), -contains('crossect')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=lc_l, lc_l_mean:lc_l_p99) %>% 
  mutate(qtiles=gsub('lc_l_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('lc_l_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering labour productivity
uncond_lprod = full_ind %>% select(year, country, mac_sector, szclass, 
                                  contains('lprod'), -ends_with('_ow'), 
                                  -ends_with('_iqr'), -ends_with('_sd'),
                                  -ends_with('_skew'), -ends_with('_count'),
                                  -starts_with('g_'),-contains('rev')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=lprod, lprod_mean:lprod_p99) %>% 
  mutate(qtiles=gsub('lprod_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('lprod_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering unit labour cost
uncond_ulc = full_ind %>% select(year, country, mac_sector, szclass, 
                                contains('ulc'), -ends_with('_ow'), 
                                -ends_with('_iqr'), -ends_with('_sd'),
                                -ends_with('_skew'), -ends_with('_count'),
                                -starts_with('g_')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=ulc, ulc_mean:ulc_p99) %>% 
  mutate(qtiles=gsub('ulc_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('ulc_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 


# gathering collateral ratio
uncond_coll = full_ind %>% select(year, country, mac_sector, szclass, 
                                contains('collateral'), -ends_with('_ow'), 
                                -ends_with('_iqr'), -ends_with('_sd'),
                                -ends_with('_skew'), -ends_with('_count'),
                                -starts_with('g_'), -contains('crossect')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=collateral, collateral_mean:collateral_p99) %>%
  mutate(qtiles=gsub('collateral_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('collateral_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 


# gathering equity/debt ratio
uncond_equity_debt = full_ind %>% select(year, country, mac_sector, szclass, 
                                contains('equity_debt'), -ends_with('_ow'), 
                                -ends_with('_iqr'), -ends_with('_sd'),
                                -ends_with('_skew'), -ends_with('_count'),
                                -starts_with('g_')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=equity_debt, equity_debt_mean:equity_debt_p99) %>%
  mutate(qtiles=gsub('equity_debt_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('equity_debt_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering cash holdings
uncond_cashhold = full_ind %>% select(year, country, mac_sector, szclass, 
                                contains('cash_holdings'),-ends_with('_ow'),
                                -ends_with('_iqr'), -ends_with('_sd'),
                                -ends_with('_skew'), -ends_with('_count'),
                                -starts_with('g_')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=cash_holdings, cash_holdings_mean:cash_holdings_p99) %>% 
  mutate(qtiles=gsub('cash_holdings_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('cash_holdings_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering financial gap
uncond_fingap = full_ind %>% select(year, country, mac_sector, szclass, 
                                     contains('financial_gap'),-ends_with('_ow'),
                                     -ends_with('_iqr'), -ends_with('_sd'),
                                     -ends_with('_skew'), -ends_with('_count'),
                                     -starts_with('g_')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=financial_gap, financial_gap_mean:financial_gap_p99) %>% 
  mutate(qtiles=gsub('financial_gap_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('financial_gap_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles),

# gathering labour cost
uncond_lc = full_ind %>% select(year, country, mac_sector, szclass, 
                                   contains('lc'),-ends_with('_ow'),
                                   -ends_with('_iqr'), -ends_with('_sd'),
                                   -ends_with('_skew'), -ends_with('_count'),
                                   -starts_with('g_'), -starts_with('tot'),
                                   -contains('ulc'), -contains('lc_l'),
                                   -contains('lcl')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=lc, lc_mean:lc_p99) %>% 
  mutate(qtiles=gsub('lc_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('lc_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering employment
uncond_l = full_ind %>% select(year, country, mac_sector, szclass, 
                              l_mean, l_p1, l_p10, 
                              l_p20, l_p30, l_p40, 
                              l_p50, l_p60, l_p70, 
                              l_p80, l_p90, l_p99) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=l, l_mean:l_p99) %>% 
  mutate(qtiles=gsub('l_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('l_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering leverage
uncond_leverage = full_ind %>% select(year, country, mac_sector, szclass, 
                                     contains('leverage'),-ends_with('_ow'),
                                     -ends_with('_iqr'), -ends_with('_sd'),
                                     -ends_with('_skew'), -ends_with('_count'),
                                     -starts_with('g_'), -starts_with('tot'),
                                     -contains('ulc'), -contains('lc_l'),
                                     -contains('lcl')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=leverage, leverage_mean:leverage_p99) %>% 
  mutate(qtiles=gsub('leverage_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('leverage_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# wageshare
uncond_wageshare = full_ind %>% select(year, country, mac_sector, szclass, 
                                     contains('wageshare'),-ends_with('_ow'),
                                     -ends_with('_iqr'), -ends_with('_sd'),
                                     -ends_with('_skew'), -ends_with('_count'),
                                     -starts_with('g_'), -starts_with('tot'),
                                     -contains('ulc'), -contains('lc_l'),
                                     -contains('lcl')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=wageshare, wageshare_mean:wageshare_p99) %>% 
  mutate(qtiles=gsub('wageshare_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('wageshare_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering investment ratio
uncond_inv_ratio = full_ind %>% select(year, country, mac_sector, szclass, 
                                      contains('invest_ratio'),-ends_with('_ow'),
                                      -ends_with('_iqr'), -ends_with('_sd'),
                                      -ends_with('_skew'), -ends_with('_count'),
                                      -starts_with('g_'), -starts_with('tot'),
                                      -contains('ulc'), -contains('lc_l'),
                                      -contains('lcl')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=invest_ratio, invest_ratio_mean:invest_ratio_p99) %>% 
  mutate(qtiles=gsub('invest_ratio_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('invest_ratio_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles),

# gathering capital productivity
uncond_kprod = full_ind %>% select(year, country, mac_sector, szclass, 
                                      contains('kprod'),-ends_with('_ow'),
                                      -ends_with('_iqr'), -ends_with('_sd'),
                                      -ends_with('_skew'), -ends_with('_count'),
                                      -starts_with('g_'), -starts_with('tot'),
                                      -contains('ulc'), -contains('lc_l'),
                                      -contains('lcl')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=kprod, kprod_mean:kprod_p99) %>% 
  mutate(qtiles=gsub('kprod_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('kprod_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering rk
uncond_rk = full_ind %>% select(year, country, mac_sector, szclass, 
                                  contains('rk'),-ends_with('_ow'),
                                  -ends_with('_iqr'), -ends_with('_sd'),
                                  -ends_with('_skew'), -ends_with('_count'),
                                  -starts_with('g_'), -starts_with('tot'),
                                  -contains('ulc'), -contains('lc_l'),
                                  -contains('lcl'), -contains('rk_l')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=rk, rk_mean:rk_p99) %>% 
  mutate(qtiles=gsub('rk_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('rk_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering labour productivty based on revenues
uncond_lprod_rev = full_ind %>% select(year, country, mac_sector, szclass, 
                                  contains('lprod_rev'),-ends_with('_ow'),
                                  -ends_with('_iqr'), -ends_with('_sd'),
                                  -ends_with('_skew'), -ends_with('_count'),
                                  -starts_with('g_'), -starts_with('tot'),
                                  -contains('ulc'), -contains('lc_l'),
                                  -contains('lcl'), -contains('rk_l')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=lprod_rev, lprod_rev_mean:lprod_rev_p99) %>% 
  mutate(qtiles=gsub('lprod_rev_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('lprod_rev_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles),

# gathering marginal product of capital
uncond_mrpk = full_ind %>% select(year, country, mac_sector, szclass, 
                                 contains('mrpk'),-ends_with('_ow'),
                                 -ends_with('_iqr'), -ends_with('_sd'),
                                 -ends_with('_skew'), -ends_with('_count'),
                                 -starts_with('g_'), -starts_with('tot'),
                                 -contains('ulc'), -contains('lc_l'),
                                 -contains('lcl'), -contains('rk_l')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=mrpk, mrpk_mean:mrpk_p99) %>% 
  mutate(qtiles=gsub('mrpk_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('mrpk_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 


# gathering marginal product of labour
uncond_mrpl = full_ind %>% select(year, country, mac_sector, szclass, 
                                 contains('mrpl'),-ends_with('_ow'),
                                 -ends_with('_iqr'), -ends_with('_sd'),
                                 -ends_with('_skew'), -ends_with('_count'),
                                 -starts_with('g_'), -starts_with('tot'),
                                 -contains('ulc'), -contains('lc_l'),
                                 -contains('lcl'), -contains('rk_l')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=mrpl, mrpl_mean:mrpl_p99) %>% 
  mutate(qtiles=gsub('mrpl_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('mrpl_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles), 

# gathering capital intensity
uncond_rk_l = full_ind %>% select(year, country, mac_sector, szclass, 
                                 contains('rk_l'),-ends_with('_ow'),
                                 -ends_with('_iqr'), -ends_with('_sd'),
                                 -ends_with('_skew'), -ends_with('_count'),
                                 -starts_with('g_'), -starts_with('tot'),
                                 -contains('ulc'), -contains('lc_l'),
                                 -contains('lcl')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=rk_l, rk_l_mean:rk_l_p99) %>% 
  mutate(qtiles=gsub('rk_l_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('rk_l_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles),

# gathering return on assets
uncond_roa = full_ind %>% select(year, country, mac_sector, szclass, 
                                 contains('roa'),-ends_with('_ow'),
                                 -ends_with('_iqr'), -ends_with('_sd'),
                                 -ends_with('_skew'), -ends_with('_count'),
                                 -starts_with('g_'), -starts_with('tot'),
                                 -contains('ulc'), -contains('lc_l'),
                                 -contains('lcl')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=roa, roa_mean:roa_p99) %>% 
  mutate(qtiles=gsub('roa_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('roa_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles),

# gathering real turnover
uncond_rturnover = full_ind %>% select(year, country, mac_sector, szclass, 
                                contains('rturnover'),-ends_with('_ow'),
                                -ends_with('_iqr'), -ends_with('_sd'),
                                -ends_with('_skew'), -ends_with('_count'),
                                -starts_with('g_'), -starts_with('tot'),
                                -contains('ulc'), -contains('lc_l'),
                                -contains('lcl')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=rturnover, rturnover_mean:rturnover_p99) %>% 
  mutate(qtiles=gsub('rturnover_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('rturnover_mean', 'mean', qtiles))%>% 
  arrange(year, country, mac_sector, szclass, qtiles),


# gathering real value added
uncond_rva = full_ind %>% select(year, country, mac_sector, szclass, 
                                      contains('rva'),-ends_with('_ow'),
                                      -ends_with('_iqr'), -ends_with('_sd'),
                                      -ends_with('_skew'), -ends_with('_count'),
                                      -starts_with('g_'), -starts_with('tot'),
                                      -contains('ulc'), -contains('lc_l'),
                                      -contains('lcl')) %>%
  group_by(year, country, mac_sector, szclass) %>% 
  gather(key = qtiles, value=rva, rva_mean:rva_p99) %>% 
  mutate(qtiles=gsub('rva_p', 'P', qtiles)) %>% 
  mutate(qtiles=gsub('rva_mean', 'mean', qtiles)) %>% 
  arrange(year, country, mac_sector, szclass, qtiles)
)


#### Housekeeping ####

full_ind <- full_ind %>%  ungroup()

full_ind <- full_ind %>% mutate(year = as.factor(year),
                                szclass = as.factor(szclass),
                                country = as.factor(country))


rm(new_info, full_ind_2012, temp_ind, temp_ind_bis, nomi, altrinomi)
gc()