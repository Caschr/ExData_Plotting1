## Plot 1

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
  
    df$Date <- as.POSIXct(df$Date, format="%d/%m/%Y")
      startdate <- as.POSIXct("2007-02-01") ##Start and finish of the period we will be examining 
      finishdate <- as.POSIXct("2007-02-02")
  
    df[df$Date >= startdate & df$Date <= finishdate,]
}

makeplot <- function(input) {
  plotdata <- input$Global_active_power
  
  png(filename="plot1.png")
  hist(plotdata, col = "#FF2424", xlab = "Global Active Power (kilowatts)", main="Global Active Power")
  dev.off()
}