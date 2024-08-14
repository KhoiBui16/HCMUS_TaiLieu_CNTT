# ALL CASE

detach(dat)
dat <- read.csv('data_final.csv', header = T)
attach(dat)
dat

reg <- lm(log(case) ~ log(popdens) + log(pop) + log(pop_city))
summary(reg)

new.data <- data.frame(log(popdens), log(pop), log(pop_city))
reg <- lm(log(case) ~ ., new.data)
step(reg, direction="both")
pairs(new.data)

cor(log(case), popdens)
cor(log(case), pop)
cor(log(case), pop_city)
cor(log(case), log(popdens))
cor(log(case), log(pop_city))
cor(log(case), log(pop))

result = lm(log(case) ~ log(popdens) + log(pop_city))
summary(result)
cor(log(case), log(popdens))
cor(log(case), log(pop_city))
cor(log(case), log(pop))
#====================================================================
# ALL DEATH

detach(dat)
dat <- read.csv('death.csv', header = T)
attach(dat)
dat

result = lm(log(death) ~ log(popdens) + log(pop) + log(pop_city));
summary(result)

pair.data <- data.frame(log(death), log(popdens), log(pop), log(pop_city))
pairs(pair.data)

new.data <- data.frame(log(popdens), log(pop), log(pop_city))

reg <- lm(log(death) ~ ., new.data)
step(reg, direction="both")

new.data <- data.frame(log(case), log(popdens), log(pop), log(pop_city))
pairs(new.data)
reg <- lm(log(death) ~ ., new.data)
step(reg, direction="both")

result = lm(log(death) ~ log(case))
summary(result)

result = lm(log(death) ~ log(popdens) + log(pop_city) + log(case))
summary(result)

cor(log(death), log(case))
cor(log(death), log(popdens))
cor(log(death), log(pop_city))
cor(log(death), log(pop))





