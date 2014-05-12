\docType{data}
\name{emdat_sample}
\alias{emdat_sample}
\title{Cleaned and enhanced EMDAT data for 2013}
\format{Data frame with 18 columns and 545 rows}
\description{
  The country names used by EMDAT are not always the same
  as those used by the ISO 3166 convention. This issue is
  relevant when making spatial maps using R. Country names
  from EMDAT were mapped to the ISO names by visually
  comparing the names. The mismatch is names was either due
  to abbreviations used by EMDAT, for instance - Is for
  Islands, or Anglicized spelling used by ISO. Some
  countries could not be assigned an ISO name due to
  geographical splits. Hence, Czechoslovakia, Yugoslavia,
  Serbia Montenegro and Soviet Union in the EMDAT database
  have been assigned an ISO name of \dQuote{X___X}. Some
  country codes in the World Bank data have also been found
  to be inconsistent with ISO 3166 convention. Hence, ROM,
  PSE, TMP, ZAR were assigned the codes of ROU, WBG, TLS,
  COD, respectively.
}
\details{
  Variables:

  \itemize{ \item Start - start date from EMDAT,
  days/months could sometimes be 0 \item End - end date
  from EMDAT, days/months could sometimes be 0 \item
  Country - country name used by EMDAT \item Location -
  regions within the country, sometimes displayed as ...
  by the web browser possibly when there are too many
  locations \item Type - type of disaster, 15 types;
  corrected for typos \item SubType - sub-type of disaster,
  44 sub-types; corrected for typos \item Name - Name from
  EMDAT, such as name of a hurricane \item Killed - number
  of people killed from EMDAT \item TotAffected - number of
  people affected from EMDAT \item EstDamage - damage from
  EMDAT in Millions US Dollars, for the year of occurrence
  of the disaster \item DisNo - disaster reference number
  assigned by EMDAT \item Group - group inferred from Type;
  7 groups \item Year - year of disaster, inferred from the
  Start variable, consistent with CRED's ADSR 2012 report;
  when it could not be inferred from the Year, it was
  inferred from DisNo \item ISO_alpha3 - 3-letter country
  code based on ISO 3166-1 alpha-3 convention \item
  ISO_cntry - country name based on ISO 3166-1 alpha-3
  convention \item region - continental region inferred
  from the Country variable, consistent with CRED's ADSR
  2012 report \item Pop - Population from World Bank's
  World Development Indicators based on the Year variable
  \item GDP - GDP from World Bank's World Development
  Indicators based on the Year variable, in current US
  Dollars, based on Year }
}
\references{
  EMDAT: The OFDA/CRED International Disaster Database -
  www.emdat.be - Universite catholique de Louvain -
  Brussels - Belgium.

  The World Bank's World DataBank,
  \url{http://databank.worldbank.org}
}
\keyword{datasets}

