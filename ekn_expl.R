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



























