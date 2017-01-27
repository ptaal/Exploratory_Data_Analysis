# unziping the file, modify the directory names text with
# your actual directory folder, where the .zip file is located and
# where you would like to extract the file to
unzip("../data/exdata%2Fdata%2FNEI_data.zip", exdir = "../data/")
# reading/storing the two extracted files to two data.frame files
NEI <- readRDS("../data/summarySCC_PM25.rds")
SCC <- readRDS("../data/Source_Classification_Code.rds")
# installing and loading dplyr package
install.packages("dplyr")
library(dplyr)
# using dplyr functions to create a data frame containing
# sum of the emissions for each year (1999, 2002, 2005, 2008)
subNEI <- as.data.frame(select(NEI, Emissions, year) %>%
                              mutate(Emissions = Emissions/1000000) %>%
                              group_by(year) %>%
                              summarize(Emissions = sum(Emissions, na.rm = TRUE)))
# rounding up the converted megatons to 2 deciaml
subNEI$Emissions <- round(subNEI$Emissions,2)
# saving the plot in png file
png("./plot1.png", width = 480, height = 480)
# creating the basic plot
plot(subNEI$year, subNEI$Emissions, xlab = "Year", 
     ylab = "PM2.5 in Megatons", main = "The U.S. 
     Total PM2.5 Emissions decreasing from 1999-2008", type = "o")
# closing the png file
dev.off()