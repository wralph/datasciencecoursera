if(!exists("NEI")){
	NEI <- readRDS("summarySCC_PM25.rds")
}
if(!exists("SCC")){
SCC <- readRDS("Source_Classification_Code.rds")
}

if (!require("dplyr")) {
  install.packages("dplyr")
}
	
require("dplyr")
	
data <- filter(NEI, fips=="24510") %>% group_by(year) %>% summarise(sm=sum(Emissions))

png(file ="plot2.png", bg="white", width=480, height=480)

op <- par(mar = c(5,8,4,2) + 0.1)
with(data, plot(year, sm, type="b", pch=16, xlab="Year", ylab="", lwd=2, col="orangered", axes=FALSE))
axis(1, at = data$year, labels = data$year)
axis(2, at = data$sm, labels=format(data$sm, digits=2, nsmall=0, big.mark=","), las=1)
title(ylab = "Emmissions (tons)", line = 6)
box()
title(main = "Summarized emissions by year for Baltimore City")

par(op)

dev.off()