# plot4
## This script, when sourced, creates a png file in the working directory with a 
## with four graphs: global active power, voltage, sub meterings and global
## reactive power, all them variating over the time between the days 01/02/2007
## and 02/02/2007.

## Downloading the file in the current WD if necessary
if(!file.exists("./data/household_power_consumption.txt")) {
      if(!file.exists("./data/household_power_consumption.zip")) {
            if(!dir.exists("./data")) {
                  dir.create("./data")
            }
            download.file(paste("https://d396qusza40orc.cloudfront.net/",
                                "exdata%2Fdata%2Fhousehold_power_consumption.zip"),
                          destfile = "./data/household_power_consumption.zip")
      }
      unzip("./data/household_power_consumption.zip", exdir = "./data")
}

## Importing data from the day 1/2/2007 to 2/2/2007
energy <- read.table("./data/household_power_consumption.txt", 
                     sep = ";", header = FALSE, na.strings = "?", 
                     colClasses = c(rep("character", 2), rep("numeric", 7)),
                     skip = 66637, nrows = 2880)
var_names <- read.table("./data/household_power_Consumption.txt", 
                        sep = ";", header = FALSE, na.strings = "?",
                        colClasses = "character", nrows = 1)
names(energy) <- var_names

## Converting dates and times
energy$Date_time <- strptime(paste(energy$Date, energy$Time), 
                             "%d/%m/%Y %H:%M:%S")
energy <- energy[, c(10, seq(3, 9, by = 1))]

## Plotting
png(filename = "plot4.png")
par(mfrow = c(2, 2))
### first graph
with(energy, {
      plot(Date_time, Global_active_power,type = "n", xlab = "",
           ylab = "Global Active Power")
      lines(Date_time, Global_active_power)
})
### second graph
with(energy, {
      plot(Date_time, Voltage, type = "n", xlab = "datetime",
           ylab = "Voltage")
      lines(Date_time, Voltage)
})
### third graph
with(energy, {
      plot(Date_time, Sub_metering_1, type = "n", xlab = "", 
           ylab = "Energy sub metering")
      lines(Date_time, Sub_metering_1, col = "black")
      lines(Date_time, Sub_metering_2, col = "red")
      lines(Date_time, Sub_metering_3, col = "blue")
      legend("topright", bty = "n", lty = 1, col = c("black", "red", "blue"), 
             legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
})
### fourth graph
with(energy, {
      plot(Date_time, Global_reactive_power, type = "n", xlab = "datetime",
           ylab = "Global_reactive_power")
      lines(Date_time, Global_reactive_power, alpha = 0.5)
})
dev.off()