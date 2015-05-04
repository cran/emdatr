#' @title Extract desired data from cleaned EMDAT data
#'
#' @param sample_only logical flag indicating the desire to get only a sample 
#' of the EMDAT data (which comes with this package) or the entire dataset 
#' @param inflation logical indicating whether or not inflation adjustment is desired
#' @param base_year year on which the inflation adjustment is to be based on
#' @return data frame
#' @author Gopi Goteti
#' @export
#' @examples
#' # EMDAT data for all of 2014
#' losses_2014 <- extract_emdat()
#' 
#' # EMDAT data for all of 2014, inflation-adjusted 
#' losses_2014_adj <- extract_emdat(inflation = TRUE)
#' 
#' # entire EMDAT data, inflation-adjusted 
#' \dontrun{
#' losses_all <- extract_emdat(sample_only = FALSE, inflation = TRUE)
#' }

extract_emdat <- function(sample_only = TRUE, inflation = FALSE, base_year = 2014) {
  
  #check inputs
  if (!is.logical(sample_only)) {
    stop("sample_only has to be either TRUE or FALSE!")
  }
  if (!is.logical(inflation)) {
    stop("inflation has to be either TRUE or FALSE!")
  }
  if (inflation) {
    
    usa_cpi <- NULL
    data(usa_cpi, envir = environment())
    
    if(!(base_year %in% usa_cpi$Year)) {
      stop("year for inflation adjustment should be within the range ", 
           usa_cpi$Year[1], " - ", usa_cpi$Year[nrow(usa_cpi)], "\n")  
    } 
  }
  
  if (sample_only) {
    # get sample data
    emdat_sample <- NULL
    data(emdat_sample, envir = environment())
    
    out_df <- emdat_sample
    
  } else {    
    # get complete data from bitbucket    
    emdat_cleaned <- NULL
    
    emdat_url <- "https://bitbucket.org/rationshop/packages/raw/master/emdat_cleaned_v03.txt"
    if(url.exists(emdat_url, ssl.verifypeer = FALSE)) {
      message("downloading data from bitbucket. might take a few moments...")
      emdat_data <- getURL(emdat_url, ssl.verifypeer = FALSE)    
      emdat_cleaned <- read.csv(text = emdat_data, header = TRUE, quote = "", as.is = TRUE, sep = "\t")
    } else {
      stop("URL for the complete EMDAT data does not exist!")
    }
    
    out_df <- emdat_cleaned
  }
                            
    
  # adjustment for inflation
  if (inflation) {
    # cpi for the base year
    base_cpi <- usa_cpi$CPI[which(usa_cpi$Year == base_year)]
    # cpi for all the records based on begin year
    Fn_Get_CPI <- function(yr) {
      ifelse(yr %in% seq(usa_cpi$Year[1], usa_cpi$Year[nrow(usa_cpi)]), 
             usa_cpi$CPI[which(usa_cpi$Year == yr)],
             NA)      
    }
    curr_cpi <- vapply(out_df$Year, FUN = Fn_Get_CPI, FUN.VALUE = c(1))
    
    # adjustment factor
    adj_factor <- base_cpi / curr_cpi
    
    adj_damage <- paste0("Damage_Adjusted_", base_year)
    out_df[, adj_damage] <- out_df$EstDamage * adj_factor
  }
  
  return (out_df)
}
 