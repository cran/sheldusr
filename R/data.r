#' SHELDUS data
#'
#' Preprocessed data from SHELDUS and other required information
#' 
#' Fips data was obtained from www.schooldata.com/pdfs/US_FIPS_Codes.xls.
#' 
#' Annual average CPI (all urban consumers) obtained from the US Bureau of 
#' Labor Statistics. See http://www.bls.gov/cpi/tables.htm
#' 
#' HAZARD_TYPE_COMBO could be one or more of 18 hazard types; in the 
#' preprocessed data it is stored as either 1 or 0 depending on the presence or 
#' absence of a hazard; thus, the hazard string for a record is an 18-digit 
#' string of 1s and 0s. During preprocessing this 18-digit string was broken 
#' down into 3 parts of 6 digits each
#'
#' Variables:
#' 
#' \itemize{
#' \item usa_fips - FIPS codes for each county in each state (data frame with 3142 rows and 3 variables)
#'   \itemize{
#'     \item state
#'     \item county
#'     \item fips
#'   }
#'  \item usa_cpi - Consumer Price Index for the United States 1913-2012 (data frame with 100 rows and 2 variables)
#'    \itemize{
#'     \item Year
#'     \item CPI
#'   }
#'  \item id - hazard_id from SHELDUS
#'  \item date1 - HAZARD_BEGIN_DATE from SHELDUS
#'  \item date1 - HAZARD_BEGIN_DATE from SHELDUS
#'  \item fips - FIPS_CODE from SHELDUS
#'  \item injury - INJURIES from SHELDUS
#'  \item fatal - FATALITIES from SHELDUS
#'  \item property - PROPERTY_DAMAGE from SHELDUS
#'  \item crop - CROP_DAMAGE from SHELDUS
#'  \item hazard1 - HAZARD_TYPE_COMBO from SHELDUS
#'  \item hazard2 - HAZARD_TYPE_COMBO from SHELDUS
#'  \item hazard3 - HAZARD_TYPE_COMBO from SHELDUS
#' }
#'
#'
#' @references Hazards & Vulnerability Research Institute (2013). 
#' The Spatial Hazard Events and Losses Database for the United States, 
#' Version 12.0 [Online Database]. Columbia, SC: University of South Carolina. 
#' Available from http://www.sheldus.org
#' 
#' @docType data
#' @name sheldus_data
#' @usage data(sheldus_data)
#' @format List with 13 elements; SHELDUS-preprocessed data each a vector of length 781513
#' @keywords datasets
NULL

