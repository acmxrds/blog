data <- read.csv("repdata-data-StormData.csv.bz2")

#values from EVTYPE have different cases. so cases mut be unified

data$EVTYPE <- toupper(data$EVTYPE)
data$EVTYPE <- as.factor(data$EVTYPE)


#fatalities per type
fatalitiesXType=aggregate(data$FATALITIES, by=list(data$EVTYPE), sum)
colnames(fatalitiesXType)<-c("Type","Sum")
##contains the most harmful fatality
fatalitiesXType[which.max(fatalitiesXType$Sum),]

#get facilities by type ordered
orderFatalitiesindex<-order(fatalitiesXType$Sum, decreasing=TRUE)
orderFatalities<-fatalitiesXType[v,]

#---------------------------------------------------------------
#plot--> fatalities per year

fatalitiesXTypeYear=aggregate(data$FATALITIES, by=list(data$EVTYPE,as.numeric(format(data$BGN_DATE, "%Y"))), sum)
colnames(fatalitiesXTypeYear)<-c("Type","Year","Sum")
topFatalities<-head(fatalitiesXTypeYear,10)
plot(fatalitiesXTypeYear$Year,fatalitiesXTypeYear$Sum,type="l",xlab="Year",ylab="Fatalities",main="Fatalities/Year.",col="red")
for(i in seq(1,10)){
lines(topFatalities[i,"Year"],topFatalities[i,"Sum"],type="l",col="blue",lwd=1.5,lty=1.5,pch=22)
}

legend("topright",lty=c(1,1),col=c("red", "blue"),legend=c("Los Angeles","Baltimore"))



#-----------------------------------------------------------
#convert date.Innecessary
data$BGN_DATE <- as.Date(data$BGN_DATE, "%m/%d/%Y")

#want to get economic data. it is in PROPDMGEXP and PROPDMG
#unified values in PROPDMGEXP
data$PROPDMGEXP<- toupper(data$PROPDMGEXP)
data$PROPDMGEXP <- as.factor(data$PROPDMGEXP)
data$CROPDMGEXP<- toupper(data$CROPDMGEXP)
data$CROPDMGEXP <- as.factor(data$CROPDMGEXP)
#levels(data$PROPDMGEXP)
# ""  "-" "?" "+" "0" "1" "2" "3" "4" "5" "6" "7" "8" "B" "H" "K" "M"
#something must be done with this


#get final eonomical value

data$ECO[data$PROPDMGEXP == "K"] <- data$PROPDMG[data$PROPDMGEXP == "K"] * 1000
data$ECO[data$PROPDMGEXP == "M"] <- data$PROPDMG[data$PROPDMGEXP == "M"] * 1000000
data$ECO[data$PROPDMGEXP == "B"] <- data$PROPDMG[data$PROPDMGEXP == "B"] * 1000000000

data$ECO2[data$CROPDMGEXP == "K" ] <- data$CROPDMG[data$CROPDMGEXP == "K"] * 1000
data$ECO2[data$CROPDMGEXP == "M"] <- data$CROPDMG[data$CROPDMGEXP == "M"] * 1000000
data$ECO2[data$CROPDMGEXP == "B"] <- data$CROPDMG[data$CROPDMGEXP == "B"] * 1000000000

#replace NA with 0

y1 <- which(is.na(data$ECO))         # get index of NA values
y2 <- which(is.na(data$ECO2))         # get index of NA values

data$ECO[y1] <-0
data$ECO2[y2] <-0

data$ECOT<-data$ECO +data$ECO2

#summarize events economical injuries
injuriesEco <- aggregate(data$ECOT,list(event = data$EVTYPE), sum)
colnames(injuriesEco)<-c("Type","Sum")
injuriesEco[which.max(injuriesEco$Sum),]

#get injuries by ECo ordered
orderECOindex<-order(injuriesEco$Sum, decreasing=TRUE)
orderECO<-injuriesEco[orderECO,]