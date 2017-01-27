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
# using dplyr functions to create a data frame containing
# sum of the emissions for each year (1999, 2002, 2005, 2008)
subNEI <- as.data.frame(select(NEI, fips, Emissions, type, year) %>%
                            filter(fips == "24510") %>%
                            #mutate(Emissions = Emissions/1000) %>%
                            group_by(year, type) %>%
                            summarize(Emissions = sum(Emissions, na.rm = TRUE)) %>%
                            arrange(type))
# rounding up the converted kilotons to 2 deciaml
subNEI$Emissions <- round(subNEI$Emissions,2)
# saving the plot in png file
png("./plot3.png", width = 580, height = 480)
# creating the ggplot2 plot
ggplot(subNEI, aes(x = year, y = Emissions)) + 
    geom_line() + facet_grid(. ~ type) + 
    geom_smooth(method = "lm") + 
    labs(x = "Year", y = "PM2.5 in Tons", title = "Baltimore City Increases/Decreases of Total PM2.5 Sectioned by Type from 1999-2008")
# closing the png file
dev.off()