# count function


countNA <- function(data, ...){
  # preamble 
  require(tidyverse) # add option to install if not present
  # and check for length and class
  
  # get names of DF variables without grouping ones
  # first line generates char vector
  grouping <- eval(substitute(alist(...)))
  
  # these are the remaining variables in the DF
  check_vars <- setdiff(names(data), as.character(grouping))
  
  
  return(grouping)
}