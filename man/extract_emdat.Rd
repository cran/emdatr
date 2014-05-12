\name{extract_emdat}
\alias{extract_emdat}
\title{Extract desired data from cleaned EMDAT data}
\usage{
  extract_emdat(sample_only = TRUE, inflation = FALSE,
    base_year = 2013)
}
\arguments{
  \item{sample_only}{logical flag indicating the desire to
  get only a sample of the EMDAT data (which comes with
  this package) or the entire dataset}

  \item{inflation}{logical indicating whether or not
  inflation adjustment is desired}

  \item{base_year}{year on which the inflation adjustment
  is to be based on}
}
\value{
  data frame
}
\description{
  Extract desired data from cleaned EMDAT data
}
\examples{
# EMDAT data for all of 2013
losses_2013 <- extract_emdat()

# EMDAT data for all of 2013, inflation-adjusted
losses_2013_adj <- extract_emdat(inflation = TRUE)

# entire EMDAT data, inflation-adjusted
\dontrun{
losses_all <- extract_emdat(sample_only = FALSE, inflation = TRUE)
}
}
\author{
  Gopi Goteti
}

