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


#correct filter
coalSector <- filter(SCC, grepl("[Cc]oal", SCC.Level.Three) & grepl("[Cc]ombustion", SCC.Level.One) )  %>%
				#select(EI.Sector, SCC.Level.Three)  %>%
				select(SCC, EI.Sector)
#coalSector <- filter(SCC, grepl("Coal", EI.Sector)) %>% select( SCC, EI.Sector)

data.tmp <- mutate(NEI, SCC=factor(SCC)) %>% 
		filter(SCC %in% coalSector$SCC)
		
data.merged <- merge(data.tmp, coalSector, by.x="SCC", by.y="SCC", all=TRUE)
data <- filter(data.merged, !is.na(Emissions)) %>% 
		#group_by(EI.Sector, year) %>% 
		group_by(year) %>% 
		summarise(sm=sum(Emissions)) 
		
	
png(file ="plot4.png", bg="white", width=480, height=480)

# log or not log
#g <- ggplot(data, aes(year, sm, color=factor(EI.Sector))) +
##g <- ggplot(data, aes(year, log(sm), color=factor(EI.Sector))) +
#	geom_line(size=2, alpha=1/4) +
#	geom_point(size = 4, alpha = 1/2)  +		
#	#facet_wrap(~EI.Sector, ncol=1) +	
#	labs(title = "Summarized coal emissions by year and sector (US)") +
#	labs(x = "Year", y = "PM2.5 (tons)") +
#	#labs(color = "Sector") +
#	scale_y_continuous(labels = comma) #+
#	#theme(legend.position="none") 

g <- ggplot(data, aes(year, sm)) +
#g <- ggplot(data, aes(year, log(sm), color=factor(EI.Sector))) +
	geom_line(size=2, alpha=1/4) +
	geom_point(size = 4, alpha = 1/2)  +		
	#facet_wrap(~EI.Sector, ncol=1) +	
	labs(title = "Summarized coal emissions by year (US)") +
	labs(x = "Year", y = "PM2.5 (tons)") +
	#labs(color = "Sector") +
	scale_y_continuous(labels = comma) #+
	#theme(legend.position="none") 
	
print(g)	
dev.off()

rm(coalSector)
rm(data.tmp)
rm(data.merged)
rm(data)