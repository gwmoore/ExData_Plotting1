###################################################################################################
# Prepare for file download

if (!file.exists("data")) {
  dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# download zip file
download.file(fileUrl, destfile = "./data/household_power_consumption.zip", method = "curl")

# extract zipped txt file

unzip("./data/household_power_consumption.zip", exdir = "./data")

# Review files

list.files("./data")
###################################################################################################
# Read electric power consumption data
# with first row as header and convert "?" representing missing numeric values to NA

elec_pwr_cnsmptn <- read.table("./data/household_power_consumption.txt",
                               sep = ";", header = TRUE, na.strings = "?",
                               colClasses = c(rep("character", 2), rep("numeric", 7)))

# convert the Time variable's values from character to POSIXct using both Date and Time variables
# assuming locale is Clamart, France, therefore setting tz = "CET"

elec_pwr_cnsmptn[, 2] <- as.POSIXct(strptime(paste(elec_pwr_cnsmptn[, 1], elec_pwr_cnsmptn[, 2],
                                                   sep = " "), "%d/%m/%Y %H:%M:%S"), tz = "CET")

# convert the Date variable's values from character to Date

elec_pwr_cnsmptn[, 1] <- as.Date(elec_pwr_cnsmptn[, 1], "%d/%m/%Y")

## subset the data: two day period in February, 2007 (February 1, 2007 -> February 2, 2007)

ss <- which(elec_pwr_cnsmptn$Date >= "2007-02-01" & elec_pwr_cnsmptn$Date <= "2007-02-02")

elec_pwr_cnsmptn_ss <- elec_pwr_cnsmptn[ss, ]

# Remove the indexing vector

rm(ss)
###################################################################################################
# Plot #2

# set up for single plot (1 x 1)

par(mfrow = c(1, 1))

# Plot (Line) of Global Active Power by Day of Week

plot(elec_pwr_cnsmptn_ss$Time,
     elec_pwr_cnsmptn_ss$Global_active_power,
     type = "l",
     xaxt = "n",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")

axis.POSIXct(side = 1, elec_pwr_cnsmptn_ss$Time)
###################################################################################################
# Save plot to PNG file

dev.copy(png, file = "plot2.png") ## Copy my plot to a PNG file in my working directory
dev.off()                         ## Don't forget to close the PNG device!