### R code from vignette source 'emdatr.Rnw'

###################################################
### code chunk number 1: emdatr.Rnw:66-70
###################################################
require(emdatr)
require(RCurl)
require(ggplot2)
require(plyr)


###################################################
### code chunk number 2: emdatr.Rnw:75-79
###################################################
losses_2013 <- extract_emdat()

dim(losses_2013)
head(losses_2013)


###################################################
### code chunk number 3: emdatr.Rnw:85-89
###################################################
losses_all <- extract_emdat(sample_only = FALSE, inflation = TRUE)

dim(losses_all)
head(losses_all)


###################################################
### code chunk number 4: emdatr.Rnw:100-109
###################################################
nat_data <- losses_all[losses_all$Group %in% c("climatological", "geophysical", 
    "hydrological", "meteorological"), ]
nat_data <- droplevels(nat_data)

# assign missing value to 0s before using cbind in aggregate
nat_data$Killed[is.na(nat_data$Killed)] <- 0
nat_data$TotAffected[is.na(nat_data$TotAffected)] <- 0

nat_data$Year <- as.factor(nat_data$Year)


###################################################
### code chunk number 5: emdatr.Rnw:116-123
###################################################
gfx_deaths <- aggregate(cbind(Killed, TotAffected) ~ Year, data = nat_data, 
    FUN = sum)
# total in millions
gfx_deaths$Total <- (gfx_deaths$Killed + gfx_deaths$TotAffected)/10^6
gfx_deaths <- gfx_deaths[, c("Year", "Total")]
gfx_deaths <- gfx_deaths[gfx_deaths$Year %in% seq(1990, 2012), ]
gfx_deaths <- droplevels(gfx_deaths)


###################################################
### code chunk number 6: emdatr.Rnw:128-135
###################################################
gfx_bar <- ggplot(gfx_deaths, aes(x = Year, y = Total))
gfx_bar <- gfx_bar + geom_bar(position = "dodge", stat = "identity", fill = "blue")
gfx_bar <- gfx_bar + ylab("Reported Victims (in Millions)")
gfx_bar <- gfx_bar + ylim(0, 800)
gfx_bar <- gfx_bar + theme(axis.text.x = element_text(angle = 45, hjust = 1))
gfx_bar <- gfx_bar + geom_text(aes(label = round(Total), hjust = 0.5, vjust = 0), 
    size = 4)


###################################################
### code chunk number 7: fig1
###################################################
print(gfx_bar)


###################################################
### code chunk number 8: emdatr.Rnw:150-156
###################################################
gfx_events <- as.data.frame(table(nat_data$Year), stringsAsFactors = FALSE)
colnames(gfx_events) <- c("Year", "Total_Events")

gfx_events <- gfx_events[gfx_events$Year >= 1990 & gfx_events$Year <= 2012, ]

gfx_events[gfx_events$Year == 2002, ]


###################################################
### code chunk number 9: emdatr.Rnw:162-167
###################################################
gfx_line <- ggplot(gfx_events, aes(x = Year, y = Total_Events, group = 1))
gfx_line <- gfx_line + geom_line()
gfx_line <- gfx_line + ylab("Disasters Per Year")
gfx_line <- gfx_line + ylim(0, 500)
gfx_line <- gfx_line + theme(axis.text.x = element_text(angle = 45, hjust = 1))


###################################################
### code chunk number 10: fig2
###################################################
print(gfx_line)


###################################################
### code chunk number 11: emdatr.Rnw:184-220
###################################################
Fn_Get_Top_Countries <- function(input_df, var_name, plot_title) {
    var_vec <- c("Events", "EstDamage", "TotAffected", "Killed")
    stopifnot(colnames(input_df) == colnames(nat_data))
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


###################################################
### code chunk number 12: emdatr.Rnw:225-231
###################################################
nat_2012 <- nat_data[nat_data$Year == 2012, ]
nat_2012 <- droplevels(nat_2012)

gfx_2012_counts <- Fn_Get_Top_Countries(nat_2012, "Events")

head(gfx_2012_counts, 10)


###################################################
### code chunk number 13: emdatr.Rnw:236-240
###################################################
gfx_bar <- ggplot(gfx_2012_counts, aes(x = Country, y = Year, group = Group))
gfx_bar <- gfx_bar + geom_bar(aes(fill = Group), position = "stack", stat = "identity")
gfx_bar <- gfx_bar + ylab("Number of Events") + xlab(NULL)
gfx_bar <- gfx_bar + coord_flip()


###################################################
### code chunk number 14: fig3
###################################################
print(gfx_bar)


###################################################
### code chunk number 15: emdatr.Rnw:255-257
###################################################
gfx_2012_losses <- Fn_Get_Top_Countries(nat_2012, "EstDamage")
head(gfx_2012_losses, 10)


###################################################
### code chunk number 16: emdatr.Rnw:262-269
###################################################
gfx_pie <- ggplot(gfx_2012_losses, aes(x = "", y = Pers, fill = Group))
gfx_pie <- gfx_pie + facet_wrap(~Country)
gfx_pie <- gfx_pie + geom_bar(width = 1, stat = "identity")
gfx_pie <- gfx_pie + coord_polar(theta = "y")
gfx_pie <- gfx_pie + theme(axis.ticks = element_blank(), axis.text.y = element_blank(), 
    axis.text.x = element_blank())
gfx_pie <- gfx_pie + xlab("") + ylab("")


###################################################
### code chunk number 17: fig4
###################################################
print(gfx_pie)


###################################################
### code chunk number 18: emdatr.Rnw:289-301
###################################################
gfx_reg1 <- ddply(nat_2012[, c("EstDamage", "Group", "region")], 
                  .(region, Group), 
                  summarize, 
                  tot_by_group = sum(EstDamage, na.rm = TRUE))
gfx_reg2 <- ddply(nat_2012[, c("EstDamage", "Group", "region")], 
                  .(Group), 
                  summarize,                 
                  tot_by_reg = sum(EstDamage, na.rm = TRUE))
gfx_reg <- merge(gfx_reg1, gfx_reg2, by = "Group", all.x = TRUE)
gfx_reg$share <- gfx_reg$tot_by_group * 100 / gfx_reg$tot_by_reg

head(gfx_reg)


###################################################
### code chunk number 19: emdatr.Rnw:306-311
###################################################
gfx_bar <- ggplot(gfx_reg, aes(x = Group, y = share, group = region))
gfx_bar <- gfx_bar + geom_bar(aes(fill = Group), position = "dodge", stat = "identity")
gfx_bar <- gfx_bar + facet_wrap(~region, scales = "free_y")
gfx_bar <- gfx_bar + ylab("Percent Share") + xlab(NULL)
gfx_bar <- gfx_bar + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())


###################################################
### code chunk number 20: fig5
###################################################
print(gfx_bar)


###################################################
### code chunk number 21: emdatr.Rnw:333-347 (eval = FALSE)
###################################################
## losses_cntry <- ddply(losses_2013, 
##                       .(ISO_alpha3), 
##                       summarize, 
##                       total = sum(EstDamage, na.rm = TRUE))
## 
## # remove "X__X" introduced during the cleaning process
## losses_cntry <- losses_cntry[losses_cntry$ISO_alpha3 != "X__X", ]
## 
## # convert to billions; exclude 0s and NAs
## losses_cntry$total <- losses_cntry$total / 10^3
## losses_cntry <- losses_cntry[!is.na(losses_cntry$total) & losses_cntry$total > 0, ]
## 
## head(losses_cntry)
## summary(losses_cntry)


###################################################
### code chunk number 22: emdatr.Rnw:352-358 (eval = FALSE)
###################################################
## require(rworldmap)
## losses_cntry <- joinCountryData2Map(losses_cntry, 
##                                     joinCode = "ISO3", 
##                                     nameJoinColumn = "ISO_alpha3")
## 
## class(losses_cntry)


###################################################
### code chunk number 23: emdatr.Rnw:363-373 (eval = FALSE)
###################################################
## gfx_map <- mapCountryData(losses_cntry, 
##                           nameColumnToPlot = "total", 
##                           mapTitle = "", 
##                           colourPalette = "terrain",
##                           addLegend = FALSE)
## gfx_map <- do.call(addMapLegend,
##                    c(gfx_map,           
##                      legendLabels = "all",           
##                      legendWidth = 0.3,  
##                      sigFigs = 1))        


