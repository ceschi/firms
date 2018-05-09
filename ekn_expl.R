##### Set of explorative regressions #####

### for this section most complete DF are better
### employed, they will possibly extend to other
### DF if they contain the same variables


##### Plain pooled OLS #####
# simple ols with pooled data and factored industry,
# year, country. I add lprod_mean to isolate labour
# productivity effect on a number of measures.
# As y I put routinely unit labour cost (ulc_),
# labour cost (lc_), labour cost per employee (lc_l_).
# As credit var I include collateral, SAFE, leverage,
# cash flow. The intercept is omitted so to let other
# controls absorb heterogeneity.

# declare an aux vector for relevant vars

var.reg <- c('financial_gap_',
             'collateral_',
             'absconstrained_',
             'cash_flow_ta_',
             'cash_holdings_',
             'debt_burd_',
             'equity_debt_',
             'equity_ratio_',
             'implicit_rate_',
             'leverage_')


##### ULC #####
ols_simple_ulc_fingap <- lm(data=full_ind, 
                            formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                              financial_gap_mean + 
                              as.factor(year) + country + mac_sector)

ols_simple_ulc_coll <- lm(data = full_ind,
                          formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                            collateral_mean + 
                            as.factor(year) + country + mac_sector)

ols_simple_ulc_absc <- lm(data = full_ind,
                          formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                            absconstrained + 
                            as.factor(year) + country + mac_sector)

ols_simple_ulc_cashfl <- lm(data = full_ind,
                            formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                              cash_flow_ta_mean + 
                              as.factor(year) + country + mac_sector)

ols_simple_ulc_cashhl <- lm(data = full_ind,
                            formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                              cash_holdings_mean + 
                              as.factor(year) + country + mac_sector)

ols_simple_ulc_debt <- lm(data = full_ind,
                          formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                            debt_burd_mean + 
                            as.factor(year) + country + mac_sector)

ols_simple_ulc_eqdebt <- lm(data = full_ind,
                            formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                              equity_debt_mean + 
                              as.factor(year) + country + mac_sector)

ols_simple_ulc_eqrat <- lm(data = full_ind,
                           formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                             equity_ratio_mean + 
                             as.factor(year) + country + mac_sector)

ols_simple_ulc_r <- lm(data = full_ind,
                       formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                         implicit_rate_mean + 
                         as.factor(year) + country + mac_sector)

ols_simple_ulc_lev <- lm(data = full_ind,
                         formula = ulc_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                           leverage_mean + 
                           as.factor(year) + country + mac_sector)


##### LC_L #####
ols_simple_lc_l_fingap <- lm(data=full_ind, 
                             formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                               financial_gap_mean + 
                               as.factor(year) + country + mac_sector)

ols_simple_lc_l_coll <- lm(data = full_ind,
                           formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                             collateral_mean + 
                             as.factor(year) + country + mac_sector)

ols_simple_lc_l_absc <- lm(data = full_ind,
                           formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                             absconstrained + 
                             as.factor(year) + country + mac_sector)

ols_simple_lc_l_cashfl <- lm(data = full_ind,
                             formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                               cash_flow_ta_mean + 
                               as.factor(year) + country + mac_sector)

ols_simple_lc_l_cashhl <- lm(data = full_ind,
                             formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                               cash_holdings_mean + 
                               as.factor(year) + country + mac_sector)

ols_simple_lc_l_debt <- lm(data = full_ind,
                           formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                             debt_burd_mean + 
                             as.factor(year) + country + mac_sector)

ols_simple_lc_l_eqdebt <- lm(data = full_ind,
                             formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                               equity_debt_mean + 
                               as.factor(year) + country + mac_sector)

ols_simple_lc_l_eqrat <- lm(data = full_ind,
                            formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                              equity_ratio_mean + 
                              as.factor(year) + country + mac_sector)

ols_simple_lc_l_r <- lm(data = full_ind,
                        formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                          implicit_rate_mean + 
                          as.factor(year) + country + mac_sector)

ols_simple_lc_l_lev <- lm(data = full_ind,
                          formula = lc_l_mean ~ 0 + as.factor(szclass) + lprod_mean + 
                            leverage_mean + 
                            as.factor(year) + country + mac_sector)

# A quick look at disperision drivers in the LCL
ols_simple_lc_l_iqr_coll <- lm(data = full_ind,
                               formula = lc_l_iqr ~ 0 + as.factor(szclass) + lprod_iqr + 
                                 collateral_mean +
                                 as.factor(year) + country + mac_sector)



##### PANEL ESTIMATES #####

# reformatting the dataframe to pd.f:
# create a syntetic index combining 
# country and macro sector, called id.var

plm_ind <- full_ind %>%
  mutate(id.var = group_indices( ., country, mac_sector)) %>%
  pdata.frame(index='id.var')

# Panel Regressions

plm_lc_l_coll <- plm(plm_ind,
    formula = lc_l_mean ~ as.factor(szclass) + lprod_mean  + collateral_mean,
    index = c('id.var'),
    model="within", # fixed effects
    effect='twoways' # time and id FE
)


# using lfe::felm allows for fast, clusterable FE estimation
# I employ year FE and industry FE, plus country-level St.Err. clustering.
# Given data aggregation one cannot add the full set of FE: moreover
# a country FE absorbs a big chunk of the variation, so I decide to
# exploit this cross country variability and consider it while clustering
lfe_coll <- felm(data = full_ind, formula = lc_l_mean ~ collateral_mean +as.factor(szclass) + lprod_mean
     | year + mac_sector | 0 | country + szclass, 
     exactDOF=T)


# using rebased to first obs variables
# grouping for country, sector, size class
# so no need for relative fixed effects
# Run in log and on levels

lfe_coll_rebased_lvl <- felm(data=full_ind,
                             formula = lc_l_mean_rebased ~ 0 + collateral_mean_rebased + lprod_mean_rebased
                             | year | 0 | year,
                             exactDOF = T)



lfe_coll_rebased_log <- felm(data=full_ind,
                         formula = log(lc_l_mean_rebased) ~ 0 + log(collateral_mean_rebased) + log(lprod_mean_rebased) 
                         | year | 0 | year,
                         exactDOF = T)

lfe_coll_rebased_lvl_sz <- 1:5 %>% as.character() %>% as.list()
lfe_coll_rebased_log_sz <- lfe_coll_rebased_lvl_sz

for (i in 1:5){
  lfe_coll_rebased_lvl_sz[[as.character(i)]] <- felm(data=full_ind %>% filter(szclass==i),
                                                     formula = lc_l_mean_rebased ~ 0 + collateral_mean_rebased + lprod_mean_rebased
                                                     | year | 0 | year,
                                                     exactDOF = T)
  
  lfe_coll_rebased_lvl_sz[[as.character(i)]] <- felm(data=full_ind %>% filter(szclass==i),
                                                     formula = log(lc_l_mean_rebased) ~ 0 + log(collateral_mean_rebased) + log(lprod_mean_rebased) 
                                                     | year | 0 | year,
                                                     exactDOF = T)
}





regressions <- list(
  ols=list(
    ulc_mean=list(
                ols_simple_ulc_absc,
                ols_simple_ulc_cashfl,
                ols_simple_ulc_cashhl,
                ols_simple_ulc_coll,
                ols_simple_ulc_debt,
                ols_simple_ulc_eqdebt,
                ols_simple_ulc_eqrat,
                ols_simple_ulc_fingap,
                ols_simple_ulc_lev,
                ols_simple_ulc_r
    ),
    lc_l_mean=list(
                  ols_simple_lc_l_absc,
                  ols_simple_lc_l_cashfl,
                  ols_simple_lc_l_cashhl,
                  ols_simple_lc_l_coll,
                  ols_simple_lc_l_debt,
                  ols_simple_lc_l_eqdebt,
                  ols_simple_lc_l_eqrat,
                  ols_simple_lc_l_fingap,
                  ols_simple_lc_l_lev,
                  ols_simple_lc_l_r
                  ),
    lc_l_iqr=list(ols_simple_lc_l_iqr_coll
                  )
  ),
  # plm=list(
  #   plm_lc_l_coll
  #         ),
  felm=list(
            lfe_coll,
            lfe_coll_rebased_lvl,
            lfe_coll_rebased_log,
            lfe_coll_rebased_lvl_sz,
            lfe_coll_rebased_log_sz
           )
)






# housekeeping
rm(
  ols_simple_lc_l_absc,
  ols_simple_lc_l_cashfl,
  ols_simple_lc_l_cashhl,
  ols_simple_lc_l_coll,
  ols_simple_lc_l_debt,
  ols_simple_lc_l_eqdebt,
  ols_simple_lc_l_eqrat,
  ols_simple_lc_l_fingap,
  ols_simple_lc_l_lev,
  ols_simple_lc_l_r,
  ols_simple_lc_l_iqr_coll,
  ols_simple_ulc_absc,
  ols_simple_ulc_cashfl,
  ols_simple_ulc_cashhl,
  ols_simple_ulc_coll,
  ols_simple_ulc_debt,
  ols_simple_ulc_eqdebt,
  ols_simple_ulc_eqrat,
  ols_simple_ulc_fingap,
  ols_simple_ulc_lev,
  ols_simple_ulc_r,
  plm_lc_l_coll,
  lfe_coll,
  lfe_coll_rebased_lvl,
  lfe_coll_rebased_log,
  lfe_coll_rebased_lvl_sz,
  lfe_coll_rebased_log_sz
)
gc()
















