\name{emdat_extract}
\alias{emdat_extract}
\title{Extract desired data from pre-processed EM-DAT data}
\usage{
  emdat_extract(years = c(2012, 2012), inflation = FALSE,
    base_year = 2012)
}
\arguments{
  \item{years}{vector of years for which data is desired,
  permissible range 1900 - 2013}

  \item{inflation}{logical indicating whether or not
  inflation adjustment is desired}

  \item{base_year}{year on which the inflation adjustment
  is based on}
}
\description{
  Extract desired data from pre-processed EM-DAT data
}
\examples{
# EM-DAT data for all of 2012
losses_2012 <- emdat_extract()

# EM-DAT data for all of 2012, inflation-adjusted
losses_2012_adj <- emdat_extract(inflation = TRUE)

# EM-DAT data for 1960-70, inflation-adjusted
losses_1960s <- emdat_extract(years = c(1960:1970), inflation = TRUE)
}

