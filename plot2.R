## Plot 2

createPlot <- function(dataURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"){
  df <- getData(dataURL)
  makeplot(df)
  
}

getData <- function(dataURL){
  permwd <- getwd()
  
  ##Downloading the file, unzipping it and reading
  message("Downloading data")
  
  downfile <- tempfile()
  zipdir <- tempfile()
  dir.create(zipdir)
  download.file(url=dataURL, destfile=downfile)
  unzip(downfile, exdir=zipdir)
  setwd(zipdir)
  
  message("Reading data")
  
  df <- read.table(file="household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")
  unlink(zipdir) ## deletes the temp files and sets wd back to original
  unlink(downfile)
  setwd(permwd)
  
  df$datetime <- paste(df$Date, df$Time, sep=" ")
  df$Date <- as.POSIXct(df$Date, format="%d/%m/%Y")
  df$datetime <- as.POSIXct(df$datetime, format="%d/%m/%Y %H:%M:%S")
  startdate <- as.POSIXct("2007-02-01") ##Start and finish of the period we will be examining 
  finishdate <- as.POSIXct("2007-02-02")
  
  df[df$Date >= startdate & df$Date <= finishdate,]
}

makeplot <- function(input) {
  plotdata <- input
  png(filename="plot2.png")
  
  plot(plotdata$Global_active_power ~ plotdata$datetime, type="l", ylab="Global Active Power (kilowatts)", xlab="")
  
  dev.off()
}