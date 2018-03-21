library(ez)
library(dplyr)

set.seed(42)

data(ANT)


ANT$group <- factor(ANT$group, labels=c("Old","Young"))

runsheet <- ANT %>% group_by(subnum) %>% summarise(group=first(group))

ANT <- ANT %>% select(-group)





runsheet$age <- c(sample(18:35, 10), sample(70:95, 10))

young <- ANT[ANT$subnum %in% 1:10,]
old   <- ANT[ANT$subnum %in% 11:20,]

write.csv(young, "ANT_young.csv",row.names=F )
write.csv(old,   "ANT_old.csv",row.names=F )
write.csv(runsheet, "ANT_runsheet.csv",row.names=F )

