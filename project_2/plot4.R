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
# getting the index of all the rows that contain the phrase "Coal"
coalIndex <- which(apply(SCC, 1, function(x) any(grepl("Coal", x))))
# using dplyr select to create a data frame with SCC column
subSCC <- as.data.frame(select(SCC, SCC))
# finding the SCC values matched with indexes from coalIndex variable
subSCC$SCC <- as.character(subSCC$SCC)
sourceNumbers <- subSCC[coalIndex,1]
# creating a new data frame from NEI data and
# finding the matched SCC numbers with sourceNumbers (our 
# character vector containing extracted SCC numbers) ) and
# calculating the sum of pm2.5 emission per year
subNEI <- as.data.frame(select(NEI, SCC, Emissions, year) %>%
                            filter(SCC %in% sourceNumbers) %>%
                            mutate(Emissions = Emissions/1000) %>%
                            group_by(year) %>%
                            summarize(Emissions = sum(Emissions, na.rm = TRUE))
                        )
# rounding up the converted kilotons to 2 deciaml
subNEI$Emissions <- round(subNEI$Emissions,2)
# saving the plot in png file
png("./plot4.png", width = 580, height = 480)
# creating the ggplot2 plot
ggplot(subNEI, aes(x = year, y = Emissions)) + 
    geom_line() +
    geom_smooth(method = "lm") + 
    labs(x = "Year", y = "PM2.5(Kilotons)", title = "Emission Changes of Coal Combustion-related Sources Across U.S. from 1999-2008")
# closing the png file
dev.off()