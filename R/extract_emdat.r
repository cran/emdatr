#' Extract desired data from pre-processed EM-DAT data
#'
#' @param years vector of years for which data is desired, permissible range 1900 - 2013
#' @param inflation logical indicating whether or not inflation adjustment is desired
#' @param base_year year on which the inflation adjustment is based on
#' @export
#' @examples
#' # EM-DAT data for all of 2012
#' losses_2012 <- emdat_extract()
#' 
#' # EM-DAT data for all of 2012, inflation-adjusted 
#' losses_2012_adj <- emdat_extract(inflation = TRUE)
#' 
#' # EM-DAT data for 1960-70, inflation-adjusted 
#' losses_1960s <- emdat_extract(years = c(1960:1970), inflation = TRUE)

emdat_extract <- function(years = c(2012, 2012), inflation = FALSE, base_year = 2012) {
                            
  # invoke data
  emdat_data <- NULL
  usa_cpi <- NULL
  data(emdat_data, envir = environment())
  data(usa_cpi, envir = environment())
  
  # sanity checks
  year_vec <- c(1900:2013)
  if(!(all(years %in% year_vec))) {
    stop("year has to be within the range ", year_vec[1], " - ", 
         year_vec[length(year_vec)], "\n")
  }
  if (inflation) {
    if(!(base_year %in% usa_cpi$Year)) {
      stop("year for inflation adjustment should be within the range ", 
           usa_cpi$Year[1], " - ", usa_cpi$Year[nrow(usa_cpi)], "\n")  
    } 
  }
  
  # extract subset of emdat for the years of interest
  out_df <- subset(emdat_data, emdat_data$Year %in% years)
  out_df <- droplevels(out_df)
  
  # adjustment for inflation
  if (inflation) {
    
    # cpi for the base year
    base_cpi <- usa_cpi$CPI[which(usa_cpi$Year == base_year)]
    # cpi for all the records based on begin year
    curr_cpi <- sapply(out_df$Year, FUN = function(x) usa_cpi$CPI[which(usa_cpi$Year == x)])
                       
    # adjustment factor
    adj_factor <- base_cpi / curr_cpi
    
    adj_damage <- paste0("Damage_Adjusted_", base_year)
    out_df[, adj_damage] <- out_df$EstDamage * adj_factor
  }
  
  return (out_df)
}
