plot2 <- function()
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
    
    png(filename="plot2.png")
    
    # Plot - Global Active Power over 2 day period. 
    
    plot(electricConsumption$Time, electricConsumption$Global_active_power, 
         xlab="",
         ylab="Global Active Power (kilowatts)", 
         type="l")
    
    # Close graphic device.
    
    dev.off()
}