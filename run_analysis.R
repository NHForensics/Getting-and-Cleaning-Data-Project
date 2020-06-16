features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("subject_test.txt", col.names = "subject")
x_test <- read.table("X_test.txt", col.names = features$functions)
y_test <- read.table("y_test.txt", col.names = "code")
subject_train <- read.table("subject_train.txt", col.names = "subject")
x_train <- read.table("X_train.txt", col.names = features$functions)
y_train <- read.table("y_train.txt", col.names = "code")

library(dplyr)

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged_table <- cbind(subject, Y, X)

clean_data <- select(merged_table, subject, code, contains("mean"), contains("std"))

clean_data$code <- activities[clean_data$code, 2]

names(clean_data)[2] = "activity"
names(clean_data) <- gsub("Acc", "Accelerometer", names(clean_data))
names(clean_data) <- gsub("Gyro", "Gyroscope", names(clean_data))
names(clean_data) <- gsub("BodyBody", "Body", names(clean_data))
names(clean_data) <- gsub("Mag", "Magnitude", names(clean_data))
names(clean_data) <- gsub("^t", "Time", names(clean_data))
names(clean_data) <- gsub("^f", "Frequency", names(clean_data))
names(clean_data) <- gsub("tBody", "TimeBody", names(clean_data))
names(clean_data) <- gsub("-mean()", "Mean", names(clean_data))
names(clean_data) <- gsub("-std()", "STD", names(clean_data))
names(clean_data) <- gsub("-freq()", "Frequency", names(clean_data))
names(clean_data) <- gsub("angle", "Angle", names(clean_data))
names(clean_data) <- gsub("gravity", "Gravity", names(clean_data))

clean_data2 <- clean_data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(clean_data2, "clean_data2.txt", row.name=FALSE)