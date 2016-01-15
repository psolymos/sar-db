setwd("c:/projects/sarmix/database")
x<-read.csv("lomolino1982.csv")

m0 <- lm(log(S+0.5) ~ log(A), x)
m1 <- lm(residuals(m0) ~ D, x)
plot(x$D, exp(residuals(m0)))
DD <- seq(0,1.2, len=100)
lines(DD, exp(coef(m1)[1]+DD*coef(m1)[2]))

m <- lm(log(S+0.5) ~ log(A) * D, x)
plot(x$S, exp(fitted(m))-0.5)
abline(0,1)
