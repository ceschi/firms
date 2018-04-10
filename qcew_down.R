qcew_down <- function(data_dir){
  require(lubridate)
  # custom function to download,
  # select and merge QCEW data
  
  # backbones of the url to download archives
  url_core <- 'https://data.bls.gov/cew/data/files/'
  url_suff <- '_qtrly_singlefile.zip'
  file_path <- '.q1-q4.singlefile.csv'
  
  # time-consuming loop to download
  # select and merge datasets
  for (i in 1990:(year(Sys.Date())-2)){
    
    # compose url with looped year
    url <- paste0(url_core, i, '/csv/', i, url_suff)
    
    # dowload file
    download.file(url,
                  file.path(data_dir, paste0(i, url_suff)),
                  mode='wb')
    
    # unzip file
    unzip(zipfile=file.path(data_dir, paste0(i, url_suff)),
          overwrite = F,
          exdir = data_dir)
    
    # delete file zip after extraction
    file.remove(file.path(data_dir, paste0(i, url_suff)))
    
    # read in tibble the file, select relevant vars
    # and relevant observations
    
  }
}