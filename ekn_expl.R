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
ols_simple_lc_l_iqr_



##### PANEL ESTIMATES #####
# reformatting the dataframe to pd.f

plm_ind <- full_ind %>%  mutate(id.var=group_indices( full_ind, country, mac_sector, szclass)) %>% pdata.frame(index='id.var')


plm(plm_ind, index=c('year', 'id.var'), formula= lc_l_mean ~ as.factor(szclass) + lprod_mean  + collateral_mean + as.factor(year) + mac_sector + country, model="within", effect='twoways') %>% summary()





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
    lc_l_iqr=list(
      
    )
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
)













