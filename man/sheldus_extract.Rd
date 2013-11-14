\name{sheldus_extract}
\alias{sheldus_extract}
\title{Extract desired data from pre-processed SHELDUS binary data}
\usage{
  sheldus_extract(years = c(2012, 2012), hazards = "",
    inflation = FALSE, base_year = 2012)
}
\arguments{
  \item{years}{vector of years for which data is desired,
  permissible range 1960-2012}

  \item{hazards}{vector of hazards names for which data is
  desired, permissible hazard names one or more of the
  following (CASE SENSITIVE!) - "Avalanche", "Coastal",
  "Drought", "Earthquake", "Flooding", "Fog", "Hail",
  "Heat", "Hurricane/Tropical Storm", "Landslide",
  "Lightning", "Severe Storm/Thunder Storm", "Tornado",
  "Tsunami/Seiche", "Volcano", "Wildfire", "Wind", "Winter
  Weather"}

  \item{inflation}{logical indicating whether or not
  inflation adjustment is desired}

  \item{base_year}{year on which the inflation adjustment
  is based on}
}
\description{
  Extract desired data from pre-processed SHELDUS binary
  data
}
\examples{
# SHELDUS data for 1996 for all hazards, inflation adjusted for 2010
select_hazards <- sheldus_extract(c(1996), inflation = TRUE, base_year = 2010)
head(select_hazards)
}

