plot3 <- function()
{
    # Repeatable Download - Fetch and unpack power consumption data.  Capture datetime.
        
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                  dest="household_power_consumption.zip",
                  method="curl")
        
    downloadTime <- Sys.time()
    
    unz("household_power_consumption.zip", "household_power_consumption.txt")
    
    unlink("household_power_consumption.zip")
    
    # Fetch header to allow source specified column names
    
    header <- read.table("household_power_consumption.txt", sep=";", stringsAsFactors=FALSE, nrows=1)
    
    # Load electric consumption data.  Filter rows for specific 2 day period.
        
    electricConsumption <- read.table(pipe('grep "^[1-2]/2/2007" "household_power_consumption.txt"'),
                                      col.names=header,
                                      sep=";", 
                                      na.strings="?", 
                                      stringsAsFactors=FALSE)
    
    # Combine source Date and Time.  Convert resulting character string to POSIXct class.
        
    electricConsumption$Time <- as.POSIXct(strptime(paste(electricConsumption$Date, 
                                                          electricConsumption$Time), 
                                                    format="%d/%m/%Y %H:%M:%S"))

    # Construct and externalize plot to png graphic device.
        
    png(filename="plot3.png")
    
    # Plot - 3 Sub Metering Readings over 2 day period
    
    with(electricConsumption, plot(Time, Sub_metering_1, 
                                   xlab="",
                                   ylab="Energy sub metering",
                                   type="n"))

    with(electricConsumption, lines(Time, Sub_metering_1, col = "black"))
    
    with(electricConsumption, lines(Time, Sub_metering_2, col = "red"))
    
    with(electricConsumption, lines(Time, Sub_metering_3, col = "blue"))
        
    legend("topright", 
           lty=c(1, 1, 1),
           col=c("black", "red", "blue"), 
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
    dev.off()
}