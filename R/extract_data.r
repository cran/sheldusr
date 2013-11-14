#' Extract desired data from pre-processed SHELDUS binary data
#'
#' @param years vector of years for which data is desired, permissible range 1960-2012
#' @param hazards vector of hazards names for which data is desired, permissible hazard names one or more of the following (CASE SENSITIVE!) - "Avalanche", "Coastal", "Drought", "Earthquake", "Flooding", "Fog", "Hail", "Heat", "Hurricane/Tropical Storm", "Landslide", "Lightning", "Severe Storm/Thunder Storm", "Tornado", "Tsunami/Seiche", "Volcano", "Wildfire", "Wind", "Winter Weather"
#' @param inflation logical indicating whether or not inflation adjustment is desired
#' @param base_year year on which the inflation adjustment is based on
#' @export
#' @examples
#' # SHELDUS data for 1996 for all hazards, inflation adjusted for 2010
#' select_hazards <- sheldus_extract(c(1996), inflation = TRUE, base_year = 2010)
#' head(select_hazards)

sheldus_extract <- function(years = c(2012, 2012), hazards = "", 
                            inflation = FALSE, base_year = 2012) {
  
  # global parameters and data
  # years for which SHELDUS database contains data
  year_vec <- c(1960:2012)
  
  # names of hazards from SHELDUS
  hazard_names <- c("Avalanche", "Coastal", "Drought", "Earthquake", "Flooding", 
                    "Fog", "Hail", "Heat", "Hurricane/Tropical Storm", 
                    "Landslide", "Lightning", "Severe Storm/Thunder Storm", 
                    "Tornado", "Tsunami/Seiche", "Volcano", "Wildfire", "Wind", 
                    "Winter Weather")
  
  # invoke data
  sheldus_data <- NULL
  data(sheldus_data, envir = environment())
  
  # sanity checks
  if (sum(nchar(hazards)) > 0) {
    if(!(all(hazards %in% hazard_names))) {
      stop("hazards can be EITHER an empty string OR one or more of - \n", 
           paste(hazard_names, collapse = "\n"), "\n")
    }
  }
  if(!(all(years %in% year_vec))) {
    stop("year has to be within the range ", year_vec[1], " - ", 
         year_vec[length(year_vec)], "\n")
  }
  if (inflation) {
    if(!(base_year %in% sheldus_data$usa_cpi$Year)) {
      stop("year for inflation adjustment should be within the range ", 
           sheldus_data$usa_cpi$Year[1], " - ", sheldus_data$usa_cpi$Year[nrow(sheldus_data$usa_cpi)], "\n")  
    } 
  }

  # extract recrods from the complete data
  out_df <- sheldus_assemble_data(years, hazards, year_vec, hazard_names)
  
  # convert dates to their original format
  out_df$date1 <- as.Date(out_df$date1, origin = "1970-01-01")
  out_df$date2 <- as.Date(out_df$date2, origin = "1970-01-01")
  
  # identify state and county names from fips code
  out_df <- merge(out_df, sheldus_data$usa_fips, by = "fips", all.x = TRUE, sort = FALSE)
  
  # reaname columns to match the original names
  colnames(out_df) <- c("FIPS_CODE", "hazard_id", "HAZARD_BEGIN_DATE", 
                        "HAZARD_END_DATE", "INJURIES", "FATALITIES", 
                        "PROPERTY_DAMAGE", "CROP_DAMAGE", "HAZARD_TYPE_COMBO",
                        "state", "county")
  
  # identify hazard names
  hazard_ids <- sapply(out_df$HAZARD_TYPE_COMBO, 
                       FUN = function (x) grep("1", unlist(strsplit(x, ""))))
  out_df$HAZARD_TYPE_COMBO <- sapply(hazard_ids, 
                                     FUN = function(x) paste(hazard_names[x], 
                                                             collapse = " - "))
  
  # re-order to be in the same order as the original data
  out_df <- out_df[, c("hazard_id", "HAZARD_BEGIN_DATE", "HAZARD_END_DATE",
                       "HAZARD_TYPE_COMBO", "county", "state", "FIPS_CODE", 
                       "INJURIES", "FATALITIES", "PROPERTY_DAMAGE", 
                       "CROP_DAMAGE")]
  
  # adjustment for inflation based on begin year, consitent with SHELDUS
  if (inflation) {
    # identify begin year for each record
    curr_years <- as.POSIXlt(out_df$HAZARD_END_DATE)
    curr_years <- 1900 + curr_years$year    
    
    # cpi for the base year
    base_cpi <- sheldus_data$usa_cpi$CPI[which(sheldus_data$usa_cpi$Year == base_year)]
    # cpi for all the records based on begin year
    curr_cpi <- sapply(curr_years, 
                       FUN = function(x) sheldus_data$usa_cpi$CPI[which(sheldus_data$usa_cpi$Year == x)])
    # adjustment factor
    adj_factor <- base_cpi / curr_cpi
    
    new_prop <- paste0("PROPERTY_DAMAGE_ADJUSTED_", base_year)
    new_crop <- paste0("CROP_DAMAGE_ADJUSTED_", base_year)
    out_df[, new_prop] <- out_df$PROPERTY_DAMAGE * adj_factor
    out_df[, new_crop] <- out_df$CROP_DAMAGE * adj_factor
  }
  
  return (out_df)
}

