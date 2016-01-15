library(mefa)
setwd("~/Dropbox/sar/data")
MET <- read.csv("SAR_metadata.csv")
PAP <- read.csv("SAR_paper.csv")
STU <- read.csv("SAR_study.csv")
STU$X <- NULL
ISL <- read.csv("SAR_island.csv", na.strings = c("","NA"))
ISL$PAPER <- as.factor(fill.na(ISL$PAPER))
ISL$STUDYREP <- as.factor(fill.na(ISL$STUDYREP))

setdiff(ISL$PAPER, PAP$PAPER)
setdiff(PAP$PAPER, ISL$PAPER)

setdiff(STU$PAPER, PAP$PAPER)
setdiff(PAP$PAPER, STU$PAPER)

setdiff(STU$PAPER, ISL$PAPER)
setdiff(ISL$PAPER, STU$PAPER)

setdiff(STU$STUDYREP, ISL$STUDYREP)
setdiff(ISL$STUDYREP, STU$STUDYREP)

d <- abs(STU$Latitude_nearPole - STU$Latitude_nearEqator)

x <- data.frame(ISL, STU[match(ISL$STUDYREP, STU$STUDYREP),])
x <- x[!is.na(x$Dmainlkm),]
x$lat <- (x$Latitude_nearPole + x$Latitude_nearEqator)/2
x$latdiff <- abs(x$Latitude_nearPole - x$Latitude_nearEqator)
x$clat <- cut(x$lat, breaks=seq(-90,90,10))
x$clatdiff <- cut(x$latdiff, breaks=c(0,5,10,100))
with(x, table(clat,clatdiff))
with(x[!duplicated(x$STUDYREP),], table(clat,clatdiff))

x$Lat <- 5 * floor(x$Latitude_nearPole / 5)
x$logS <- log(x$S+0.5)
x$logA <- log(x$Akm2)
x$logD <- log(x$Dmainlkm)
x$D <- x$Dmainlkm
x$D2 <- x$Dmainlkm^2
plot(x[,c("logS","logA","logD","Lat")])

#m0 <- lm(logS ~ logA, x[x$Island_type=="oceanic",])
m1 <- lm(logS ~ (logA + D + Lat)^3, x)
m2 <- lm(logS ~ (logA + D2 + Lat)^3, x)

library(sharx)
x <- data.frame(ISL, STU[match(ISL$STUDYREP, STU$STUDYREP),])
x <- x[x$Region != "" & x$Repeat == 1,]
x$Region <- droplevels(x$Region)
x$lat <- (x$Latitude_nearPole + x$Latitude_nearEqator)/2
x$abslat <- abs(x$lat)
x$logA <- log(x$Akm2)
x$latdiff <- abs(x$Latitude_nearPole - x$Latitude_nearEqator)

m <- hsarx(log(S+0.5) ~ log(Akm2) | Taxon + Island_type + abslat | STUDY, x, 
    n.clones=5, n.adapt=2000, n.update=3000, n.iter=2000)

xx=x[x$STUDYREP=="reed1981",c(3:8)]
