if(!exists("NEI")){
	NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
SCC <- readRDS("Source_Classification_Code.rds")
}

if (!require("dplyr")) {
  install.packages("dplyr")
}

if (!require("ggplot2")) {
  install.packages("ggplot2")
}
if (!require("scales")) {
  install.packages("scales")
}
	
require("dplyr")
require("ggplot2")
require("scales")


mobileSector <- filter(SCC, grepl("Mobile", EI.Sector)) %>% select( SCC, EI.Sector)

data.tmp <- filter(NEI, fips=="24510" | fips == "06037") %>% 
		mutate(SCC=factor(SCC), city=ifelse(fips=="24510", "Baltimore City", "Los Angeles County")) %>% 
		filter(SCC %in% mobileSector$SCC)
		
data <- filter(data.tmp, !is.na(Emissions)) %>% 
		group_by(city, year) %>% 
		summarise(sm=sum(Emissions)) 
	
png(file ="plot6.png", bg="white", width=480, height=480)

g <- ggplot(data, aes(year, sm, color=factor(city))) +
	geom_line(size=2, alpha=1/4) +
	geom_point(size = 4, alpha = 1/2)  +			
	facet_wrap(~city, ncol=1) +	
	labs(title = "Summarized mobile emissions\nby year and sector\n(Baltimore City vs. Los Angeles County)") +
	labs(x = "Year", y = "PM2.5 (tons)") +	
	scale_y_continuous(labels = comma) +
	theme(legend.position="none") 
	
print(g)	
dev.off()

rm(mobileSector)
rm(data.tmp)
rm(data)