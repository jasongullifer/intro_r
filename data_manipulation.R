#' ---
#' title: "Introduction to R Workshop"
#' subtitle:  "Working with data"
#' author: "Jason W. Gullifer"
#' date: '2018-03-16'
#' output: 
#'   ioslides_presentation:
#'     widescreen: true
#'     smaller: true
#'     css: styles/style.css
#' ---

#' ## Clearing the workspace before running
#' - I like to start with a clean workspace 
#' 
#' - Reproducible, generate everything with a script
#' 
#' - You can run the command
#' 
## ----echo=TRUE, eval=TRUE------------------------------------------------
rm(list=ls()) #clear workspace

#' 
#' - Or click the sweeping icon in R studio above the workspace
#' 
#' 
#' 
#' ## Data import: ANT_young.csv
#' - read.csv(...) reads the text data and interprets it as a delimited format
#' - The "<-" arrow, stores the dataset to a variable called ANT (case-sensitive)
#' - Each observation from a participant occupies a single row (5760 observations total)
#' 
## ----echo=TRUE-----------------------------------------------------------
ANT <- read.csv("data/ANT_young.csv", stringsAsFactors = FALSE) # read data from file
head(ANT, 6) # view the first 6 rows of ANT (young adults)

#' 
#' ## Data import: ANT_old.csv
#' - read.csv(...) reads the text data and interprets it as a delimited format
#' - The "<-" arrow, stores the dataset to a variable called ANT_old (case-sensitive)
#' - Each observation from a participant occupies a single row (5760 observations total)
#' - Note: Our colleague simulated ANT data for older adults, but their data is in a different order
## ----echo=TRUE-----------------------------------------------------------
ANTOLD <- read.csv("data/ANT_old.csv", stringsAsFactors = FALSE) # read data from file
head(ANTOLD,6) # first 6 rows of ANT (old adults)

#' 
#' ## Data import: ANT_runsheet.csv {.smaller}
#' - read.csv(...) reads the text data and interprets it as a delimited format
#' - The "<-" arrow, stores the dataset to a variable called ANT_runsheet (case-sensitive)
#' - Now, each participant occupies a single row (20 rows total)
## ----echo=TRUE-----------------------------------------------------------
ANT_runsheet <- read.csv("data/ANT_runsheet.csv", stringsAsFactors = FALSE) # read data from file
head(ANT_runsheet, 20) # first 20 rows of the runsheet

#' 
#' ## Viewing data structure: ANT (ANT_young.csv)
#' - Once data is imported, it's a good idea to view the structure
#' - Check your data types
## ----echo=TRUE-----------------------------------------------------------
str(ANT)          #structure of young sheet

#' 
#' ## Viewing data structure: ANTOLD (ANT_old.csv)
#' - Once data is imported, it's a good idea to view the structure
#' - Check your data types
## ----echo=TRUE-----------------------------------------------------------
str(ANTOLD)       #structure of old sheet

#' 
#' ## Viewing data structure: ANT_runsheet (ANT_runsheet.csv)
#' - Once data is imported, it's a good idea to view the structure
#' - Check your data types
## ----echo=TRUE-----------------------------------------------------------
str(ANT_runsheet) #structure of runsheet

#' 
#' ## Combining our 2 task data frames together (row-wise)
#' - Want to directly compare young and old adults together
#' - Helpful to have them in the same data.frame
#' - Stack the sheets on top of one another
#' - We can use functions from the "dplyr" package 
#'     - Will intelligently deal with column mismatches
## ----echo=TRUE, warning = FALSE,message=FALSE----------------------------
# Make sure dplyr is loaded above
allANT <- bind_rows(ANT, ANTOLD) # combine rows together... 
                                 # this function will match based on column names

#' 
#' ## Combining our 2 task data frames together (row-wise)
#' - View the result
## ----echo=TRUE-----------------------------------------------------------
head(allANT,3) # view first 3 rows of the combined data.frame
tail(allANT,3) # view last 3 rows of the combined data.frame

#' 
#' 
#' 
#' ## Joining trial-level data with subject-level data
#' - Runsheet data is in completely different format, only 20 rows
## ----echo=TRUE-----------------------------------------------------------
head(ANT_runsheet)

#' 
#' - We want to keep the data in the format of allANT, but code group and age by participant
#' - Place the sheets side-by-side, but repeat values from the ANT_runsheet
#' - This requires a "join" operation, from the "dplyr" package
## ----echo=TRUE-----------------------------------------------------------
allANT <- left_join(allANT, ANT_runsheet, by="subnum") # join the two datasets by subnum column

#' 
#' ## Joining datasets
## ----echo=TRUE-----------------------------------------------------------
head(allANT,3)
tail(allANT,3)

#' 
#' ## Some dplyr basics: selecting columns
#' - One way to reference a column, select (from dplyr)
#' - Note: %>% is a pipe. It sends data to a function
## ----echo=TRUE-----------------------------------------------------------
allANT %>% select(flank)      # select and view the flank column
allANT %>% select(flank, cue) # select and view the flank and cue columns

#' 
#' ## With many rows, it's better to summarize the data in some way
#' - Group by flank, and get number of rows
#' - Using n() within summarise()
## ----echo=TRUE-----------------------------------------------------------
allANT %>% group_by(flank) %>% summarise(N=n()) # Number of rows by flank

#' 
#' ## With many rows, it's better to summarize the data in some way
#' - Group by subject and flank, and get number of rows
#' - Using n() within summarise()
## ----echo=TRUE-----------------------------------------------------------
allANT %>% group_by(subnum,flank) %>% summarise(N=n()) # num rows by flank and subject

#' 
#' ## With many rows, it's better to summarize the data in some way
#' - Group by subject and get first occurrence of age
#' - Using first() within summarise(); see also last(), nth()
## ----echo=TRUE-----------------------------------------------------------
allANT %>% group_by(subnum) %>% summarise(age=first(age)) #first occur. of age by subject

#' 
#' ## With many rows, it's better to summarize the data in some way
#' - Group by group and get mean Age
#' - mean() within summarise(); see also sd(), median()
## ----echo=TRUE-----------------------------------------------------------
allANT %>% group_by(group) %>% summarise(meanAge=mean(age)) # mean age by group

#' 
#' ## Number of subjects in each group
#' - n_distinct returns the number of distinct observations
## ---- echo=TRUE----------------------------------------------------------
allANT %>% group_by(group) %>% summarise(n_distinct(subnum))

#' 
#' ## Processing ANT data
#' - Typical goal is to compute effects with dependent measures
#'     - Reaction time considering correct trials
#'     - Accuracy/error rate 
#' 
#' - Compute mean for each group / condition / effect
#' 
#' ## Processing ANT data {.smaller}
#' - Three effects of interest in the ANT task, we focus on one here
#' 
#' - Alerting Effect: Effect of achieving and maintaining alertness
#'     - cue: None - Double
#' 
#' - Orienting Effect: Effect of orienting attention towards a specific location of information 
#'     - cue: Center - Spatial
#'     
#' - **Conflict Effect**: Effect of resolving conflict between several possible responses
#'     - flank: Incongruent - Congruent
#'   
#' # Processing reaction time
#'   
#' ## Step 0: Compute correct RT {.smaller}
#' - Logic: 
#'     - If a trial was correct/not an error, then use the RT
#'     - If a trial was incorrect/an error, blank out the RT
#'   
#' - dplyr mutate: add a new column onto your data frame (e.g., SPSS compute)
#' 
## ----echo=T--------------------------------------------------------------
allANT <- allANT %>% mutate(correctRT = ifelse(error == 0, rt, NA))

#' 
#' - View some RTs for trials with errors
## ----echo=T--------------------------------------------------------------
allANT %>% filter(error == 1)  %>% select(error, rt, correctRT) %>% head(3)

#' 
#' - View some RTs for trials without errors
## ----echo=T--------------------------------------------------------------
allANT %>% filter(error == 0)  %>% select(error, rt, correctRT) %>% head(3)

#' 
#' ## Step 1: Compute means for conflict effect  {.smaller}
#' - Go from raw, trial-level data to by-subject mean data
#' - Always a good idea to compute number of rows that went into the computation
#' - Q: what is the N here?
## ----echo=T--------------------------------------------------------------
bysub.rt <- allANT %>% group_by(subnum, group, flank) %>% 
                       summarise(RT = mean(correctRT, na.rm=T), N = n())
bysub.rt

#' 
#' ## Step 2: Compute means for conflict effect  {.smaller}
#' - From by-subject data, compute overall means per condition / group
#' - Also can compute by-subject SD, N, and SEM
#' - Q: what is the N here?
## ----echo=T--------------------------------------------------------------
summary.rt <- bysub.rt %>% group_by(group, flank) %>% 
                           summarise(meanRT = mean(RT), sdRT = sd(RT), 
                                     N=n(), semRT = sdRT / sqrt(N))
summary.rt

#' 
#' ## Use mutate to compute upper and lower bounds based on SEM {.smaller}
## ----echo=T--------------------------------------------------------------
summary.rt <- summary.rt %>% mutate(upperRT = meanRT + semRT,
                                    lowerRT = meanRT - semRT)
summary.rt

#' 
#' 
#' # Error rates / accuracy
#' 
#' ## Step 1: Compute means for conflict effect  {.smaller}
#' - Go from raw, trial-level data to by-subject mean data
#' - Always a good idea to compute number of rows that went into the computation
#' - Q: what is the N here?
## ----echo=T--------------------------------------------------------------
bysub.err <- allANT %>% group_by(subnum, group, flank) %>% 
                        summarise(Error = mean(error, na.rm = T), N = n())
bysub.err

#' 
#' ## Step 2: Compute means for conflict effect  {.smaller}
#' - From by-subject data, compute overall means per condition / group
#' - Also can compute by-subject SD, N, and SEM
#' - Q: what is the N here?
## ----echo=T--------------------------------------------------------------
summary.err <- bysub.err %>% group_by(group, flank) %>% 
                     summarise(meanError = mean(Error), sdError = sd(Error), 
                               N = n(), semError = sdError / sqrt(N))
summary.err

#' 
#' ## Use mutate to compute upper and lower bounds based on SEM {.smaller}
## ----echo=T--------------------------------------------------------------
summary.err <- summary.err %>% mutate(upperError = meanError + semError,
                                      lowerError = meanError - semError)
summary.err

#' 
#' ## File output
#' - To output data to a file, we can use "write.csv"
#' - We can also use left_join to combine similar data frames together
#'     - Two subject-level data frames, and two grand mean data frames
#' 
## ----echo=TRUE-----------------------------------------------------------
write.csv(allANT, "data/allANT.csv",   row.names=F)

bysub <- left_join(bysub.rt, bysub.err)
write.csv(bysub,  "data/ANT_bysub.csv",    row.names=F)

summary <- left_join(summary.rt, summary.err)
write.csv(summary, "data/ANT_summary.csv", row.names=F)

