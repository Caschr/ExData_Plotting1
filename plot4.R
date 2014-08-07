## Plot 4

createPlot <- function(dataURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"){
        df <- getData(dataURL)
        makeplot()

}

getData <- function(dataURL){
        permwd <- getwd()

        if(!exists("plotdata")) {

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
        unlink(zipdir, recursive=TRUE) ## deletes the temp files and sets wd back to original
        unlink(downfile)
        setwd(permwd)

        df$datetime <- paste(df$Date, df$Time, sep=" ")
        df$Date <- as.POSIXct(df$Date, format="%d/%m/%Y")
        df$datetime <- as.POSIXct(df$datetime, format="%d/%m/%Y %H:%M:%S")

        ##Start and finish of the period we will be examining
        startdate <- as.POSIXct("2007-02-01")
        finishdate <- as.POSIXct("2007-02-02")

        plotdata <<- df[df$Date >= startdate & df$Date <= finishdate,]
        }

}

makeplot <- function(input) {
        png(filename="plot4.png")
        par(mfrow=c(2,2))

        ## Plot 1 (top left)
        with(plotdata, plot(Global_active_power ~ datetime, type="l", ylab="Global Active Power", xlab=""))

        ##Plot 2 (top right)
        with(plotdata, plot(Voltage ~ datetime, type="l"))

        ## Plot 3 (bottom left)
        with(plotdata, {
                plot(Sub_metering_1 ~ datetime, type="l", ylab="Energy sub metering", col = "black", xlab="");
                lines(Sub_metering_2 ~ datetime, col = "red");
                lines(Sub_metering_3 ~ datetime, col = "blue")
        })
        legend(x="topright", lty=1, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), bty="n")

        ## Plot 4
        with(plotdata, plot(Global_reactive_power ~ datetime, type="l"))

        par(mfrow=c(1,1))
        dev.off()
}