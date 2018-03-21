## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)

## ---- out.width = "400px"------------------------------------------------
knitr::include_graphics("rstudio.png")

## ----echo=TRUE, eval=FALSE, message=FALSE, warning=FALSE, include=TRUE----
## install.packages(c("dplyr", "tidyr", "ggplot2")) #install packages

## ----echo=T, message=FALSE, warning=FALSE--------------------------------
library(dplyr)   # package providing grammar of data manipulation
library(tidyr)   # package for reorganizing data
library(ggplot2) # package for plotting data

## ----echo=TRUE, eval=TRUE------------------------------------------------
rm(list=ls()) #clear workspace

## ----echo=TRUE-----------------------------------------------------------
ANT <- read.csv("ANT_young.csv", stringsAsFactors = FALSE) # read data from file
head(ANT, 6) # view the first 6 rows of ANT (young adults)

## ----echo=TRUE-----------------------------------------------------------
ANTOLD <- read.csv("ANT_old.csv", stringsAsFactors = FALSE) # read data from file
head(ANTOLD,6) # first 6 rows of ANT (old adults)

## ----echo=TRUE-----------------------------------------------------------
ANT_runsheet <- read.csv("ANT_runsheet.csv", stringsAsFactors = FALSE) # read data from file
head(ANT_runsheet, 20) # first 20 rows of the runsheet

## ----echo=TRUE-----------------------------------------------------------
str(ANT)          #structure of young sheet

## ----echo=TRUE-----------------------------------------------------------
str(ANTOLD)       #structure of old sheet

## ----echo=TRUE-----------------------------------------------------------
str(ANT_runsheet) #structure of runsheet

## ----echo=TRUE, warning = FALSE,message=FALSE----------------------------
# Make sure dplyr is loaded above
allANT <- bind_rows(ANT, ANTOLD) # combine rows together... 
                                 # this function will match based on column names

## ----echo=TRUE-----------------------------------------------------------
head(allANT,3) # view first 3 rows of the combined data.frame
tail(allANT,3) # view last 3 rows of the combined data.frame

## ----echo=TRUE-----------------------------------------------------------
head(ANT_runsheet)

## ----echo=TRUE-----------------------------------------------------------
allANT <- left_join(allANT, ANT_runsheet, by="subnum") # join the two datasets by subnum column

## ----echo=TRUE-----------------------------------------------------------
head(allANT,3)
tail(allANT,3)

## ----echo=TRUE-----------------------------------------------------------
allANT %>% select(flank)      # select and view the flank column
allANT %>% select(flank, cue) # select and view the flank and cue columns

## ----echo=TRUE-----------------------------------------------------------
allANT %>% group_by(flank) %>% summarise(N=n()) # Number of rows by flank

## ----echo=TRUE-----------------------------------------------------------
allANT %>% group_by(subnum,flank) %>% summarise(N=n()) # num rows by flank and subject

## ----echo=TRUE-----------------------------------------------------------
allANT %>% group_by(subnum) %>% summarise(age=first(age)) #first occur. of age by subject

## ----echo=TRUE-----------------------------------------------------------
allANT %>% group_by(group) %>% summarise(meanAge=mean(age)) # mean age by group

## ---- echo=TRUE----------------------------------------------------------
allANT %>% group_by(group) %>% summarise(n_distinct(subnum))

## ----echo=T--------------------------------------------------------------
allANT <- allANT %>% mutate(correctRT = ifelse(error == 0, rt, NA))

## ----echo=T--------------------------------------------------------------
allANT %>% filter(error == 1)  %>% select(error, rt, correctRT) %>% head(3)

## ----echo=T--------------------------------------------------------------
allANT %>% filter(error == 0)  %>% select(error, rt, correctRT) %>% head(3)

## ----echo=T--------------------------------------------------------------
bysub.rt <- allANT %>% group_by(subnum, group, flank) %>% 
                       summarise(RT = mean(correctRT, na.rm=T), N = n())
bysub.rt

## ----echo=T--------------------------------------------------------------
summary.rt <- bysub.rt %>% group_by(group, flank) %>% 
                           summarise(meanRT = mean(RT), sdRT = sd(RT), 
                                     N=n(), semRT = sdRT / sqrt(N))
summary.rt

## ----echo=T--------------------------------------------------------------
summary.rt <- summary.rt %>% mutate(upperRT = meanRT + semRT,
                                    lowerRT = meanRT - semRT)
summary.rt

## ----echo=T--------------------------------------------------------------
bysub.err <- allANT %>% group_by(subnum, group, flank) %>% 
                        summarise(Error = mean(error, na.rm = T), N = n())
bysub.err

## ----echo=T--------------------------------------------------------------
summary.err <- bysub.err %>% group_by(group, flank) %>% 
                     summarise(meanError = mean(Error), sdError = sd(Error), 
                               N = n(), semError = sdError / sqrt(N))
summary.err

## ----echo=T--------------------------------------------------------------
summary.err <- summary.err %>% mutate(upperError = meanError + semError,
                                      lowerError = meanError - semError)
summary.err

## ----echo=TRUE-----------------------------------------------------------
write.csv(allANT, "output/ANT_merged.csv",   row.names=F)

bysub <- left_join(bysub.rt, bysub.err)
write.csv(bysub,  "output/ANT_bysub.csv",    row.names=F)

summary <- left_join(summary.rt, summary.err)
write.csv(summary, "output/ANT_summary.csv", row.names=F)

