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


coalSector <- filter(SCC, grepl("Coal", EI.Sector)) %>% select( SCC, EI.Sector)

data.tmp <- mutate(NEI, SCC=factor(SCC)) %>% 
		filter(SCC %in% coalSector$SCC)
		
data.merged <- merge(data.tmp, coalSector, by.x="SCC", by.y="SCC", all=TRUE)
data <- filter(data.merged, !is.na(Emissions)) %>% 
		group_by(EI.Sector, year) %>% 
		summarise(sm=sum(Emissions)) 
	
png(file ="plot4.png", bg="white", width=480, height=480)

g <- ggplot(data, aes(year, sm, color=factor(EI.Sector))) +
	geom_line(size=2, alpha=1/4) +
	geom_point(size = 4, alpha = 1/2)  +		
	facet_wrap(~EI.Sector, ncol=1) +	
	labs(title = "Summarized coal emissions by year and sector (US)") +
	labs(x = "Year", y = "PM2.5 (tons)") +
	#labs(color = "Sector") +
	scale_y_continuous(labels = comma) +
	theme(legend.position="none") 
	
print(g)	
dev.off()

rm(coalSector)
rm(data.tmp)
rm(data.merged)
rm(data)