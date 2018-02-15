##### Load packages & create direcories #####

##### Packages #####

pkgs <- c('readstata13', 'tidyverse',
          'ggridges', 'lubridate', 'plm')


##### Directories, setting and creating #####

graphs_dir <- file.path(getwd(), 'Plots')
data_dir <- file.path(getwd(), 'Downloaded files')
dir.create(graphs_dir)
dir.create(data_dir)


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
# 
# qcew_data_single <- function(data_dir, graphs_dir){
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
#   for (i in 1990:(year(Sys.Date())-1)){
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
#     db_qcew_temp <- readr::read_csv(file=file.path(data_dir, paste0(i, file_path)),
#                                     col_names = T,
#                                     na=c('','N/A'),
#                                     progress=T,
#                                     quote="\"", 
#                                     col_types = c(
#                                       area_fips = col_character(),
#                                       own_code = col_character(),
#                                       industry_code = col_character(),
#                                       agglvl_code = col_character(),
#                                       size_code = col_character(),
#                                       year = col_character(),
#                                       qtr = col_character(),
#                                       disclosure_code = col_character(),
#                                       qtrly_estabs = col_integer(),
#                                       month1_emplvl = col_integer(),
#                                       month2_emplvl = col_integer(),
#                                       month3_emplvl = col_integer(),
#                                       total_qtrly_wages = col_double(),
#                                       taxable_qtrly_wages = col_integer(),
#                                       qtrly_contributions = col_integer(),
#                                       avg_wkly_wage = col_integer(),
#                                       lq_disclosure_code = col_character(),
#                                       lq_qtrly_estabs = col_double(),
#                                       lq_month1_emplvl = col_double(),
#                                       lq_month2_emplvl = col_double(),
#                                       lq_month3_emplvl = col_double(),
#                                       lq_total_qtrly_wages = col_double(),
#                                       lq_taxable_qtrly_wages = col_double(),
#                                       lq_qtrly_contributions = col_double(),
#                                       lq_avg_wkly_wage = col_double(),
#                                       oty_disclosure_code = col_character(),
#                                       oty_qtrly_estabs_chg = col_integer(),
#                                       oty_qtrly_estabs_pct_chg = col_double(),
#                                       oty_month1_emplvl_chg = col_integer(),
#                                       oty_month1_emplvl_pct_chg = col_double(),
#                                       oty_month2_emplvl_chg = col_integer(),
#                                       oty_month2_emplvl_pct_chg = col_double(),
#                                       oty_month3_emplvl_chg = col_integer(),
#                                       oty_month3_emplvl_pct_chg = col_double(),
#                                       oty_total_qtrly_wages_chg = col_integer(),
#                                       oty_total_qtrly_wages_pct_chg = col_double(),
#                                       oty_taxable_qtrly_wages_chg = col_integer(),
#                                       oty_taxable_qtrly_wages_pct_chg = col_double(),
#                                       oty_qtrly_contributions_chg = col_integer(),
#                                       oty_qtrly_contributions_pct_chg = col_double(),
#                                       oty_avg_wkly_wage_chg = col_integer(),
#                                       oty_avg_wkly_wage_pct_chg = col_double()
#                                     )
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
#              ) %>%
#       
#       # filter only aggregate and private observations
#       filter(own_code %in% c(0,5)) %>% 
#       # filter only US-wide observations
#       filter(area_fips=='US000')
#     
#     ### WORK THIS OUT!! ###
#     out_db <- bind_rows(out_db, db_qcew_temp)
#     
#     # problem with this data is that we loose entirely the
#     # size dimension of the observations.
#     # Data by industry might provide more suitability.
#   }
#   
#   return(out_db)
# }
# 

##### Loading/installing packages #####
instant_pkgs(pkgs)


##### Housekeeping ####
rm(pkgs, instant_pkgs)
