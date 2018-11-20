# install packages

install.packages("ggplot2")
install.packages("grid")
install.packages("gridExtra")

# Check if data directory exists
if (file.exists("./data")) {
  print ("./data Directory Exists")
} else {
  dir.create(file.path(".", "data"))
  print ("Created ./data directory")
}

# Check if data files already downloaded
if (file.exists("data/summarySCC_PM25.rds") & file.exists("data/Source_Classification_Code.rds")) {
  print ("Using existing summarySCC_PM25.rds and Source_Classification_Code.rds")
} else {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, "./data/temp.zip")
  # Unzipping file
  unzip("./data/temp.zip")
  
  # Move files to the data directory
  file.copy(c("Source_Classification_Code.rds","summarySCC_PM25.rds"), "./data")
  file.remove(c("Source_Classification_Code.rds","summarySCC_PM25.rds"))
  print ("Downloaded and unzipped the summarySCC_PM25.rds and Source_Classification_Code.rds files")
}

# Reading the data files
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Aggregating emissions by year
data <- aggregate(NEI[, "Emissions"], by=list(NEI$year), sum)

# Assign names to colums of aggregated data
colnames(data) <- c("Year", "Total")

# Generate the grphics. Using expression() to generate subscript font for y-axis
png("plot1.png", width=480, height=480)
plot(data, type = "o", main = "Total PM2.5 Emissions", xlab = "Year", ylab = "PM2.5 Emissions", pch = 19, col = "darkblue", lty = 6)
dev.off()