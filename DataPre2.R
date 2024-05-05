setwd("/Users/cuiying/Desktop/R studio")

usage <- read.csv("P3-Machine-Utilization.csv")
str(usage)
usage$Timestamp <- factor(usage$Timestamp)
usage$Machine <- factor(usage$Machine)
str(usage)
summary(usage)
head(usage,12)

usage$Utilization <- 1-usage$Percent.Idle
usage$PosixTime <- as.POSIXct(usage$Timestamp,format="%d/%m/%Y %H:%M")

usage$Timestamp <- NULL
usage <- usage[,c(4,1,2,3)]
head(usage)

#list
summary(usage)
RL1 <- usage[usage$Machine=="RL1",]
summary(RL1)
RL1$Machine <- factor(RL1$Machine)

usage_stat_rl1 <- c(min(RL1$Utilization, na.rm=T),
                    mean(RL1$Utilization, na.rm=T),
                    max(RL1$Utilization, na.rm=T))
usage_stat_rl1
RL1[which(RL1$Utilization < 0.90),]
length(which(RL1$Utilization < 0.90))
length(which(RL1$Utilization < 0.90)) > 0

util_under_90_flag <- length(which(RL1$Utilization < 0.90)) > 0
util_under_90_flag

list_rl1 <- list("RL1",usage_stat_rl1,util_under_90_flag)
list_rl1

#naming components of a list
list_rl1
names(list_rl1) <- c("Machine","Stats","LowThreshold")

rm(list_rl1)

#or
list_rl1 <- list(Machine="RL1",Stats=usage_stat_rl1,LowThreshold=util_under_90_flag)

list_rl1
list_rl1[1]
list_rl1[[1]]
list_rl1$Machine

list_rl1[2]
list_rl1[[2]]
list_rl1$Stats
typeof(list_rl1[2])
typeof(list_rl1[[2]])
typeof(list_rl1$Stats)

list_rl1[[2]][3]
list_rl1$Stats[3]
typeof(list_rl1$Stats[3])

#add or delete components
list_rl1[4] <- "New information"
list_rl1

RL1[is.na(RL1$Utilization),"PosixTime"]
list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization),"PosixTime"]
list_rl1

list_rl1[4] <- NULL
list_rl1

list_rl1[4]
list_rl1$Data <- RL1
summary(list_rl1)
str(list_rl1)

#subset a list
list_rl1[1:3]
list_rl1[c(1,4)]
sublist_rl1 <- list_rl1[c("Machine","Stats")]
sublist_rl1

#visualisation
library(ggplot2)
p <- ggplot(data=usage)
p + geom_line(aes(x=PosixTime,y=Utilization,
                  colour=Machine),size=0.2) +
  facet_grid(Machine~.) +
  geom_hline(yintercept=0.9,colour="grey",size=0.5,linetype=2)

myplot <- p + geom_line(aes(x=PosixTime,y=Utilization,
                            colour=Machine),size=0.2) +
  facet_grid(Machine~.) +
  geom_hline(yintercept=0.9,colour="grey",size=0.5,linetype=2)
