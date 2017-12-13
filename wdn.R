##### Importing and cleaning WDN data #####




##### First wave of WDN: 2007 ####

# read in data from dta, select variables,
# convert and add year info

wdn07 <- read.dta13(file.path(getwd(), 'WDN_Survey13_fullyharmonized.dta')) %>% 
  as.tibble() %>% 
  select(country,
         sector,
         size,
         # % total wage bill related to bonuses
         C_5,
         # logical: inflation indexed wages?
         C_6,
         # wages indexed to past infl?
         C_7a,
         # wages indexed to exp infl?
         C_7b,
         # wages considers past infl?
         C_7c,
         # wages considers exp infl?
         C_7d,
         # freq wage changes, no tenure no infl
         C_9a,
         # freq wage changes, tenure
         C_9b,
         # freq wage changes, inflation
         C_9c,
         # determinant of entry wage: coll agreement
         C_11a,
         # determinant of entry wage: wage outside
         C_11b,
         # determinant of entry wage: wage inside
         C_11c,
         # determinant of entry wage: availability of similar workers
         C_11d,
         # determinant of entry wage: none
         C_11e,
         # determinant of entry wage: entry wage of similar workers
         C_11f,
         # determinant of entry wage: current wage of similar workers
         C_11g,
         # frozen wage? if yes %
         C_14,
         # wage cut? if yes %
         C_15,
         # reason for cut/freeze: profit/sales fell
         NC_16a,
         # reason for cut/freeze: costs increased
         NC_16b,
         # reason for cut/freeze: jobs risk
         NC_16c,
         # reason for cut/freeze: imposed legisl
         NC_16d,
         # reason for cut/freeze: workers performance
         NC_16e,
         # reason for cut/freeze: other
         NC_16f,
         # wage not cut for: legisl
         C_17a,
         # wage not cut for: morale
         C_17b,
         # wage not cut for: reputation
         C_17c,
         # wage not cut for: spell risk
         C_17d,
         # wage not cut for: hiring costs after spells
         C_17e,
         # wage not cut for: unattractive to new workers
         C_17f,
         # wage not cut for: internal implicit agreement
         C_17g,
         # wage not cut for: workers compare wages
         C_17h,
         # lab cost reduction: bonus cut
         NC_18a,
         # lab cost reduction: nonpay cut
         NC_18b,
         # lab cost reduction: shift change
         NC_18c,
         # lab cost reduction: slow/freeze promotions
         NC_18d,
         # lab cost reduction: cheaper hires
         NC_18e,
         # lab cost reduction: early retirement
         NC_18f,
         # lab cost reduction: other
         NC_18g,
         # lab cost reduction: none of above
         NC_18h,
         # logical: over last decade to adjust lab cost via wages?
         NC_19,
         # demand down strategy: cut prices
         C_21a,
         # demand down strategy: cut margins
         C_21b,
         # demand down strategy: cut output
         C_21c,
         # demand down strategy: cut costs
         C_21d,
         # demand down strategy: freeze prices
         C_21e,
         # demand down strategy: cut prices reducing margins & costs
         C_21f,
         # demand down strategy: cut prices cutting margins
         C_21g,
         # demand down strategy: cut prices cutting costs
         C_21h,
         # conditional on Q21, how wages are affected?
         # cut/freeze/limit pay increases
         C_22a,
         # reducing flexible wage components
         C_22b,
         # cut permanent workers
         C_22c,
         # cut temporary workers
         C_22d,
         # cut hours worked
         C_22e,
         # cut non-labour costs
         C_22f,
         # start outsourcing
         C_22g,
         # reaction to increse in intermediate goods prices
         C_23d,
         # after increase in interm. goods prices, firms cut costs, firm does
         # cut/freeze/reduce pay
         C_24a,
         # cut flex wage component
         C_24b,
         # cut permanent workers
         C_24c,
         # cut temp workers
         C_24d,
         # cut hours worked
         C_24e,
         # cut non-labour costs
         C_24f,
         # start outsourcing
         C_24g,
         # unexpected wage increase strategy: reduce costs
         C_25d,
         # after unexp wage increase firm cuts costs and 
         # cut/freeze/reduce pay
         C_26a,
         # cut flex wage component
         C_26b,
         # cut permanent workers
         C_26c,
         # cut temp workers
         C_26d,
         # cut hours worked
         C_26e,
         # cut base wages
         C_26f,
         # start outsourcing
         C_26g,
         # main prod price set by parent comp etc
         C_28a,
         # main prod price set following competitors
         C_28b,
         # main prod price set according to cost & profit margins
         C_28c,
         # main prod price set other way
         C_28d, 
         # price competition is severe
         NC_29a,
         # price competition is strong
         NC_29b,
         # price competition is weak
         NC_29c,
         # no price competition
         NC_29d,
         # don't know if there's competition
         NC_29e,
         # no answer
         NC_29f,
         # unknown extent of price competition
         NC_29g,
         # competitors cut prices, how likely is to cut prices?
         C_30,
         # main prod price change: daily
         C_31a,
         # main prod price change: weekly
         C_31b,
         # main prod price change: monthly
         C_31d,
         # main prod price change: quarterly
         C_31e,
         # main prod price change: half-yearly
         C_31f,
         # main prod price change: bi-monthly
         C_31c,
         # main prod price change: yearly
         C_31g,
         # main prod price change: less than yearly
         C_31h,
         # main prod price change: never
         C_31i,
         # main prod price change: no pattern
         C_31j,
         # main prod price change: another freq
         C_31k,
         # is there relation between price changes and wage changes?
         C_33,
         # overall empl by the end of ref. period
         C_34,
         # overall empl by the end of ref. period in categories
         C_34a,
         # % empl is permanent full time
         C_34b,
         # % empl is permanent part time
         C_34c,
         # % empl is temporary
         C_34d,
         # % empl is other
         C_34e,
         # first year of activity
         NC_39,
         # % of tot cost due to lab costs
         NC_40,
         # firm revenues this year with respect to last year
         NC_41,
         # unique firm identifier by country
         firm_id
         )



##### Second wave of WDN: 2009 #####

wdn09 <- read.dta13(file.path(getwd(), 'WDN1&WDN2_stata13.dta')) %>% 
  as.tibble() %>% 
  select(country,
         sector,
         size,
         # 1 if firm participated to both waves, 0 otherwise
         flag,
         # % total wage bill related to bonuses
         C_5a,
         # logical: inflation indexed wages?
         C_6,
         # wages indexed to past infl?
         C_7a,
         # wages indexed to exp infl?
         C_7b,
         # wages considers past infl?
         C_7c,
         # wages considers exp infl?
         C_7d,
         # freq wage changes, no tenure no infl
         C_9a,
         # freq wage changes, tenure
         C_9b,
         # freq wage changes, inflation
         C_9c,
         # determinant of entry wage: coll agreement
         C_11a,
         # determinant of entry wage: wage outside
         C_11b,
         # determinant of entry wage: wage inside
         C_11c,
         # determinant of entry wage: availability of similar workers
         C_11d,
         # determinant of entry wage: none
         C_11e,
         # determinant of entry wage: entry wage of similar workers
         C_11f,
         # determinant of entry wage: current wage of similar workers
         C_11g,
         # frozen wage? if yes %
         C_14,
         # wage cut? if yes %
         C_15,
         # reason for cut/freeze: profit/sales fell
         NC_16a,
         # reason for cut/freeze: costs increased
         NC_16b,
         # reason for cut/freeze: jobs risk
         NC_16c,
         # reason for cut/freeze: imposed legisl
         NC_16d,
         # reason for cut/freeze: workers performance
         NC_16e,
         # reason for cut/freeze: other
         NC_16f,
         # wage not cut for: legisl
         C_17a,
         # wage not cut for: morale
         C_17b,
         # wage not cut for: reputation
         C_17c,
         # wage not cut for: spell risk
         C_17d,
         # wage not cut for: hiring costs after spells
         C_17e,
         # wage not cut for: unattractive to new workers
         C_17f,
         # wage not cut for: internal implicit agreement
         C_17g,
         # wage not cut for: workers compare wages
         C_17h,
         # lab cost reduction: bonus cut
         NC_18a,
         # lab cost reduction: nonpay cut
         NC_18b,
         # lab cost reduction: shift change
         NC_18c,
         # lab cost reduction: slow/freeze promotions
         NC_18d,
         # lab cost reduction: cheaper hires
         NC_18e,
         # lab cost reduction: early retirement
         NC_18f,
         # lab cost reduction: other
         NC_18g,
         # lab cost reduction: none of above
         NC_18h,
         # logical: over last decade to adjust lab cost via wages?
         NC_19,
         # demand down strategy: cut prices
         C_21a,
         # demand down strategy: cut margins
         C_21b,
         # demand down strategy: cut output
         C_21c,
         # demand down strategy: cut costs
         C_21d,
         # demand down strategy: freeze prices
         C_21e,
         # demand down strategy: cut prices reducing margins & costs
         C_21f,
         # demand down strategy: cut prices cutting margins
         C_21g,
         # demand down strategy: cut prices cutting costs
         C_21h,
         # conditional on Q21, how wages are affected?
         # cut/freeze/limit pay increases
         C_22a,
         # reducing flexible wage components
         C_22b,
         # cut permanent workers
         C_22c,
         # cut temporary workers
         C_22d,
         # cut hours worked
         C_22e,
         # cut non-labour costs
         C_22f,
         # start outsourcing
         C_22g,
         # reaction to increse in intermediate goods prices
         C_23d,
         # after increase in interm. goods prices, firms cut costs, firm does
         # cut/freeze/reduce pay
         C_24a,
         # cut flex wage component
         C_24b,
         # cut permanent workers
         C_24c,
         # cut temp workers
         C_24d,
         # cut hours worked
         C_24e,
         # cut non-labour costs
         C_24f,
         # start outsourcing
         C_24g,
         # unexpected wage increase strategy: reduce costs
         C_25d,
         # after unexp wage increase firm cuts costs and 
         # cut/freeze/reduce pay
         C_26a,
         # cut flex wage component
         C_26b,
         # cut permanent workers
         C_26c,
         # cut temp workers
         C_26d,
         # cut hours worked
         C_26e,
         # cut base wages
         C_26f,
         # start outsourcing
         C_26g,
         # main prod price set by parent comp etc
         C_28a,
         # main prod price set following competitors
         C_28b,
         # main prod price set according to cost & profit margins
         C_28c,
         # main prod price set other way
         C_28d, 
         # price competition is severe
         NC_29a,
         # price competition is strong
         NC_29b,
         # price competition is weak
         NC_29c,
         # no price competition
         NC_29d,
         # don't know if there's competition
         NC_29e,
         # no answer
         NC_29f,
         # unknown extent of price competition
         NC_29g,
         # competitors cut prices, how likely is to cut prices?
         C_30,
         # main prod price change: daily
         C_31a,
         # main prod price change: weekly
         C_31b,
         # main prod price change: monthly
         C_31d,
         # main prod price change: quarterly
         C_31e,
         # main prod price change: half-yearly
         C_31f,
         # main prod price change: bi-monthly
         C_31c,
         # main prod price change: yearly
         C_31g,
         # main prod price change: less than yearly
         C_31h,
         # main prod price change: never
         C_31i,
         # main prod price change: no pattern
         C_31j,
         # main prod price change: another freq
         C_31k,
         # is there relation between price changes and wage changes?
         C_33,
         # overall empl by the end of ref. period
         C_34,
         # overall empl by the end of ref. period in categories
         C_34a,
         # % empl is permanent full time
         C_34b,
         # % empl is permanent part time
         C_34c,
         # % empl is temporary
         C_34d,
         # % empl is other
         C_34e,
         # first year of activity
         NC_39,
         # % of tot cost due to lab costs
         NC_40,
         # firm revenues this year with respect to last year
         NC_41,
         # crisis effect on firm's turnover
         DC_42,
         # crisis effect on firm
         # fall in demand
         DC_43a,
         # hard to finance
         DC_43b,
         # hard to be paid
         DC_43c,
         # hard to get interm. prods
         DC_43d,
         # Crisis demand fall, firm strategy
         # reduce prices
         DC_44a,
         # reduce margins
         DC_44b,
         # reduce output
         DC_44c,
         # reduce costs
         DC_44d,
         # reduce prices cutting costs & margins
         DC_44f,
         # reduce prices cutting margins
         DC_44g,
         # reduce prices cutting costs
         DC_44h,
         # increase prices
         DC_44i,
         # conditional on reducing costs in Q44
         # cut/freeze base wage
         DC_45a,
         # cut flexi part of wage
         DC_45b,
         # cut permanent empl
         DC_45c,
         # cut temporary workers
         DC_45d,
         # cut hours worked
         DC_45e,
         # cut non-lab costs
         DC_45f,
         # outsourcing
         DC_45g,
         # has base wage frozen for crisis
         DC_46a,
         # exp to freeze base wage for crisis
         DC_46b,
         # firms get gov't measures?
         DC_48,
         # wage not cut because of
         # regulation or coll agreement
         DNC_49a,
         # workers morale
         DNC_49b,
         # firms reputation
         DNC_49c,
         # best workers may leave
         DNC_49d,
         # hiring costs after spells
         DNC_49e,
         # not attract new workers
         DNC_49f,
         # implicit agreement with workers
         DNC_49g,
         # workers compare wages across firms
         DNC_49h,
         # unique firm identifier by country
         firm_id
  )
























