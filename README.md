R package sheldus, Losses from Natural Disasters in the United States
========================================================

The SHELDUS database, short for Spatial Hazard Events and Losses Database in the United States [http://webra.cas.sc.edu/hvri/products/sheldus.aspx](http://webra.cas.sc.edu/hvri/products/sheldus.aspx), from the University of South Carolina, is a  database on human and property losses from natural disasters in the United States. Data from this database includes County-level information on property losses, crop losses, injuries and fatalities from 18 different types of natural hazards (hurricanes, droughts, floods, etc.) from about 1960 to the present.

Although the data is free, downloading the data is tedious and so is cleaning and analysing it. The `sheldusr` package comes with the entire data. Users could extract desired data through the functionality provided. Additional graphical and statistical analyses could easily be done in R.

Status of `sheldusr`:
 * Data spans the time period 1960 - 2012. Additional data from SHELDUS 
   (prior to 1960 and Presidential Disaster Declarations) will be 
   included in the future.

 * REMARKS column from the SHELDUS database is ignored for now; will be
   included in the future.

 * `sheldus_extract` can be used to extract data by time period and hazard. 
   Selection by State will be included in the future.
 