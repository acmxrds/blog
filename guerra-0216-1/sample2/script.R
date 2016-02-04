library(ggplot2)
library(gridExtra) 
##Loading and preprocessing the data
data<-read.csv("activity.csv",header = TRUE, sep = ",")


##What is mean total number of steps taken per day?
#1.1 Make a histogram of the total number of steps taken each day
##group per day
data2<-data[complete.cases(data),]
sums<-aggregate(data2$steps, by=list(data2$date), FUN=sum,na.rm = FALSE)

#change the 
colnames(sums)<-c("date","sum")

ggplot(sums,aes(x=date,y=sum)) + geom_bar(stat="identity") +xlab("Date") + ylab("Num Steps")+ggtitle("Histogram  total number of steps taken each day")

#1.2 Calculate and report the mean and median total number of steps taken per day
smean<-aggregate(data2$steps, by=list(data2$date), FUN=mean)
colnames(smean)<-c("date","mean")
smedian<-aggregate(data2$steps, by=list(data2$date), FUN=median)
colnames(smedian)<-c("date","median")




##What is the average daily activity pattern?
#2.1 Make a time series plot (i.e. type = "l") of the 5-minute interval 
#(x-axis) and the average number of steps taken, averaged across all days (y-axis)
smean2<-aggregate(data2$steps, by=list(data2$interval), FUN=mean)
colnames(smean2)<-c("interval","mean")
plot(smean2$interval,smean2$mean,main="Avg steps ~ interval",xlab="interval",ylab="Avg steps",col="black",type="l")
#2.2 Which 5-minute interval, on average across all the days in the dataset, 
#contains the maximum number of steps?
smean2[which.max(smean2$mean),]





## Imputing missing values
#3.1 Calculate and report the total number of missing values in the 
#dataset (i.e. the total number of rows with NAs)

dataNA <- subset(data, is.na(data$steps))
emptyRows<-nrow(dataNA)

#3.2 Devise a strategy for filling in all of the missing values 
#in the dataset. The strategy does not need to be sophisticated. 
#For example, you could use the mean/median for that day, or the mean 
#for that 5-minute interval, etc.
#time interval avg
data3<-data
y <- which(is.na(data3$steps))         # get index of NA values 
data3$steps[y] <-smean2[ smean2$interval %in%  data3$interval[y],]$mean # replace all na values 

#3.3 Create a new dataset that is equal to the original dataset but with the missing data filled in.



#3.4 Make a histogram of the total number of steps taken each day and Calculate and 
#report the mean and median total number of steps taken per day. Do these values
#differ from the estimates from the first part of the assignment? What is the impact 
#of imputing missing data on the estimates of the total daily number of steps?

sumsData3<-aggregate(data3$steps, by=list(data3$date), FUN=sum,na.rm = FALSE)

#change the 
colnames(sumsData3)<-c("date","sum")

ggplot(sumsData3,aes(x=date,y=sum)) + geom_bar(stat="identity")+xlab("Date") + ylab("Num Steps") +ggtitle("Data 3 - change NA's x mean")


smeanData3<-aggregate(data3$steps, by=list(data3$date), FUN=mean)
colnames(smeanData3)<-c("date","mean")
smedianData3<-aggregate(data3$steps, by=list(data3$date), FUN=median)
colnames(smedianData3)<-c("date","median")





##Are there differences in activity patterns between weekdays and weekends?

#4.1 Create a new factor variable in the dataset with two levels - "weekday" 
#and "weekend" indicating whether a given date is a weekday or weekend day.

Sys.setlocale("LC_TIME", "English")
weekdays(as.Date(data$date))
#create a new field on data with the weekday
data1<-cbind(data,ifelse(weekdays(as.Date(data$date)) %in% c("Sunday","Saturday"), "weekend","weekday"))
colnames(data1)<-c("steps","date","interval","weekend")

data33<-cbind(data3,ifelse(weekdays(as.Date(data3$date)) %in% c("Sunday","Saturday"), "weekend","weekday"))
colnames(data33)<-c("steps","date","interval","weekend")


#4.2 Make a panel plot containing a time series plot (i.e. type = "l") 
#of the 5-minute interval (x-axis) and the average number of steps taken, 
#averaged across all weekday days or weekend days (y-axis). The plot should 
#look something like the following, which was creating using simulated data:
weekDay<-data33[data33$weekend == "weekday",]
weekEnd<-data33[data33$weekend == "weekend",]
#intervals aggregates must be calculatesd
weekDayMean<-aggregate(weekDay$steps, by=list(weekDay$interval), FUN=mean)
weekEndMean<-aggregate(weekEnd$steps, by=list(weekEnd$interval), FUN=mean)
colnames(weekDayMean)<-c("interval","mean")
colnames(weekEndMean)<-c("interval","mean")


#plot1<-plot(weekDayMean$interval,weekDayMean$mean,main="WeekDay",xlab="interval",ylab="Avg steps",col="black",type="l")
#plot2<-plot(weekEndMean$interval,weekEndMean$mean,main="Weekend",xlab="interval",ylab="Avg steps",col="black",type="l")
plot1<-qplot(weekDayMean$interval,weekDayMean$mean,xlab="interval",ylab="Avg steps",geom="line",main="WeekDay")
plot2<-qplot(weekEndMean$interval,weekEndMean$mean,xlab="interval",ylab="Avg steps",geom="line",main="WeekEnd")

grid.arrange(plot1, plot2,ncol=1)
