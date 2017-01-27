# unziping the file, modify the directory names text with
# your actual directory folder, where the .zip file is located and
# where you would like to extract the file to
unzip("../data/exdata%2Fdata%2FNEI_data.zip", exdir = "../data/")
# reading/storing the two extracted files to two data.frame files
NEI <- readRDS("../data/summarySCC_PM25.rds")
SCC <- readRDS("../data/Source_Classification_Code.rds")
# installing and loading dplyr and ggplot2 package
install.packages("dplyr")
install.packages("ggplot2")
library(dplyr)
library(ggplot2)
# getting the index of all the rows (SCC) that contain the phrase "Vehicle"
vehicleIndex <- which(apply(SCC, 1, function(x) any(grepl("Vehicle", x))))
# using dplyr select to create a data frame with SCC column
subSCC <- as.data.frame(select(SCC, SCC))
# finding the SCC values matched with indexes from vehicleIndex variable
subSCC$SCC <- as.character(subSCC$SCC)
sourceNumbers <- subSCC[vehicleIndex,1]
# creating two new data frame for Baltimore City and Los Angeles County
# from NEI data and finding the matched SCC numbers with sourceNumbers (our 
# character vector containing extracted SCC numbers) ) and
# calculating the sum of pm2.5 emission per year
baltimorecityNEI <- as.data.frame(select(NEI, fips, SCC, Emissions, year) %>%
                            filter(SCC %in% sourceNumbers, fips == "24510") %>%
                            group_by(year) %>%
                            summarize(Emissions = sum(Emissions, na.rm = TRUE))
)
losangelescountyNEI <- as.data.frame(select(NEI, fips, SCC, Emissions, year) %>%
                            filter(SCC %in% sourceNumbers, fips == "06037") %>%
                            group_by(year) %>%
                            summarize(Emissions = sum(Emissions, na.rm = TRUE))
)
# rounding up the converted kilotons to 2 deciaml
baltimorecityNEI$Emissions <- round(baltimorecityNEI$Emissions,2)
losangelescountyNEI$Emissions <- round(losangelescountyNEI$Emissions,2)
# calculating and setting the range of the two data frames

rng <- range(baltimorecityNEI, losangelescountyNEI, na.rm = T)
# saving the plot in png file
png("./plot6.png", width = 680, height = 480)
# creating the basic plot
par(mfrow = c(1, 2))
plot(baltimorecityNEI$year, baltimorecityNEI$Emissions, xlab = "Year", 
     ylab = "PM2.5 (Tons)", 
     type = "o")#, ylim = rng)
model1 <- lm(Emissions ~ year,baltimorecityNEI)
abline(model1, lwd = 2, col = "green")
mtext("Greater Changes for Baltimore City Motor Vehicle Emissions")
plot(losangelescountyNEI$year, losangelescountyNEI$Emissions, xlab = "Year", 
     ylab = "PM2.5 (Tons)",
     type = "o")#, ylim = rng)
model2 <- lm(Emissions ~ year, losangelescountyNEI)
abline(model2, lwd = 2, col = "green")
mtext("Los Angeles County Motor Vehicle Emissions")
# closing the png file
dev.off()