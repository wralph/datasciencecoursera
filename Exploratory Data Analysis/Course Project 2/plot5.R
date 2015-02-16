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

data.tmp <-filter(NEI, fips=="24510") %>% 
		mutate(SCC=factor(SCC)) %>% 
		filter(SCC %in% vehicles$SCC)
		
data.merged <- merge(data.tmp, vehicles, by.x="SCC", by.y="SCC", all=TRUE)
data <- filter(data.merged, !is.na(Emissions)) %>% 
		group_by(year) %>% 
		summarise(sm=sum(Emissions)) 
	
png(file ="plot5.png", bg="white", width=480, height=480)

g <- ggplot(data, aes(year, sm)) +
	geom_line(size=2, alpha=1/4) +
	geom_point(size = 4, alpha = 1/2)  +			
	labs(title = "Summarized vehicle emissions by year\n(Baltimore City)") +
	labs(x = "Year", y = "PM2.5 (tons)") +	
	scale_y_continuous(labels = comma) +
	theme(legend.position="none") 

	
print(g)	
dev.off()

rm(vehicles)
rm(data.tmp)
rm(data.merged)
rm(data)