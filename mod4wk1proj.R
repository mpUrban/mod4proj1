library(data.table)
library(lubridate)


zipUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
if(!file.exists('./data')){dir.create('./data')}
download.file(zipUrl, destfile = './data/dataset.zip', method = 'curl')
unzip(zipfile = './data/dataset.zip', exdir = './data/')


fn <- './data/household_power_consumption.txt'
hpw1 <- data.table::fread(fn, nrows = 20)
#?fread
hpwNames <- names(hpw1)

#We will only be using data from the dates 2007-02-01 and 2007-02-02.
startDate <- '1/2/2007'
rows2read <- 2880 #1440 minues in a day x 2 days

hpw2 <- data.table::fread(fn, skip = startDate, 
                          nrows = rows2read, 
                          na.strings="?")

# fread for some reason removed colnames
names(hpw2) <- hpwNames


# Plot 1, Global active power vs frequency, histogram

png("plot1.png", width=480, height=480)

hist(hpw2$Global_active_power,
     main = 'Global Active Power',
     xlab = 'Global Active Power (kilowatts)',
     col = 'Red')

dev.off()


# Plot 2 - day of week vs global actdive power, line plot 

#hpw2$Date <- as.Date(hpw2$Date)

hpw2$dateTime <- as.POSIXct(
  paste(hpw2$Date, hpw2$Time), format = "%d/%m/%Y %H:%M:%S")

png("plot2.png", width=480, height=480)

plot(x = hpw2$dateTime, 
     y = hpw2$Global_active_power, 
     type="l", xlab="",
     ylab="Global Active Power (kilowatts)")

dev.off()


# Plot 3 - time vs energy sub metering

png("plot3.png", width=480, height=480)

plot(hpw2$dateTime, hpw2$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(hpw2$dateTime, hpw2$Sub_metering_2,col="red")
lines(hpw2$dateTime, hpw2$Sub_metering_3,col="blue")
legend("topright"
       , col=c("black","red","blue")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       ,lty=c(1,1), lwd=c(1,1))

dev.off()


# Plot 4


png("plot4.png", width=480, height=480)

par(mfrow=c(2,2))


# Plot 1, Global active power vs frequency, histogram

hist(hpw2$Global_active_power,
     main = 'Global Active Power',
     xlab = 'Global Active Power (kilowatts)',
     col = 'Red')


# Plot 2 - day of week vs global actdive power, line plot 

#hpw2$Date <- as.Date(hpw2$Date)

hpw2$dateTime <- as.POSIXct(
  paste(hpw2$Date, hpw2$Time), format = "%d/%m/%Y %H:%M:%S")

plot(x = hpw2$dateTime, 
     y = hpw2$Global_active_power, 
     type="l", xlab="",
     ylab="Global Active Power (kilowatts)")


# Plot 3 - time vs energy sub metering

plot(hpw2$dateTime, hpw2$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(hpw2$dateTime, hpw2$Sub_metering_2,col="red")
lines(hpw2$dateTime, hpw2$Sub_metering_3,col="blue")
legend("topright"
       , col=c("black","red","blue")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       ,lty=c(1,1), lwd=c(1,1))


plot(hpw2$dateTime, 
     hpw2$Global_reactive_power, 
     type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()
