setwd("C:/Users/mara1/Downloads/Soc_stats")
getwd()

library(ggplot2)
library(dplyr)
library(foreign)

## Create helper functions to read GSS data files

  read.dct <- function(dct, labels.included = "yes") {
      temp <- readLines(dct)
      temp <- temp[grepl("_column", temp)]
      switch(labels.included,
             yes = {
                 pattern <- "_column\\(([0-9]+)\\)\\s+([a-z0-9]+)\\s+(.*)\\s+%([0-9]+)[a-z]\\s+(.*)"
                 classes <- c("numeric", "character", "character", "numeric", "character")
                 N <- 5
                 NAMES <- c("StartPos", "Str", "ColName", "ColWidth", "ColLabel")
             },
             no = {
                 pattern <- "_column\\(([0-9]+)\\)\\s+([a-z0-9]+)\\s+(.*)\\s+%([0-9]+).*"
                 classes <- c("numeric", "character", "character", "numeric")
                 N <- 4
                 NAMES <- c("StartPos", "Str", "ColName", "ColWidth")
             })
      temp_metadata <- setNames(lapply(1:N, function(x) {
          out <- gsub(pattern, paste("\\", x, sep = ""), temp)
          out <- gsub("^\\s+|\\s+$", "", out)
          out <- gsub('\"', "", out, fixed = TRUE)
          class(out) <- classes[x] ; out }), NAMES)
      temp_metadata[["ColName"]] <- make.names(gsub("\\s", "", temp_metadata[["ColName"]]))
      temp_metadata
  }

  read.dat <- function(dat, metadata_var, labels.included = "yes") {
      read.fwf(dat, widths = metadata_var[["ColWidth"]], col.names = metadata_var[["ColName"]])
  }

## Use functions to transform GSS files into data frame
## One file has the raw data and the other has the metadata/ 
GSS_metadata <- read.dct("GSS.dct")
GSS_ascii <- read.dat("GSS.dat", GSS_metadata)

attr(GSS_ascii, "col.label") <- GSS_metadata[["ColLabel"]]
GSS <- GSS_ascii

## fix col names
names(GSS) <- tolower(names(GSS))
colnames(GSS)[2] <- "id"
colnames(GSS)[4] <- "class"

## Set blank or outlier values to NULL/NA
## Drop answers with fewer than 1000 rows
## Drop 0 since it is equivalent to NA
table(GSS$class, exclude= NULL)
table(GSS$health, exclude= NULL)
table(GSS$helpsick, exclude= NULL)


GSS$class[GSS$class>=5] <- NA
GSS$class[GSS$class==0] <- NA

GSS$health[GSS$health>=8] <- NA
GSS$health[GSS$health==0] <- NA

GSS$helpsick[GSS$helpsick>=8|GSS$helpsick==0] <- NA

table(GSS$class, exclude= NULL)
table(GSS$health, exclude= NULL)
table(GSS$helpsick, exclude= NULL)

## Recode variables 

## ERROR: the below code didn't relabel anything 
## and there are too few labels for the values present. 
## We also only need the numeric values for analysis. 
#GSS$helpsick[GSS$helpsick=="Government help"]<-1



GSS$health <- factor(GSS$health, labels = c("Excellent", "Good", "Fair","Poor"))
GSS$class <- factor(GSS$class, labels = c("Lower", "Working", "Middle", "Upper"))

table(GSS$class, exclude= NULL)
table(GSS$health, exclude= NULL)
table(GSS$helpsick, exclude= NULL)

## Export final data file
write.csv(GSS, "C:/Users/mara1/Downloads/Soc_stats/final.csv")


