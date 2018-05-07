##### Load packages & create direcories #####

##### Packages #####

pkgs <- c('readstata13', 'tidyverse',
          'ggridges', 'lubridate', 'plm',
          'stargazer', 'lfe')


##### Directories, setting and creating #####

graphs_dir <- file.path(getwd(), 'Plots')
data_dir <- file.path(getwd(), 'Downloaded files')
dir.create(graphs_dir)
dir.create(data_dir)
working <- getwd()


##### Functions #####


instant_pkgs <- function(pkgs) { 
  ## Function loading or installing packages in
  ## current R instance.
  ## Developed by Jaime M. Montana Doncel - V1
  
  
  pkgs_miss <- pkgs[which(!pkgs %in% installed.packages()[, 1])]
  if (length(pkgs_miss) > 0) {
    install.packages(pkgs_miss)
  }
  
  if (length(pkgs_miss) == 0) {
    message("\n Packages were already installed!\n")
  }
  
  # install packages not already loaded:
  pkgs_miss <- pkgs[which(!pkgs %in% installed.packages()[, 1])]
  if (length(pkgs_miss) > 0) {
    install.packages(pkgs_miss)
  }
  
  # load packages not already loaded:
  attached <- search()
  attached_pkgs <- attached[grepl("package", attached)]
  need_to_attach <- pkgs[which(!pkgs %in% gsub("package:", "", attached_pkgs))]
  
  if (length(need_to_attach) > 0) {
    for (i in 1:length(need_to_attach)) require(need_to_attach[i], character.only = TRUE)
  }
  
  if (length(need_to_attach) == 0) {
    message("\n ...Packages were already loaded!\n")
  }
}

# qcew_data_single <- function(data_dir){
#   # custom function to download,
#   # select and merge QCEW data
# 
#   # backbones of the url to download archives
#   url_core <- 'https://data.bls.gov/cew/data/files/'
#   url_suff <- '_qtrly_singlefile.zip'
#   file_path <- '.q1-q4.singlefile.csv'
# 
#   # time-consuming loop to download
#   # select and merge datasets
#   for (i in 1990:(year(Sys.Date())-2)){
# 
#     # compose url with looped year
#     url <- paste0(url_core, i, '/csv/', i, url_suff)
# 
#     # dowload file
#     download.file(url,
#                   file.path(data_dir, paste0(i, url_suff)),
#                   mode='wb')
# 
#     # unzip file
#     unzip(zipfile=file.path(data_dir, paste0(i, url_suff)),
#           overwrite = F,
#           exdir = data_dir)
# 
#     # delete file zip after extraction
#     file.remove(file.path(data_dir, paste0(i, url_suff)))
# 
#     # read in tibble the file, select relevant vars
#     # and relevant observations
#     db_qcew_temp <- read.csv(file=file.path(data_dir, paste0(i, file_path)),
#                                     header = T,
#                                     na.strings=c('','N/A'),
#                                     dec='.',
#                                     sep=',',
#                                     stringsAsFactors = F,
#                                     quote="\""#,
#                                     # col_types = c(
#                                     #   area_fips = col_character(),
#                                     #   own_code = col_character(),
#                                     #   industry_code = col_character(),
#                                     #   agglvl_code = col_character(),
#                                     #   size_code = col_character(),
#                                     #   year = col_character(),
#                                     #   qtr = col_character(),
#                                     #   disclosure_code = col_character(),
#                                     #   qtrly_estabs = col_integer(),
#                                     #   month1_emplvl = col_integer(),
#                                     #   month2_emplvl = col_integer(),
#                                     #   month3_emplvl = col_integer(),
#                                     #   total_qtrly_wages = col_double(),
#                                     #   taxable_qtrly_wages = col_integer(),
#                                     #   qtrly_contributions = col_integer(),
#                                     #   avg_wkly_wage = col_integer(),
#                                     #   lq_disclosure_code = col_character(),
#                                     #   lq_qtrly_estabs = col_double(),
#                                     #   lq_month1_emplvl = col_double(),
#                                     #   lq_month2_emplvl = col_double(),
#                                     #   lq_month3_emplvl = col_double(),
#                                     #   lq_total_qtrly_wages = col_double(),
#                                     #   lq_taxable_qtrly_wages = col_double(),
#                                     #   lq_qtrly_contributions = col_double(),
#                                     #   lq_avg_wkly_wage = col_double(),
#                                     #   oty_disclosure_code = col_character(),
#                                     #   oty_qtrly_estabs_chg = col_integer(),
#                                     #   oty_qtrly_estabs_pct_chg = col_double(),
#                                     #   oty_month1_emplvl_chg = col_integer(),
#                                     #   oty_month1_emplvl_pct_chg = col_double(),
#                                     #   oty_month2_emplvl_chg = col_integer(),
#                                     #   oty_month2_emplvl_pct_chg = col_double(),
#                                     #   oty_month3_emplvl_chg = col_integer(),
#                                     #   oty_month3_emplvl_pct_chg = col_double(),
#                                     #   oty_total_qtrly_wages_chg = col_character(),
#                                     #   oty_total_qtrly_wages_pct_chg = col_double(),
#                                     #   oty_taxable_qtrly_wages_chg = col_double(),
#                                     #   oty_taxable_qtrly_wages_pct_chg = col_double(),
#                                     #   oty_qtrly_contributions_chg = col_integer(),
#                                     #   oty_qtrly_contributions_pct_chg = col_double(),
#                                     #   oty_avg_wkly_wage_chg = col_integer(),
#                                     #   oty_avg_wkly_wage_pct_chg = col_double()
#                                     # )
#                                     ) %>%
#       select(area_fips,
#              own_code,
#              industry_code,
#              size_code,
#              year,
#              qtr,
#              qtrly_estabs,
#              month3_emplvl,
#              total_qtrly_wages,
#              avg_wkly_wage,
#              oty_qtrly_estabs_chg,
#              oty_qtrly_estabs_pct_chg,
#              oty_total_qtrly_wages_chg,
#              oty_total_qtrly_wages_pct_chg,
#              oty_avg_wkly_wage_chg,
#              oty_avg_wkly_wage_pct_chg,
#              oty_month1_emplvl_chg,
#              oty_month2_emplvl_chg,
#              oty_month3_emplvl_chg,
#              oty_month1_emplvl_pct_chg,
#              oty_month2_emplvl_pct_chg,
#              oty_month3_emplvl_pct_chg
#       )
#       #        ) %>%
#       #
#       # # filter only aggregate and private observations
#       # filter(own_code %in% c(0,5)) %>%
#       # # filter only US-wide observations
#       # filter(area_fips=='US000')
# 
#     ### WORK THIS OUT!! ###
#     out_db <- bind_rows(out_db, db_qcew_temp)
# 
#     # problem with this data is that we loose entirely the
#     # size dimension of the observations.
#     # Data by industry might provide more suitability.
# 
# 
#     # remove csv file
#     file.remove(file.path(data_dir, paste0(i, file_path)))
#   }
# 
#   return(out_db)
#   write.table(out_db, file = file.path(data.dir, 'datamonster.csv'), sep = ',')
# }


# # QCEW via API
# 
# qcew_api <- function(data_dir, start.year){
#   
#   # libraries needed
#   library(dplyr)
#   
#   # sets upper limit for loop
#   curr_year <- as.numeric(format(Sys.Date(), '%Y'))-2
#   
#   ### url composition:
#   # invariant part of the API
#   url_core <- 'http://data.bls.gov/cew/data/api/'
#   
#   # for yearly freq data
#   url_yrly <- '/A/' 
#   
#   # last part to have csv ext
#   # kept for eventual extension
#   url_postfix <- '.csv'
#   
#   # declaring industries and
#   # creating postfixes
#   industries <- c(11, 21, 23, '31_33', 22, 42,
#                   '44_45', '48_49',51, 52, 53,
#                   54, 55, 56, 61, 62, 71, 72,
#                   81, 92, 99)
#   ind_names <- c('Agriculture',
#                  'Mining',
#                  'Construction',
#                  'Manufacturing',
#                  'Utilities',
#                  'Wholesale Trade',
#                  'Retail Trade',
#                  'Transportation & Warehousing',
#                  'Information',
#                  'Finance',
#                  'Real Estate',
#                  'Professional and Tech services',
#                  'Management Services',
#                  'Administrative and Waste Services',
#                  'Educational Services',
#                  'Healtcare',
#                  'Arts & Entertainement',
#                  'Accommodation',
#                  'Others, non PA',
#                  'PA',
#                  'Unclassified')
#   
#   inds <- paste0(industries, '.csv')
#   
#   output_df <- data.frame(matrix(ncol=42, nrow=0))
#   names(output_df) <- names(read.csv(file='http://data.bls.gov/cew/data/api/2017/1/industry/10.csv',
#                                      header=T,
#                                      sep = ',', 
#                                      quote = '\"', 
#                                      na.strings = c('', 'N/A', '-', 'N'),
#                                      stringsAsFactors = F))
#   # output_df <- output_df %>% select(-contains('disclosure'),
#   #                                   -starts_with('lq_'))
#   
#   qcew_temp_qtr <- qcew_temp_y <- output_df
#   
#   
#   
#   # years loop
#   for (i in as.numeric(start.year):curr_year){
#     
#     # qtrs loop
#     for (s in 1:4){
#       
#       # industries loop
#       for (l in 1:length(inds)){
#         
#         
#         qcew_temp_ind <- read.csv(file=paste0(url_core, i, '/', s, '/industry/',inds[l]),
#                                       header = T,
#                                       sep = ',', 
#                                       quote = '\"', 
#                                       na.strings = c('', 'N/A', '-', 'N'),
#                                       stringsAsFactors = F) %>% select(-contains('disclosure'),
#                                                                        -starts_with('lq_'))
#         
#         # qcew_temp_qtr <- rbind(qcew_temp_qtr, qcew_temp_ind)
#         
#         cat(qcew_temp_ind,
#                   file = file.path(data_dir,'/full_QCEW.csv'),
#                   append = T,
#             sep='\n')
#         
#         cat(paste0('\nCovered ', l, '/', length(inds), ' industries'))
#         gc()
#       }
#       
#       # qcew_temp_y <- rbind(qcew_temp_y, qcew_temp_qtr)
#       
#       cat(paste0('\n\nCovered ', s, ' quarter(s) from ', i, '\n'))
#       gc()
#     }
#   
#     # output_df <- rbind(output_df, qcew_temp_y)
#     
#     cat('\n\n\n\nCovered ', i-as.numeric(start.year), ' years out of ', curr_year-as.numeric(start.year))
#   }
#   
#   
#   
#   # write.csv(x = output_df,
#   #           file = file.path(data_dir,'/full_QCEW.csv'),
#   #           col.names = T)
#   
#   # return(output_df)
#   
#   gc()
#   
# }


##### Gatherer fct ####

# fct to select qtiles and gather them
# string to look for is string
# dataset is data
# gatherer <- function(data, string){
#   require(dplyr)
#   quo_string <- quo(string)
#   
#   temp <- data %>% select(year, country, mac_sector, szclass, 
#                               contains(!!quo_string),-ends_with('_ow'),
#                               -ends_with('_iqr'), -ends_with('_sd'),
#                               -ends_with('_skew'), -ends_with('_count'),
#                               -starts_with('g_'), -starts_with('tot'),
#                               -contains('ulc'), -contains('lc_l'),
#                               -contains('lcl')) %>%
#     group_by(year, country, mac_sector, szclass) %>% 
#     gather(key = qtiles, value=kprod, kprod_mean:kprod_p99) %>% 
#     mutate(qtiles=gsub('kprod_p', 'P', qtiles)) %>% 
#     mutate(qtiles=gsub('kprod_mean', 'mean', qtiles)) %>% 
#     arrange(year, country, mac_sector, szclass, qtiles)
#   
#   return(temp)
# }


##### Loading/installing packages #####
instant_pkgs(pkgs)


##### Housekeeping ####
rm(pkgs, instant_pkgs)
gc()




































