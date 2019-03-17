#Gets the activity labels
extractActivityLabels <- function(){
    data <- readLines("UCI HAR Dataset/activity_labels.txt")
    data <- splitData(data," ")
    colnames(data) <- c("ClassLabel","ActivityName")
    data
}

#Gets the names of the features
extractFeatures <- function(){
    library(data.table)
    data <- readLines("UCI HAR Dataset/features.txt")
    data <- splitData(data," ")
    datanew <- data[grep("mean()",as.character(data[,2])),]
    datanew <- rbind(datanew,data[grep("std()",as.character(data[,2])),])
    data1 <-strsplit(as.character(datanew[,2]),"-")
    count <- 0
    for(d in data1){
        for(i in 1:(length(d))){
            if(i==1){
                data2 <- unlist(d)[i]
            }
            else{
                data2 <- cbind(data2,unlist(d)[i])
            }
        }
        if(count == 0){
            data3 <- as.data.frame(data2)
            count <- count+1
        }
        else{
            l <- list(data3,as.data.frame(data2))
            data3 <- rbindlist(l, fill = TRUE)
        }
    }
    data3 <- cbind(datanew[,1],data3)
    colnames(data3) <- c("ID","Features","Method","AxialSignal")
    data3 <- subset(data3,data3$Method != "meanFreq()")
    data4 <- paste(data3$Features,data3$Method,data3$AxialSignal,sep="-")
    data4 <- cbind (as.numeric(as.character(data3$ID)),data4)
    colnames(data4) <- c("ID","Features")
    data4 <- data4[order(as.integer(data4[,1])),]
    data4
}

#Merges all the data sets
mergeSets <- function(){
    ClassLabel <- readLines("UCI HAR Dataset/train/y_train.txt")
    set <- read.table("UCI HAR Dataset/train/X_train.txt")
    subject <- readLines("UCI HAR Dataset/train/subject_train.txt")
    data <- cbind(subject, ClassLabel, set)
    ClassLabel <- readLines("UCI HAR Dataset/test/y_test.txt")
    set <- read.table("UCI HAR Dataset/test/X_test.txt")
    subject <- readLines("UCI HAR Dataset/test/subject_test.txt")
    data <- rbind(data, cbind(subject, ClassLabel, set))
    data <- merge(extractActivityLabels(),data,by.x="ClassLabel",by.y="ClassLabel")
    data1 <- data[4:ncol(data)]
    features <- extractFeatures()
    data1 <- data1[,as.numeric(features[,1])]
    colnames(data1) <- features[,2]
    data <- cbind(data[,1:3],data1)
    data
}

#Gets the averages of each column and creates the tidy data set
createDataSet <- function(){
    data <- mergeSets()
    averagesData <- aggregate(data[, 4:ncol(data)], list(data$ClassLabel,data$ActivityName,data$subject), mean)
    colnames(averagesData) <- c("ClassLabl","ActivityName","subject",colnames(averagesData[4:ncol(ad)]))
    write.table(averagesData, "tidy_data.txt", row.name=FALSE)
}

splitData <- function(data,sep){
    data1 <- unlist(strsplit(data,sep))[2*(1:length(data))-1]
    data2 <- unlist(strsplit(data,sep))[2*(1:length(data))]
    data <- data.frame(data1,data2)
}