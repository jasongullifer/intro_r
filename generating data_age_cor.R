library(ez)
library(dplyr)

set.seed(42)

data(ANT)


ANT$group <- factor(ANT$group, labels=c("Old","Young"))

runsheet <- ANT %>% group_by(subnum) %>% summarise(group=first(group))


subsum <- ANT %>% group_by(subnum, group) %>% summarise(meanRT = mean(rt)) %>% arrange(desc(group),meanRT)

subsum$age <- c(round(seq(from=18, to=30, length.out=10)),round(seq(from=78, to=90, length.out=10))) 

subsum <- subsum %>% arrange(subnum)



ANT <- ANT %>% select(-group)

runsheet$age <- subsum$age

young <- ANT[ANT$subnum %in% 1:10,]
old   <- ANT[ANT$subnum %in% 11:20,]

old <- old %>% select(sample(1:9,9))

write.csv(young, "ANT_young.csv",row.names=F )
write.csv(old,   "ANT_old.csv",row.names=F )
write.csv(runsheet, "ANT_runsheet.csv",row.names=F )
