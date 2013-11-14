#' Read pre-processed SHELDUS data and assemble variables into one data frame
#'
#' @param years vector of years for which data is desired
#' @param hazards vector of hazards names for which data is desired
#' @param year_vec years for which SHELDUS database contains data
#' @param hazard_names names of hazards from SHELDUS
#' @keywords internal

sheldus_assemble_data <- function(years, hazards, year_vec, hazard_names) {
  
  if (sum(nchar(hazards)) > 0) {
    if(!(all(hazards %in% hazard_names))) {
      stop("hazards can be EITHER an empty string OR one or more of of - \n", 
           paste(hazard_names, collapse = "\n"), "\n")
    }
  }
  if(!(all(years %in% year_vec))) {
    stop("year has to be within the range ", year_vec[1], " - ", 
         year_vec[length(year_vec)], "\n")
  }
  
  # invoke data
  sheldus_data <- NULL
  data(sheldus_data, envir = environment())
  
  # process data
  # convert intgert fips to char to 5 digits
  sheldus_data$fips <- sprintf("%.5d", sheldus_data$fips)  
  # combine the 3 sets of hazard data into one 
  data_haz <- paste0(sprintf("%.6d", sheldus_data$hazard1), 
                     sprintf("%.6d", sheldus_data$hazard2), 
                     sprintf("%.6d", sheldus_data$hazard3))
  
  # identify data indices corresp to year
  # convert date of the form "7/1/2011" to int; w.r.t 1970-01-01  
  seq_dates <- c()
  for (eachYear in years) {
    beg_date <- as.numeric(as.Date(paste0("1/1/", eachYear), "%m/%d/%Y"))
    end_date <- as.numeric(as.Date(paste0("12/31/", eachYear), "%m/%d/%Y"))
    seq_dates <- c(seq_dates, seq(beg_date, end_date))
  }
  # dates from the entire dataset present in the desired subset
  index_date <- which(sheldus_data$date2 %in% seq_dates)  
  
  # identify indices of records to be extracted
  if (sum(nchar(hazards)) > 0) {
    # id in the vector of hazard names
    haz_ids <- which(hazard_names %in% hazards)  
    # records from the entire dataset which have the given hazard
    index_haz <- rep(0, length(data_haz))
    for (each_id in haz_ids) {
      index_haz <- index_haz + as.numeric(substr(data_haz, each_id, each_id))  
    }
    index_haz <- which(index_haz > 0)  
    
    index_query <- intersect(index_haz, index_date) 
  } else {
    index_query <- index_date
  }    
  
  # output data frame
  out_df <- data.frame(id = sheldus_data$id[index_query],
                       date1 = sheldus_data$date1[index_query],
                       date2 = sheldus_data$date2[index_query],
                       fips = sheldus_data$fips[index_query],
                       injury = sheldus_data$injury[index_query],
                       fatal = sheldus_data$fatal[index_query],
                       property = sheldus_data$property[index_query],
                       crop = sheldus_data$crop[index_query],
                       hazard = data_haz[index_query],
                       stringsAsFactors = FALSE)
  
  return (out_df)
}
