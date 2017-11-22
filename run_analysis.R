library(tidyr)

testx <- read.table("UCI HAR Dataset/test/X_test.txt")
testy <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsub <- read.table("UCI HAR Dataset/test/subject_test.txt")

trainx <- read.table("UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsub <- read.table("UCI HAR Dataset/train/subject_train.txt")

features <- read.table("UCI HAR Dataset/features.txt")

x <- rbind(testx, trainx)
y <- rbind(testy, trainy)
sub <- rbind(testsub, trainsub)

colnames(x) <- features[,2]
xmeans <- x[, grepl('mean', names(x))]
xstd <- x[, grepl('std', names(x))]
all <- cbind(sub, y, xmeans, xstd)
tidy <- gather(all, 'measurement', 'value', 3:ncol(all))
colnames(tidy)[1:2] <- c("subject", "activity")

actlab <- read.table("UCI HAR Dataset/activity_labels.txt", sep=" ", header=F)
tidy$activity <- actlab[match(tidy$activity, actlab[, 1]), 2]
tidysum <- tidy %>% group_by(subject, activity, measurement) %>% summarize(mean(value))
write.table(tidysum, "UCIHAR_tidy.txt", sep="\t", quote = F, row.names = F)
