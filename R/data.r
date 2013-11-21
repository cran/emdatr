#' EM-DAT data
#'
#' Data from EM-DAT was downloaded via the web and cleaned. Additional information
#' on GDP and Population from the World Bank has been added.
#' 
#' The country names used by EM-DAT are not always the same as those used by the 
#' ISO 3166 convention. This issue is relevant when making spatial maps using R.
#' Country names from EM-DAT were mapped to the ISO names by visually comparing
#' the names. The mismatch is names was either due to abbreviations used by 
#' EM-DAT, for instance - Is for Islands, or anglicized spelling used by ISO.
#' Some countries could not be assigned an ISO name due to geographical splits.
#' Hence, Czechoslovakia, Yugoslavia, Serbia Montenegro and Soviet Union in the
#' EM-DAT database have been assigned an ISO name of X___X.
#' 
#' Some country codes in the World Bank data have also been found to be 
#' inconsistent with ISO 3166 convention. Hence, ROM, PSE, TMP, ZAR were assigned
#' the codes of ROU, WBG, TLS, COD, respectively.
#' 
#' Variables:
#' 
#' \itemize{
#'  \item Start - start date from EM-DAT, days/months could sometimes be 0
#'  \item End - end date from EM-DAT, days/months could sometimes be 0
#'  \item Country - country name used by EM-DAT
#'  \item Location - regions within the country, sometimes displayed as ...
#'  by the web browser possibly when there are too many locations
#'  \item Type - type of disaster, 15 types; corrected for typos
#'  \item SubType - sub-type of disaster, 44 sub-types; corrected for typos
#'  \item Name - Name from EM-DAT, such as name of a hurricane
#'  \item Killed - number of people killed from EM-DAT
#'  \item TotAffected - number of people affected from EM-DAT
#'  \item EstDamage - damage from EM-DAT in Millions US Dollar, for the year of 
#'  occurrence of the disaster
#'  \item DisNo - disaster reference number assigned by EM-DAT
#'  \item Group - group inferred from Type; 7 groups
#'  \item Year - year of disaster, inferred from the Start variable, consistent 
#'  with CRED's ADSR 2012 report
#'  \item ISO_alpha3 - 3-letter country code based on ISO 3166-1 alpha-3 convention
#'  \item ISO_cntry - country name based on ISO 3166-1 alpha-3 convention
#'  \item region - continental region inferred from the Country varibale, 
#'  consistent with CRED's ADSR 2012 report
#'  \item Pop - Population from World Bank's World Development Indicators based 
#'  on the Year variable
#'  \item GDP - GDP from World Bank's World Development Indicators based 
#'  on the Year variable, in current US Dollars, based on Year
#' }
#'
#'
#' @references EM-DAT: The OFDA/CRED International Disaster Database - 
#' www.emdat.be - Universite catholique de Louvain - Brussels - Belgium.
#' @references The World Bank's World DataBank, http://databank.worldbank.org
#' 
#' @docType data
#' @name emdat_data
#' @usage data(emdat_data)
#' @format Data frame with 18 columns and 20,620 rows
#' @keywords datasets
NULL

#' USA CPI data
#'
#' Consumer Price Index from the US Bureau of Labor Statistics, 1913 - 2012
#' 
#' Variables:
#' 
#' \itemize{
#'  \item Year - calendar year
#'  \item CPI - consumer price index
#' }
#'
#'
#' @references Annual average CPI, all urban consumers, obtained from the 
#' US Bureau of  Labor Statistics. Available from http://www.bls.gov/cpi/tables.htm
#' 
#' @docType data
#' @name usa_cpi
#' @usage data(usa_cpi)
#' @format data frame with 100 rows and 2 variables
#' @keywords datasets
NULL
