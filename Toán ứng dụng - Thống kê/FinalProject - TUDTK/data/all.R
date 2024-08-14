# ALL

detach(dat)
dat <- read.csv('data.csv', header = T)
attach(dat)
dat

result = lm(log(case) ~ log(popdens))
summary(result)
plot(log(popdens), log(case), bty = "n")
text(log(popdens), log(case), id, pos=1)
abline(result)
cor(log(case), log(popdens))
#==================================================
detach(dat)
dat <- read.csv('death.csv', header = T)
attach(dat)
dat

plot(log(case), log(death), bty = "n")
text(log(case), log(death), id, pos=1)
result = lm(log(death) ~ log(case))
summary(result)
abline(result)
cor(log(death), log(case))

#==================================================
detach(dat)
dat <- read.csv('death.csv', header = T)
attach(dat)
dat
CFR = death/case
plot(log(popdens),CFR)
result = lm(CFR ~ log(popdens))
plot(result)
summary(result)
cor(CFR, log(popdens))
#==================================================
detach(dat)
dat <- read.csv('death.csv', header = T)
attach(dat)
dat

plot(log(popdens), log(death))
result = lm(log(death) ~ log(popdens))
abline(result)
summary(result)
cor(log(death), log(popdens))
#===================================================

detach(dat)
dat <- read.csv('provinces0808_FILL.csv', header = T)
attach(dat)
dat

lm(rate ~ ., select = -1)