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
	
require("dplyr")
require("ggplot2")
	
data <- filter(NEI, fips=="24510") %>% group_by(type, year) %>% summarise(sm=sum(Emissions))

png(file ="plot3.png", bg="white", width=480, height=480)

# good solid solution
#g <- ggplot(data, aes(year, sm)) +
#	geom_line(color="steelblue", size=2, alpha=1/8) +
#	geom_point(color="steelblue", size = 4, alpha = 1/2)  +
#	#facet_grid(~type) +
#	facet_wrap(~type, ncol=1) +
#	labs(title = "Summarized emissions by year for Baltimore City per type") +
#	labs(x = "Year", y = "Emmissions (tons)")
	
g <- ggplot(data, aes(year, sm, color=factor(type))) +
	geom_line(size=2, alpha=1/4) +
	geom_point(size = 4, alpha = 1/2)  +	
	facet_wrap(~type, ncol=1) +	
	labs(title = "Summarized emissions by year for 'Baltimore City' per type") +
	labs(x = "Year", y = "PM2.5 (tons)") +
	labs(colour = "Types")


# one chart with different lines inside	
#g <- ggplot(data, aes(year, sm, color=factor(type))) +
#	geom_line( size=2, alpha=1/8) +
#	geom_point(size = 4, alpha = 1/2)  +
#	labs(title = "Summarized emissions by year for Baltimore City per type") +
#	labs(x = "Year", y = "Emmissions (tons)")

print(g)	
dev.off()