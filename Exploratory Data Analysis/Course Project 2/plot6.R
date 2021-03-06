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


vehicles <- filter(SCC, grepl("[Vv]ehicle", SCC.Level.Two) | grepl("[Vv]ehicle", EI.Sector)) %>% 
				select(SCC)

data.tmp <- filter(NEI, fips=="24510" | fips == "06037") %>% 
		mutate(SCC=factor(SCC), city=ifelse(fips=="24510", "Baltimore City", "Los Angeles County")) %>% 
		filter(SCC %in% vehicles$SCC)
		
data <- filter(data.tmp, !is.na(Emissions)) %>% 
		group_by(city, year) %>% 
		summarise(sm=sum(Emissions)) 
	
png(file ="plot6.png", bg="white", width=480, height=480)

g <- ggplot(data, aes(year, sm, color=factor(city))) +
	geom_line(size=2, alpha=1/4) +
	geom_point(size = 4, alpha = 1/2)  +			
	labs(title = "Summarized vehicle emissions\nby year and sector\n(Baltimore City vs. Los Angeles County)") +
	labs(x = "Year", y = "PM2.5 (tons)") +	
	theme(legend.title=element_blank()) +
	scale_y_continuous(labels = comma) 
	
print(g)	
dev.off()

rm(vehicles)
rm(data.tmp)
rm(data)