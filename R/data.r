#' @name emdat_sample
#' @title Cleaned and enhanced EMDAT data for 2014
#'
#' @description Sample data for 2014. 
#' 
#' Note on ISO 3-letter codes - Some countries could not be assigned an 
#' ISO 3-letter code due to geographical splits. Hence, Czechoslovakia, 
#' Yugoslavia, Serbia Montenegro and Soviet Union have been assigned an ISO 
#' code of \dQuote{X___X}. Some country codes in the World Bank data have also 
#' been found to be inconsistent with ISO 3166 convention. Hence, ROM, PSE, 
#' TMP, ZAR were assigned the codes of ROU, WBG, TLS, COD, respectively.
#'  
#' Note on \sQuote{Location} names - About 21 events in the entire database 
#' have \sQuote{Location} names containing non-ASCII characters. Such characters
#' were converted to a \sQuote{?}.
#'   
#' @details 
#' Variables:
#' 
#' \itemize{
#'  \item Start - start date from EMDAT, days/months could sometimes be 0
#'  \item End - end date from EMDAT, days/months could sometimes be 0
#'  \item Country - country name used by EMDAT
#'  \item Location - regions within the country
#'  \item Type - type of disaster, 16 types
#'  \item SubType - sub-type of disaster, 40 sub-types (including missing/blank)
#'  \item Killed - number of people killed from EMDAT
#'  \item TotAffected - number of people affected from EMDAT
#'  \item EstDamage - damage from EMDAT in thousands of US Dollars, for the year of 
#'  occurrence of the disaster
#'  \item DisNo - disaster reference number assigned by EMDAT
#'  \item Group - group inferred from Type
#'  \item Year - year of disaster, inferred from the Start variable (consistent 
#'  with CRED's ADSR reports)
#'  \item ISO_EM - 3-letter country code from raw EMDAT data (some countries in 
#'  the raw EMDAT do not have the current ISO code because of geographical 
#'  splits or legacy names)
#'  \item ISO_alpha3 - 3-letter country code based on ISO 3166-1 alpha-3 convention
#'  \item ISO_cntry - country name based on ISO 3166-1 alpha-3 convention
#'  \item region - continental region inferred from the Country variable 
#'  (consistent with CRED's ADSR reports)
#'  \item Pop - Population from World Bank's World Development Indicators based 
#'  on the Year variable
#'  \item GDP - GDP from World Bank's World Development Indicators based 
#'  on the Year variable, in thousands of US Dollars, based on current Year
#' }
#'
#'
#' @references EMDAT: The OFDA/CRED International Disaster Database - 
#' www.emdat.be - Universite catholique de Louvain - Brussels - Belgium.
#' @references The World Bank's World DataBank, \url{http://databank.worldbank.org}
#' 
#' @docType data
#' @usage data(emdat_sample)
#' @format Data frame with 18 columns and 473 rows
#' @keywords datasets
NULL

#' @name usa_cpi
#' @title USA CPI data
#'
#' @description Consumer Price Index from the US Bureau of Labor Statistics, 1900 - 2014
#' 
#' @details 
#' Variables:
#' 
#' \itemize{
#'  \item Year - calendar year
#'  \item CPI - consumer price index
#' }
#'
#'
#' @references Annual average CPI, all urban consumers, obtained from the 
#' US Bureau of  Labor Statistics. Available from \url{http://www.bls.gov/cpi/tables.htm}
#' 
#' @docType data
#' @usage data(usa_cpi)
#' @format data frame with 115 rows and 2 variables
#' @keywords datasets
NULL

#' @name emdatr
#' @title Global Disaster Losses from the EMDAT database
#'
#' @details 
#' The EMDAT database provides information on human and financial losses 
#' from more than 21,000 major natural global disasters from 1900 to the 
#' present. This package provides the entire data available from EMDAT 
#' and also additional relevant data. Raw data from EMDAT was downloaded 
#' via the web (\url{http://www.emdat.be/database}) and cleaned and enhanced. 
#' \pkg{emdatr} package provides a sample of this cleaned and enhanced data. 
#' Also, \pkg{emdatr} provides functionality to access the entire cleaned 
#' and enhanced EMDAT data.
#'
#' @import RCurl
#' @docType package
NULL
