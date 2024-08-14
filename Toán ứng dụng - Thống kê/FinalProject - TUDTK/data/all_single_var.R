# ALL CASE

detach(dat)
dat <- read.csv('data_final.csv', header = T)
attach(dat)
dat

result = lm(log(case) ~ log(popdens))
plot(log(popdens), log(case))
abline(result)
summary(result)
cor(log(case), log(popdens))

result = lm(log(case) ~ log(pop))
plot(log(pop), log(case))
abline(result)
summary(result)
cor(log(case), log(pop))

result = lm(log(case) ~ log(pop_city))
plot(log(pop_city), log(case))
abline(result)
summary(result)
cor(log(case), log(pop_city))

#====================================================================
# ALL DEATH

detach(dat)
dat <- read.csv('death.csv', header = T)
attach(dat)
dat

result = lm(log(death) ~ log(case))
summary(result)
cor(log(death), log(case))

result = lm(log(death) ~ log(popdens))
summary(result)
cor(log(death), log(popdens))

result = lm(log(death) ~ log(pop))
summary(result)
cor(log(death), log(pop))

result = lm(log(death) ~ log(pop_city))
summary(result)
cor(log(death), log(pop_city))
-12




