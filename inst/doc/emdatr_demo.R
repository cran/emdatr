## ----, echo = FALSE, message = FALSE-------------------------------------
knitr::opts_chunk$set(
  comment = "#>",
  error = FALSE,
  tidy = FALSE)

## ----, message = FALSE---------------------------------------------------
library(emdatr)
library(RCurl)
library(ggplot2)
library(plyr)

## ------------------------------------------------------------------------
losses_2014 <- extract_emdat()

dim(losses_2014)
head(losses_2014)

## ------------------------------------------------------------------------
losses_all <- extract_emdat(sample_only = FALSE, inflation = TRUE)

## ------------------------------------------------------------------------
nat_data <- losses_all[losses_all$Group %in% c("Climatological", "Geophysical", 
                                               "Hydrological", "Meteorological"), ]
nat_data <- droplevels(nat_data)

# assign missing value to 0s before using cbind in aggregate
nat_data$Killed[is.na(nat_data$Killed)] <- 0
nat_data$TotAffected[is.na(nat_data$TotAffected)] <- 0

nat_data$Year <- as.factor(nat_data$Year)

## ------------------------------------------------------------------------
gfx_deaths <- aggregate(cbind(Killed, TotAffected) ~ Year, data = nat_data, FUN = sum)
# total in millions
gfx_deaths$Total <- (gfx_deaths$Killed + gfx_deaths$TotAffected)/10^6
gfx_deaths <- gfx_deaths[, c("Year", "Total")]
gfx_deaths <- gfx_deaths[gfx_deaths$Year %in% seq(1990, 2013), ]
gfx_deaths <- droplevels(gfx_deaths)

## ------------------------------------------------------------------------
gfx_bar <- ggplot(gfx_deaths, aes(x = Year, y = Total))
gfx_bar <- gfx_bar + geom_bar(position = "dodge", stat = "identity", fill = "blue")
gfx_bar <- gfx_bar + ylab("Reported Victims (in Millions)")
gfx_bar <- gfx_bar + ylim(0, 800)
gfx_bar <- gfx_bar + theme(axis.text.x = element_text(angle = 45, hjust = 1))
gfx_bar <- gfx_bar + geom_text(aes(label = round(Total), hjust = 0.5, vjust = 0), size = 4)

plot(gfx_bar)

## ------------------------------------------------------------------------
gfx_events <- as.data.frame(table(nat_data$Year), stringsAsFactors = FALSE)
colnames(gfx_events) <- c("Year", "Total_Events")

gfx_events <- gfx_events[gfx_events$Year >= 1990 & gfx_events$Year <= 2013, ]

gfx_events[gfx_events$Year == 2002, ]

## ------------------------------------------------------------------------
gfx_line <- ggplot(gfx_events, aes(x = Year, y = Total_Events, group = 1))
gfx_line <- gfx_line + geom_line()
gfx_line <- gfx_line + ylab("Disasters Per Year")
gfx_line <- gfx_line + ylim(0, 500)
gfx_line <- gfx_line + theme(axis.text.x = element_text(angle = 45, hjust = 1))

plot(gfx_line)

## ------------------------------------------------------------------------
Fn_Get_Top_Countries <- function(input_df, var_name, plot_title) {
    var_vec <- c("Events", "EstDamage", "TotAffected", "Killed")
    stopifnot(identical(colnames(input_df), colnames(nat_data)))
    stopifnot(var_name %in% var_vec)

    fun_name <- "sum"
    if (var_name == "Events") {
        fun_name <- "length"
        var_name <- "Year"
    }

    # summary by country per natural disaster group
    data_by_group <- aggregate(as.formula(paste(var_name, " ~ ISO_cntry + Group")), 
        data = input_df, FUN = fun_name)
    colnames(data_by_group) <- c("Country", "Group", var_name)

    # totals by country
    data_agg <- aggregate(as.formula(paste(var_name, " ~ ISO_cntry")), data = input_df, 
        FUN = fun_name)
    colnames(data_agg) <- c("Country", "Totals")
    data_agg <- data_agg[order(data_agg$Totals, decreasing = TRUE), ]
    cntrys_10 <- data_agg$Country[1:10]

    # merge above two data frames
    out_df <- merge(data_by_group, data_agg, by = "Country")
    out_df <- out_df[order(out_df$Totals, decreasing = TRUE), ]

    out_df <- out_df[out_df$Country %in% cntrys_10, ]
    out_df <- droplevels(out_df)

    out_df$Country <- factor(out_df$Country, levels = rev(cntrys_10))
    # percentage share
    out_df$Pers <- out_df[, var_name] * 100/out_df$Totals

    return(out_df)
}

## ------------------------------------------------------------------------
nat_2013 <- nat_data[nat_data$Year == 2013, ]
nat_2013 <- droplevels(nat_2013)

gfx_2013_counts <- Fn_Get_Top_Countries(nat_2013, "Events")

head(gfx_2013_counts, 10)

## ------------------------------------------------------------------------
gfx_bar <- ggplot(gfx_2013_counts, aes(x = Country, y = Year, group = Group))
gfx_bar <- gfx_bar + geom_bar(aes(fill = Group), position = "stack", stat = "identity")
gfx_bar <- gfx_bar + ylab("Number of Events") + xlab(NULL)
gfx_bar <- gfx_bar + coord_flip()

plot(gfx_bar)

## ------------------------------------------------------------------------
gfx_2013_losses <- Fn_Get_Top_Countries(nat_2013, "EstDamage")
head(gfx_2013_losses, 10)

## ------------------------------------------------------------------------
gfx_pie <- ggplot(gfx_2013_losses, aes(x = "", y = Pers, fill = Group))
gfx_pie <- gfx_pie + facet_wrap(~Country)
gfx_pie <- gfx_pie + geom_bar(width = 1, stat = "identity")
gfx_pie <- gfx_pie + coord_polar(theta = "y")
gfx_pie <- gfx_pie + theme(axis.ticks = element_blank(), axis.text.y = element_blank(), 
    axis.text.x = element_blank())
gfx_pie <- gfx_pie + xlab("") + ylab("")

plot(gfx_pie)

## ------------------------------------------------------------------------
gfx_reg1 <- ddply(nat_2013[, c("EstDamage", "Group", "region")], 
                  .(region, Group), 
                  summarize, 
                  tot_by_group = sum(EstDamage, na.rm = TRUE))
gfx_reg2 <- ddply(nat_2013[, c("EstDamage", "Group", "region")], 
                  .(Group), 
                  summarize,                 
                  tot_by_reg = sum(EstDamage, na.rm = TRUE))
gfx_reg <- merge(gfx_reg1, gfx_reg2, by = "Group", all.x = TRUE)
gfx_reg$share <- gfx_reg$tot_by_group * 100 / gfx_reg$tot_by_reg

head(gfx_reg)

## ------------------------------------------------------------------------
gfx_bar <- ggplot(gfx_reg, aes(x = Group, y = share, group = region))
gfx_bar <- gfx_bar + geom_bar(aes(fill = Group), position = "dodge", stat = "identity")
gfx_bar <- gfx_bar + facet_wrap(~region, scales = "free_y")
gfx_bar <- gfx_bar + ylab("Percent Share") + xlab(NULL)
gfx_bar <- gfx_bar + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

plot(gfx_bar)

