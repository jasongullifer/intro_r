knitr::opts_chunk$set(echo = FALSE)
knitr::include_graphics("images/rstudio.png")
## install.packages(c("dplyr", "tidyr", "ggplot2")) #install packages
library(dplyr)   # package providing grammar of data manipulation
library(tidyr)   # package for reorganizing data
library(ggplot2) # package for plotting data
rm(list=ls()) #clear workspace
ANT <- read.csv("data/ANT_young.csv", stringsAsFactors = FALSE) # read data from file
head(ANT, 6) # view the first 6 rows of ANT (young adults)
ANTOLD <- read.csv("data/ANT_old.csv", stringsAsFactors = FALSE) # read data from file
head(ANTOLD,6) # first 6 rows of ANT (old adults)
ANT_runsheet <- read.csv("data/ANT_runsheet.csv", stringsAsFactors = FALSE) # read data from file
head(ANT_runsheet, 20) # first 20 rows of the runsheet
str(ANT)          #structure of young sheet
str(ANTOLD)       #structure of old sheet
str(ANT_runsheet) #structure of runsheet
# Make sure dplyr is loaded above
allANT <- bind_rows(ANT, ANTOLD) # combine rows together... 
                                 # this function will match based on column names
head(allANT,3) # view first 3 rows of the combined data.frame
tail(allANT,3) # view last 3 rows of the combined data.frame
head(ANT_runsheet)
allANT <- left_join(allANT, ANT_runsheet, by="subnum") # join the two datasets by subnum column
head(allANT,3)
tail(allANT,3)
allANT %>% select(flank)      # select and view the flank column
allANT %>% select(flank, cue) # select and view the flank and cue columns
allANT %>% group_by(flank) %>% summarise(N=n()) # Number of rows by flank
allANT %>% group_by(subnum,flank) %>% summarise(N=n()) # num rows by flank and subject
allANT %>% group_by(subnum) %>% summarise(age=first(age)) #first occur. of age by subject
allANT %>% group_by(group) %>% summarise(meanAge=mean(age)) # mean age by group
allANT %>% group_by(group) %>% summarise(n_distinct(subnum))
allANT <- allANT %>% mutate(correctRT = ifelse(error == 0, rt, NA))
allANT %>% filter(error == 1)  %>% select(error, rt, correctRT) %>% head(3)
allANT %>% filter(error == 0)  %>% select(error, rt, correctRT) %>% head(3)
bysub.rt <- allANT %>% group_by(subnum, group, flank) %>% 
                       summarise(RT = mean(correctRT, na.rm=T), N = n())
bysub.rt
summary.rt <- bysub.rt %>% group_by(group, flank) %>% 
                           summarise(meanRT = mean(RT), sdRT = sd(RT), 
                                     N=n(), semRT = sdRT / sqrt(N))
summary.rt
summary.rt <- summary.rt %>% mutate(upperRT = meanRT + semRT,
                                    lowerRT = meanRT - semRT)
summary.rt
bysub.err <- allANT %>% group_by(subnum, group, flank) %>% 
                        summarise(Error = mean(error, na.rm = T), N = n())
bysub.err
summary.err <- bysub.err %>% group_by(group, flank) %>% 
                     summarise(meanError = mean(Error), sdError = sd(Error), 
                               N = n(), semError = sdError / sqrt(N))
summary.err
summary.err <- summary.err %>% mutate(upperError = meanError + semError,
                                      lowerError = meanError - semError)
summary.err
write.csv(allANT, "data/allANT.csv",   row.names=F)

bysub <- left_join(bysub.rt, bysub.err)
write.csv(bysub,  "data/ANT_bysub.csv",    row.names=F)

summary <- left_join(summary.rt, summary.err)
write.csv(summary, "data/ANT_summary.csv", row.names=F)
