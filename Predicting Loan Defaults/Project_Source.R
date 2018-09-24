
# load libraries
library(dplyr)


loan_data <- read.csv(file = 'E:/DataScience/UW_MSDS/!UW-705_Stats/Project/loans50k.csv')
# loan_data <- read.csv(file = 'C:/Users/pete.kelley/Documents/DataScience/UW_MSDS/!UW-705_Stats/Project/loans50k.csv')
# Explore the data
# summary(loan_data)

# Add response var
loan_data$response <- NA
loan_data$response[loan_data$status=='Fully Paid']  <-  "Good"
loan_data$response[loan_data$status=='Charged Off']  <-  "Bad"
# make the charactor values of Good and Bad factors
loan_data$response <- as.factor(loan_data$response)
# remove records that are response values of NA (Any status other than Fully Paid or Charged Off)
trimmed_loan_data <- loan_data[!is.na(loan_data$response),]

# Explore the data
# summary(trimmed_loan_data)

# LoanID is a row identifier and isn't representative of the applicant or loan
trimmed_loan_data$loanID <- NULL
# Rate is a result of the credit application process and not available at the time of application.
# trimmed_loan_data$rate <- NULL
# Grade is a result of the credit application process and not available at the time of application.
trimmed_loan_data$grade <- NULL
# Status has been mapped to the response variable.
trimmed_loan_data$status <- NULL
# totalPaid can not be known at the time of application.
# trimmed_loan_data$totalPaid <- NULL
cnames_start <- colnames(trimmed_loan_data)


################################################################
#####################  Clean Data ##############################
################################################################

#  amount
# summary(trimmed_loan_data$amount)
# boxplot(trimmed_loan_data$amount)
# Amount has no outliers and is ready for modeling.

trimmed_loan_data$term <- droplevels(trimmed_loan_data)$term
#  term
# summary(trimmed_loan_data$term)
# plot(trimmed_loan_data$term)
# Term has unused levels of factor that needed to be dropped but is now ready for modeling.


#  payment
# summary(trimmed_loan_data$payment)
# boxplot(trimmed_loan_data$payment)
trimmed_loan_data$logPayment <- log10(trimmed_loan_data$payment)
# summary(trimmed_loan_data$logPayment)
# boxplot(trimmed_loan_data$logPayment)
# qqnorm(trimmed_loan_data$logPayment)
# qqline(trimmed_loan_data$logPayment)
# hist(trimmed_loan_data$logPayment)
trimmed_loan_data$payment <- NULL
# Payment has a strong skew to the right, a log base 10 transformation brought it back to closer to normal. The new column called logPayment.


#  employment
trimmed_loan_data$employment <- NULL

# Employment has 21k factors, way too many to be useful. I am going to delete this column on the bases that job title’s value might be in judging how stable a person's job prospects are and how much money they make, but doesn't do a good job for either.

#  length
# levels(trimmed_loan_data$length)
trimmed_loan_data$years <- NA
trimmed_loan_data$years[trimmed_loan_data$length==''] <- NA
trimmed_loan_data$years[trimmed_loan_data$length=='< 1 year'] <- 0.5
trimmed_loan_data$years[trimmed_loan_data$length=='1 year'] <- 1
trimmed_loan_data$years[trimmed_loan_data$length=='2 years'] <- 2
trimmed_loan_data$years[trimmed_loan_data$length=='3 years'] <- 3
trimmed_loan_data$years[trimmed_loan_data$length=='4 years'] <- 4
trimmed_loan_data$years[trimmed_loan_data$length=='5 years'] <- 5
trimmed_loan_data$years[trimmed_loan_data$length=='6 years'] <- 6
trimmed_loan_data$years[trimmed_loan_data$length=='7 years'] <- 7
trimmed_loan_data$years[trimmed_loan_data$length=='8 years'] <- 8
trimmed_loan_data$years[trimmed_loan_data$length=='9 years'] <- 9
trimmed_loan_data$years[trimmed_loan_data$length=='10+ years'] <- 10


# summary(trimmed_loan_data$years)
# replace NA with mean for all datapoints
trimmed_loan_data$years[which(is.na(trimmed_loan_data$years))] <- mean(trimmed_loan_data$years,na.rm = TRUE)
# summary(trimmed_loan_data$length)
# table(trimmed_loan_data$years)
# We can remove length because it has been mapped to years.
trimmed_loan_data$length <- NULL
# Length of employment as discrete factors loses some of the information content of a continuous variable that order and magnitude have significance, I am turning the factors into dimensions.
# summary(trimmed_loan_data$years)
# plot(trimmed_loan_data$years)
# boxplot(trimmed_loan_data$years)


#  home
trimmed_loan_data$home <- droplevels(trimmed_loan_data$home)
# summary(trimmed_loan_data$home)
# plot(trimmed_loan_data$home)
# boxplot(trimmed_loan_data$home)
# Home had unused factor levels that needed to be dropped before it could be used.


#  income
# summary(trimmed_loan_data$income)
# boxplot(trimmed_loan_data$income)
trimmed_loan_data$logIncome <- log10(trimmed_loan_data$income)
# summary(trimmed_loan_data$logIncome)
# boxplot(trimmed_loan_data$logIncome)
# qqnorm(trimmed_loan_data$logIncome)
# qqline(trimmed_loan_data$logIncome)
# hist(trimmed_loan_data$logIncome)
trimmed_loan_data$income <- NULL
# Income has a strong skew to the right, a log base 10 transformation brought it back to closer to normal. The new column called logIncome.

#  verified
# summary(trimmed_loan_data$verified)
trimmed_loan_data$verified <- droplevels(trimmed_loan_data$verified)
# plot(trimmed_loan_data$verified)
# Verified had unused factor levels that needed to be dropped before it could be used.


# reason
# summary(trimmed_loan_data$reason)
trimmed_loan_data$reason[trimmed_loan_data$reason=='wedding'] <- 'other'
trimmed_loan_data$reason <- as.character(trimmed_loan_data$reason)
trimmed_loan_data$reason[is.na(trimmed_loan_data$reason)] <- 'other'
trimmed_loan_data$reason <- as.factor(trimmed_loan_data$reason)
trimmed_loan_data$reason <- droplevels(trimmed_loan_data$reason)
# summary(trimmed_loan_data$reason)
# Reason had unused levels of factor that needed to be dropped and I  combined wedding level (2 loans) with other, transformed the column to character to combine NAs (2 loans) with other and then transformed it back into a factor column before dropping unused factors.


#   state
# levels(trimmed_loan_data$state)
# temp <- summary(trimmed_loan_data$state)
# sort(temp)
# plot(trimmed_loan_data$state)
trimmed_loan_data$region <- setNames(state.region, state.abb)[trimmed_loan_data$state]
# factor(trimmed_loan_data$region)
# plot(trimmed_loan_data$region)
# State had several levels (states) with very low loan counts, so I have also added a region to the data and we will see if either of them are valuable.
# trimmed_loan_data$state <- NULL

#  debtIncRat
# summary(trimmed_loan_data$debtIncRat)
# boxplot(trimmed_loan_data$debtIncRat)
# qqnorm(trimmed_loan_data$debtIncRat)
# qqline(trimmed_loan_data$debtIncRat)
#  debtIncRat has a few outliers, but the basic transformation made it worse, so I am leaving it the way it is. The spread isn’t large, and the outliers are not a significant portion of the dataset.


#  delinq2yr
# length(trimmed_loan_data$delinq2yr)
# length(trimmed_loan_data$delinq2yr[trimmed_loan_data$delinq2yr > 0])
# plot(trimmed_loan_data$delinq2yr)
# hist(trimmed_loan_data$delinq2yr[trimmed_loan_data$delinq2yr])
# boxplot(trimmed_loan_data$delinq2yr[trimmed_loan_data$delinq2yr])
# delinq2yr needs to be watched, the skew is significant with 80% of the data having a value of 0, and the rest ranging from 1 to 15. Because the spread is so small, a transformation will not do much to change the distribution shape.


#  inq6mth
# summary(trimmed_loan_data$inq6mth)
# plot(trimmed_loan_data$inq6mth)
# boxplot(trimmed_loan_data$inq6mth)
# length(trimmed_loan_data$inq6mth)
# length(trimmed_loan_data$delinq2yr[trimmed_loan_data$inq6mth > 0])
# inq6mth needs to be watched, the skew is significant with 50% of the data having a value of 0, and the rest ranging from 1 to 6. Because the spread is so small, a transformation will not do much to change the distribution shape.


#  openAcc
# summary(trimmed_loan_data$openAcc)
# plot(trimmed_loan_data$openAcc)
# boxplot(trimmed_loan_data$openAcc)
trimmed_loan_data$logOpenAcc <- log10(trimmed_loan_data$openAcc)
# qqnorm(trimmed_loan_data$logOpenAcc)
# qqline(trimmed_loan_data$logOpenAcc)
# summary(trimmed_loan_data$logOpenAcc)
# boxplot(trimmed_loan_data$logOpenAcc)
trimmed_loan_data$OpenAcc <- NULL
# openAcc has a strong skew to the right, a log base 10 transformation brought it back to closer to normal. The new column called logOpenAcc.


#  pubRec
# summary(trimmed_loan_data$pubRec)
# plot(trimmed_loan_data$pubRec)
# length(trimmed_loan_data$pubRec)
# length(trimmed_loan_data$pubRec[trimmed_loan_data$pubRec > 0])
# pubRec needs to be watched, the skew is significant with 80% of the data having a value of 0, and the rest ranging from 1 to 19. Because the spread is so small, a transformation will not do much to change the distribution shape.


#  revolRatio
# summary(trimmed_loan_data$revolRatio)
trimmed_loan_data$revolRatio[which(is.na(trimmed_loan_data$revolRatio))] <- mean(trimmed_loan_data$revolRatio, na.rm=TRUE)
# summary(trimmed_loan_data$revolRatio)
# plot(trimmed_loan_data$revolRatio)
# boxplot(trimmed_loan_data$revolRatio)
# revolRatio had 15 NA's that were replaced with the mean. Doesn’t need a transformation, small spread and only one indication of slight outliers.


#  totalAcc
# summary(trimmed_loan_data$totalAcc)
# plot(trimmed_loan_data$totalAcc)
# boxplot(trimmed_loan_data$totalAcc)
# hist(trimmed_loan_data$totalAcc)
trimmed_loan_data$logTotalAcc <-  log10(trimmed_loan_data$totalAcc)
# boxplot(log10(trimmed_loan_data$logTotalAcc))
trimmed_loan_data$totalAcc <- NULL
# totalAcc has a strong skew to the right, a log base 10 transformation brought it back to closer to normal. The new column called logTotalAcc.


#  totalBal
# summary(trimmed_loan_data$totalBal)
# plot(trimmed_loan_data$totalBal)
# boxplot(trimmed_loan_data$totalBal)
trimmed_loan_data$rootTotalBal <- (trimmed_loan_data$totalBal)^(1/6)
# summary(trimmed_loan_data$rootTotalBal)
# plot(trimmed_loan_data$rootTotalBal)
# boxplot(trimmed_loan_data$rootTotalBal)
trimmed_loan_data$rootTotalBal <- NULL

# totalBal has a strong right skew but we can't use log transformation because of negative infinity result, so used a 6th root because it balanced the upper and lower outliers best. The new column called rootTotalBal.


#  totalRevLim
# summary(trimmed_loan_data$totalRevLim)
# plot(trimmed_loan_data$totalRevLim)
# boxplot(trimmed_loan_data$totalRevLim)
trimmed_loan_data$rootTotalRevBal <- (trimmed_loan_data$totalRevBal)^(1/5)
# summary(trimmed_loan_data$rootTotalRevBal)
# plot(trimmed_loan_data$rootTotalRevBal)
# boxplot(trimmed_loan_data$rootTotalRevBal)

trimmed_loan_data$totalRevBal <-  NULL

# totalRevLim has a strong right skew but we can't use log transformation because of negative infinity result, so used a 5th root because it balanced the upper and lower outliers best. The new column called rootTotalRevLim.


#  accOpen24
# summary(trimmed_loan_data$accOpen24)
# plot(trimmed_loan_data$accOpen24)
# boxplot(trimmed_loan_data$accOpen24)
trimmed_loan_data$rootaccOpen24 <- (trimmed_loan_data$accOpen24)^(1/2)
# summary(trimmed_loan_data$rootaccOpen24)
# plot(trimmed_loan_data$rootaccOpen24)
# boxplot(trimmed_loan_data$rootaccOpen24)
trimmed_loan_data$accOpen24 <-  NULL

# accOpen24 has a strong right skew but we can't use log transformation because of negative infinity result, so used a 2nd root because it balanced the upper and lower outliers best. The new column called root accOpen24.


#  avgBal
# summary(trimmed_loan_data$avgBal)
# plot(trimmed_loan_data$avgBal)
# boxplot(trimmed_loan_data$avgBal)
trimmed_loan_data$rootAvgBal <- (trimmed_loan_data$avgBal)^(1/5)
# summary(trimmed_loan_data$rootAvgBal)
# plot(trimmed_loan_data$rootAvgBal)
# boxplot(trimmed_loan_data$rootAvgBal)
trimmed_loan_data$AvgBal <-  NULL

#  avgBal has a strong right skew but we can't use log transformation because of negative infinity result, so used a 5th root because it balanced the upper and lower outliers best. The new column called rootavgBal.


#  bcOpen
# summary(trimmed_loan_data$bcOpen)
# plot(trimmed_loan_data$bcOpen)
# boxplot(trimmed_loan_data$bcOpen)
trimmed_loan_data$rootbcOpen <- (trimmed_loan_data$bcOpen)^(1/6)
trimmed_loan_data$rootbcOpen[which(is.na(trimmed_loan_data$rootbcOpen))] <- mean(trimmed_loan_data$rootbcOpen, na.rm = TRUE)
# summary(trimmed_loan_data$rootbcOpen)
# plot(trimmed_loan_data$rootbcOpen)
# boxplot(trimmed_loan_data$rootbcOpen)
trimmed_loan_data$bcOpen <-  NULL

#  bcOpen has a strong right skew but we can't use log transformation because of negative infinity result, so used a 6th root because it balanced the upper and lower outliers best. The new column called rootbcOpen. Replaced NA with mean values

#  bcRatio
# summary(trimmed_loan_data$bcRatio)
trimmed_loan_data$bcRatio[which(is.na(trimmed_loan_data$bcRatio))] <- mean(trimmed_loan_data$bcRatio, na.rm=TRUE)
# summary(trimmed_loan_data$bcRatio)
# plot(trimmed_loan_data$bcRatio)
# boxplot(trimmed_loan_data$bcRatio)

# revolRatio had  384 NA that we changed to the mean. Ddoesn’t need a transformation, moderate spread and only one indication of slight outliers.


#  totalLim
# summary(trimmed_loan_data$totalLim)
# plot(trimmed_loan_data$totalLim)
# boxplot(trimmed_loan_data$totalLim)
trimmed_loan_data$roottotalLim <- (trimmed_loan_data$totalLim)^(1/10)
# summary(trimmed_loan_data$roottotalLim)
# plot(trimmed_loan_data$roottotalLim)
# boxplot(trimmed_loan_data$roottotalLim)
trimmed_loan_data$totalLim <-  NULL

#  totalLim has a strong right skew but we can't use log transformation because of negative infinity result, so used a 10th root because it balanced the upper and lower outliers best. The new column called roottotalLim.


#  totalBal
# summary(trimmed_loan_data$totalBal)
# plot(trimmed_loan_data$totalBal)
# boxplot(trimmed_loan_data$totalBal)

trimmed_loan_data$roottotalBal <- (trimmed_loan_data$totalBal)^(1/5)
# summary(trimmed_loan_data$roottotalBal)
# plot(trimmed_loan_data$roottotalBal)
# boxplot(trimmed_loan_data$roottotalBal)
trimmed_loan_data$totalBal <-  NULL

#  totalBal has a strong right skew but we can't use log transformation because of negative infinity result, so used a 5th root because it balanced the upper and lower outliers best. The new column called roottotalBal.

#  totalBcLim
# summary(trimmed_loan_data$totalBcLim)
# plot(trimmed_loan_data$totalBcLim)
# boxplot(trimmed_loan_data$totalBcLim)

trimmed_loan_data$roottotalBcLim <- (trimmed_loan_data$totalBcLim)^(1/5)
# summary(trimmed_loan_data$roottotalBcLim)
# plot(trimmed_loan_data$roottotalBcLim)
# boxplot(trimmed_loan_data$roottotalBcLim)
trimmed_loan_data$totalBcLim <-  NULL

# totalBcLim has a strong right skew but we can't use log transformation because of negative infinity result, so used a 5th root because it balanced the upper and lower outliers best. The new column called roottotalBcLim.


#  totalIlLim
# summary(trimmed_loan_data$totalIlLim)
# plot(trimmed_loan_data$totalIlLim)
# boxplot(trimmed_loan_data$totalIlLim)

trimmed_loan_data$roottotalIlLim <- (trimmed_loan_data$totalIlLim)^(1/5)
# summary(trimmed_loan_data$roottotalIlLim)
# plot(trimmed_loan_data$roottotalIlLim)
# boxplot(trimmed_loan_data$roottotalIlLim)
trimmed_loan_data$totalIlLim <-  NULL

# totalIlLim has a strong right skew but we can't use log transformation because of negative infinity result, so used a 5th root because it balanced the upper and lower outliers best. The new column called roottotalIlLim.

cnames_end <- colnames(trimmed_loan_data)


################################################################
#####################  Get Datesets ############################
################################################################

set.seed(42)
# 80% of the sample size
nPercent <- .8
smp_size <- floor(nPercent * nrow(trimmed_loan_data))

train_ind <- sample(seq_len(nrow(trimmed_loan_data)), size = smp_size)

train <- trimmed_loan_data[train_ind,!names(trimmed_loan_data) %in% c('totalPaid','state') ]
test <- trimmed_loan_data[-train_ind, ]

length(test$response[test$response == 'Good']) / length(test$response)


################################################################
#####################  Store Models ############################
################################################################
# THE BUILD MODELS ARE AT THE BOTTOM OF THE PAGE:
# Ctrl F: 'Code used to Build Models'

# Test the diffrent versions:
d_set <- train # to train the model

fw1_acc <- glm(formula = response ~ rate, family = "binomial", data = d_set)

fw2_aic <- glm(formula = response ~ rate + term + avgBal + debtIncRat +rootaccOpen24 + roottotalLim + logPayment + logTotalAcc + delinq2yr + roottotalBal + home + amount + region + rootbcOpen + openAcc + rootTotalRevBal + reason + revolRatio + bcRatio + inq6mth + verified, family = "binomial", data = d_set)


bw1_acc <- glm(formula = response ~ amount + term + rate + home + verified + reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio + bcRatio + logPayment + logIncome + region + logTotalAcc +  rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim + roottotalBal + roottotalBcLim, family = "binomial", data = d_set)

bw2_aic <- glm(formula = response ~ amount + term + rate + home + verified + reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio + bcRatio + logPayment + region + logTotalAcc + rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim + roottotalBal, family = "binomial", data = d_set)

# dup of bw1_out
# b1_out <- glm(formula = response ~ amount + term + rate + home + verified + reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio + bcRatio + logPayment + logIncome + region + logTotalAcc + rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim + roottotalBal + roottotalBcLim, family = "binomial", data = d_set)
# dup of bw2_out
# b2_out <-  glm(formula = response ~ amount + term + rate + home + verified + reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio + bcRatio + logPayment + region + logTotalAcc + rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim + roottotalBal, family = "binomial", data = d_set)


sec1_acc <- glm(formula = response ~ amount + term + rate + home + verified +  reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio + bcRatio + logPayment + logIncome + region + logTotalAcc + rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim +  roottotalBal + roottotalBcLim + term:roottotalBal + logPayment:roottotalBcLim + term:rate + rate:roottotalBal + verified:openAcc + amount:delinq2yr +  reason:rootbcOpen + delinq2yr:logTotalAcc + region:rootbcOpen + rate:delinq2yr + rate:rootaccOpen24 + rate:revolRatio, family = "binomial", data = d_set)

sec2_aic <- glm(formula = response ~ amount + term + rate + home + verified + reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio +  bcRatio + logPayment + logIncome + region + logTotalAcc + rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim +  roottotalBal + roottotalBcLim + term:roottotalBal + logPayment:roottotalBcLim + term:rate + rate:roottotalBal + verified:openAcc + amount:delinq2yr + reason:rootbcOpen + delinq2yr:logTotalAcc + rate:delinq2yr +  rate:revolRatio + rate:rootTotalRevBal + rootbcOpen:roottotalBcLim +  openAcc:rootbcOpen + rate:openAcc + verified:logPayment + region:roottotalBal + openAcc:region + delinq2yr:region + term:home + logPayment:rootTotalRevBal + rootbcOpen:roottotalLim + term:debtIncRat + bcRatio:roottotalLim + logIncome:rootaccOpen24 + logIncome:logTotalAcc + amount:logIncome + delinq2yr:logIncome + verified:debtIncRat + rootaccOpen24:roottotalLim + debtIncRat:rootaccOpen24 + term:region + verified:rootaccOpen24 + debtIncRat:bcRatio + debtIncRat:rootbcOpen + debtIncRat:roottotalBal + revolRatio:rootaccOpen24 + openAcc:roottotalBal + amount:logTotalAcc + rate:logTotalAcc + region:roottotalLim + logPayment:rootbcOpen + debtIncRat:logIncome +  home:debtIncRat + rate:rootbcOpen + term:rootbcOpen + bcRatio:roottotalBcLim + openAcc:region:roottotalBal, family = "binomial", data = d_set)

################################################################
#####################  Test Models ############################
################################################################

# install.packages('broom')
require('broom')
g_fw1 <- glance(fw1_acc)
g_fw2 <- glance(fw2_aic)
g_bw1 <- glance(bw1_acc)
g_bw2 <- glance(bw2_aic)
g_sec1 <- glance(sec1_acc)
g_sec2 <- glance(sec2_aic)

# Find "Best" Model
d_set <- test # to test the model
bad <- list()
good <- list()
percentBadRej <- list()
percentGoodRej <- list()
profit_threshold <- list()
profit_table <- matrix(, nrow = 0, ncol = 100)
profit_max <- list()
accuracy_threshold <- list()
accuracy_table <- matrix(, nrow = 0, ncol = 100)
accuracy_max <- list()
percentBadRej <- matrix(, nrow = 0, ncol = 100)
percentGoodRej <- matrix(, nrow = 0, ncol = 100)

mods_list <- c(fw1_acc$formula,fw2_aic$formula, bw1_acc$formula,bw2_aic$formula,sec1_acc$formula,sec2_aic$formula)


for (j in seq(1:length(mods_list))){

  temp <- glm(mods_list[j][[1]], family = "binomial", data = d_set)
  predprob  <- predict(temp, d_set, type="response")

  profit_table_temp <- NULL
  accuracy_table_temp <- NULL
  percentBadRej_temp <- NULL
  percentGoodRej_temp <- NULL
  for(i in seq(1,100)){

    threshhold <- i/100  # Set Y=1 when predicted probability exceeds this
    predLoan <- cut(predprob, breaks=c(-Inf, threshhold, Inf),labels=c("Bad", "Good"))  # Y=1 is "Bad"
    predict <- predLoan

    # Accuracy
    cTab <- table(d_set$response, predLoan)
    # addmargins(cTab)

    p <- sum(diag(cTab)) / sum(cTab)  # compute the proportion of correct classifications
    # print(paste('Proportion correctly predicted = ', p))
    accuracy_table_temp[i] <- p
    bad[i] <- length(predLoan[predLoan == 'Bad'])
    good[i] <- length(predLoan[predLoan == 'Good'])

    percentBadRej_temp[i] <- length(d_set$response[predict == 'Bad' & d_set$response == 'Bad'])/
      length( d_set$response[d_set$response == 'Bad'])

    percentGoodRej_temp[i] <- length(d_set$response[predict == 'Bad' & d_set$response == 'Good'])/
      length( d_set$response[d_set$response == 'Good'])


    # Profit
    d_set$profit <- 0

    # Paid - $1000 to put into default and try to collect - 1.1amount
    d_set$profit[predict == 'Good' & d_set$response == 'Bad'] <- d_set$totalPaid[predict == 'Good' &  d_set$response == 'Bad'] - 500 - d_set$amount[predict == 'Good' & d_set$response == 'Bad']

    # # Made profitable loan
    d_set$profit[predict == 'Good' & d_set$response == 'Good'] <- d_set$totalPaid[predict == 'Good' & d_set$response == 'Good'] - d_set$amount[predict == 'Good' & d_set$response == 'Good']


    p <- sum(d_set$profit)# compute the pro vs lose
    # print(paste0('i:',i,', p: ',p))
    profit_table_temp[i] <- p

  }
  #   print('----------------------')
  percentBadRej <- rbind(percentBadRej, percentBadRej_temp)
  percentGoodRej <- rbind(percentGoodRej, percentGoodRej_temp)
  accuracy_table <- rbind(accuracy_table, accuracy_table_temp)
  profit_table <- rbind(profit_table, profit_table_temp)
  #   print(j)
  profit_threshold[j] <- which.max(profit_table[j,])
  #   print(profit_threshold[j])
  profit_max[j] <- profit_table[j,profit_threshold[j][[1]]]
  #   print(profit_max[j])
  accuracy_threshold[j] <- which.max(accuracy_table[j,])
  #   print(accuracy_threshold[j])
  accuracy_max[j] <- accuracy_table[j,accuracy_threshold[j][[1]]]
  #   print(accuracy_max[j])
}



################################################################
################  Matrix of Test Results  ######################
################################################################


d_set <- test # to test the model

act_profit <- (sum(d_set$totalPaid) - sum(d_set$amount) - 500 * length(d_set$amount[d_set$response=='Bad']))
perfect_profit <- (sum(d_set$totalPaid[d_set$response=='Good']) - sum(d_set$amount[d_set$response=='Good']))

r <- c('fw1_acc: ', 'fw2_aic: ', 'bw1_acc: ', 'bw2_aic: ', 'sec1_acc: ', 'sec2_aic: ')
# c <- c( ' AIC   ',	' BIC    ',	'Max Acc ',	'Acc Cutoff ',	'Max Profit ',	'Profit Cut  ','% Improved  ', '% Perfect')
c <- c( 'AIC',	'BIC',	'Max Acc',	'Acc Cutoff',	'Max Profit',	'Profit Cut','% Improved', '% Perfect')
glance_matrix <- matrix(c(
  round(g_fw1[4],0),	 	round(g_fw1[5],0),	round(accuracy_max[[1]],3),	accuracy_threshold[1],	round(profit_max[[1]],0),	profit_threshold[1], round(profit_max[[1]]/act_profit,3)*100, round(profit_max[[1]]/perfect_profit,3)*100,
  round(g_fw2[4],0),	 	round(g_fw2[5],0), 	round(accuracy_max[[2]],3),	accuracy_threshold[2],	round(profit_max[[2]],0),	profit_threshold[2], round(profit_max[[2]]/act_profit,3)*100, round(profit_max[[2]]/perfect_profit,3)*100,
  round(g_bw1[4],0),	 	round(g_bw1[5],0),	round(accuracy_max[[3]],3),	accuracy_threshold[3],	round(profit_max[[3]],0),	profit_threshold[3], round(profit_max[[3]]/act_profit,3)*100, round(profit_max[[3]]/perfect_profit,3)*100,
  round(g_bw2[4],0), 	round(g_bw2[5],0),	round(accuracy_max[[4]],3),	accuracy_threshold[4],	round(profit_max[[4]],0),	profit_threshold[4], round(profit_max[[4]]/act_profit,3)*100, round(profit_max[[4]]/perfect_profit,3)*100,
  round(g_sec1[4],0),	round(g_sec1[5],0),	round(accuracy_max[[5]],3),	accuracy_threshold[5],	round(profit_max[[5]],0),	profit_threshold[5], round(profit_max[[5]]/act_profit,3)*100, round(profit_max[[5]]/perfect_profit,3)*100,
  round(g_sec2[4],0),	round(g_sec2[5],0),	round(accuracy_max[[6]],3),	accuracy_threshold[6],	round(profit_max[[6]],0),	profit_threshold[6], round(profit_max[[6]]/act_profit,3)*100, round(profit_max[[6]]/perfect_profit,3)*100)
  , nrow = 6, byrow = TRUE,dimnames = list(r,c) )

bad_loan_mean_threshold <- mean(predprob[which(d_set$response == 'Bad')])
good_loan_mean_threshold <- mean(predprob[which(d_set$response == 'Good')])































################################################################
################ Code used to Build Models #####################
################################################################

# Forward

# d_set <- train # to train the model
# full_fit <- glm(response ~ . , data = d_set, family="binomial")
# null_fit <- glm(response~1,data=d_set, family = 'binomial')
# old_AIC <-  0;
# old_accuracy <- 0;
# last_AIC <-  0;
# last_accuracy <- 0;
# max_accuracy <-  0;
# max_accuracy_i <-  0;
# max_accuracy_AIC <- 0;
# max_formula <-  '';
# i <- 0
# n <- 500
# print('forward')
# repeat {
#   d_set <- train # to train the model
#   forward_out <- step(null_fit,scope=list(lower=null_fit,upper=full_fit),direction="forward",steps = 1, trace = 0)
#   null_fit <- glm(forward_out$formula,data=d_set, family = 'binomial')
#   # print(c('AIC: ',round(extractAIC(forward_out)[2],0)))
#   d_set <- test # to test the model
#   d_set$fw.prob <- predict(forward_out, d_set, type="response")
#   accuracy_forward <- (length(d_set$fw.prob[c(d_set$fw.prob >=.5 & d_set$response == 'Good')]) +            length(d_set$fw.prob[c(d_set$pfw.redict <.5 & d_set$response == 'Bad')])) / length(d_set$fw.prob)
#   # print(c('Accuracy Rate:',round(accuracy_forward,3)))
#
#   if(accuracy_forward > max_accuracy){
#     max_accuracy <- accuracy_forward
#     max_formula <- forward_out$call
#     max_accuracy_AIC <- extractAIC(forward_out)
#     max_accuracy_i <- i
#   }
#
#   old_AIC <-  extractAIC(forward_out)[2];
#   old_accuracy <-  accuracy_forward;
#   old_call <- forward_out$call
#
#   if(last_AIC == extractAIC(forward_out)[2] & last_accuracy == accuracy_forward & i%%10 == 0){
#     break;
#     }
#   if(i%%10 == 0){
#
#     last_AIC <-  extractAIC(forward_out)[2];
#     last_accuracy <-  accuracy_forward;
#
#     print('------------------------------------------')
#     print(Sys.time());
#     print(c('i:',i));
#     print(c('Final Accuracy Rate:',round(accuracy_forward,3)))
#     print(c('Final AIC: ',round(extractAIC(forward_out)[2],0)))
#     print(c('Final Formula',forward_out$call))
#   }
#
#   i <- i + 1
# }
#
# paste('max accuracy i:',max_accuracy_i)
# paste('max accuracy:',round(max_accuracy,3))
# paste('max accuracy AIC:',round(max_accuracy_AIC[2],0))
# print(c('max formula:',max_formula))
# print('vs')
# paste('Max i:',i)
# print(c('Final Accuracy Rate:',round(accuracy_forward,3)))
# print(c('Final AIC: ',round(extractAIC(forward_out)[2],0)))
# print(c('Final Formula',forward_out$call))


# Forward
# High accuracy:
# "max accuracy i: 0"
# "max accuracy: 0.767"
# "max accuracy AIC: 27114"
# glm(formula = response ~ rate, family = "binomial", data = d_set)

# Low AIC:
# "Final Accuracy Rate:" "0.759"
# "Final AIC: " "26211"
# glm(formula = response ~ rate + term + avgBal + debtIncRat +
#     rootaccOpen24 + roottotalLim + logPayment + logTotalAcc +
#     delinq2yr + roottotalBal + home + amount + region + rootbcOpen +
#     openAcc + rootTotalRevBal + reason + revolRatio + bcRatio +
#     inq6mth + verified, family = "binomial", data = d_set)


# Backward

# d_set <- train # to train the model
# full_fit <- glm(response ~ . , data = d_set, family="binomial")
# null_fit <- glm(response~1,data=d_set, family = 'binomial')
# old_AIC <-  0;
# old_accuracy <- 0;
# last_AIC <-  0;
# last_accuracy <- 0;
# max_accuracy <-  0;
# max_accuracy_i <-  0;
# max_accuracy_AIC <- 0;
# max_formula <-  '';
# i <- 0
# n <- 500
# print('backward')
# repeat {
#   d_set <- train # to train the model
#   backward_out <- step(full_fit,direction="backward",steps = 1, trace = 0)
#   # print(c('AIC: ',round(extractAIC(backward_out)[2],0)))
#   full_fit <- glm(backward_out$formula,data=d_set, family = 'binomial')
#   # print(backward_out$formula)
#   d_set <- test # to test the model
#   d_set$bw.prob <- predict(backward_out, d_set, type="response")
#   accuracy_backward <- (length(d_set$bw.prob[c(d_set$bw.prob >=.5 & d_set$response == 'Good')]) +            length(d_set$bw.prob[c(d_set$bw.prob <.5 & d_set$response == 'Bad')])) / length(d_set$bw.prob)
#   # print(c('Accuracy Rate:',round(accuracy_backward,3)))
#
#   if(accuracy_backward > max_accuracy){
#     max_accuracy <- accuracy_backward
#     max_formula <- backward_out$call
#     max_accuracy_AIC <- extractAIC(backward_out)
#     max_accuracy_i <- i
#   }
#
#     if(i == n){
#       break;
#     }
#
#
#   if(last_AIC == extractAIC(backward_out)[2] & last_accuracy == accuracy_backward & i%%10 == 0){
#       break;
#     }
#
#   if(i%%10 == 0){
#
#     last_AIC <-  extractAIC(backward_out)[2];
#     last_accuracy <-  accuracy_backward;
#
#     print('------------------------------------------')
#     print(Sys.time());
#     print(c('i:',i));
#     print(c('Final Accuracy Rate:',round(accuracy_backward,3)))
#     print(c('Final AIC: ',round(extractAIC(backward_out)[2],0)))
#     print(c('Final Formula',backward_out$call))
#   }
#
#   old_AIC <-  extractAIC(backward_out)[2];
#   old_accuracy <-  accuracy_backward;
#   old_call <- backward_out$call
#
#
#
#   i <- i + 1
#
# }
#
# print('#########################################')
#
# paste('max accuracy i:',max_accuracy_i)
# paste('max accuracy:',round(max_accuracy,3))
# paste('max accuracy AIC:',round(max_accuracy_AIC[2],0))
# print(c('max formula:',max_formula))
# print('vs')
# paste('Max i:',i)
# print(c('Final Accuracy Rate:',round(accuracy_backward,3)))
# print(c('Final AIC: ',round(extractAIC(backward_out)[2],0)))
# print(c('Final Formula',backward_out$call))


# Backward
# High accuracy:
# "max accuracy i: 6"
# "max accuracy: 0.789"
# "max accuracy AIC: 26210"
# glm(formula = response ~ amount + term + rate + home + verified +
#     reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio +
#     bcRatio + logPayment + logIncome + region + logTotalAcc +
#     rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim +
#     roottotalBal + roottotalBcLim, family = "binomial", data = d_set)

# Low AIC:
# "Final Accuracy Rate:" "0.788"
# "Final AIC: " "26209"
# glm(formula = response ~ amount + term + rate + home + verified +
#     reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio +
#     bcRatio + logPayment + region + logTotalAcc + rootTotalRevBal +
#     rootaccOpen24 + rootbcOpen + roottotalLim + roottotalBal,
#     family = "binomial", data = d_set)


# Both

# d_set <- train # to train the model
# full_fit <- glm(response ~ . , data = d_set, family="binomial")
# null_fit <- glm(response~1,data=d_set, family = 'binomial')
# old_AIC <-  0;
# old_accuracy <- 0;
# last_AIC <-  0;
# last_accuracy <- 0;
# max_accuracy <-  0;
# max_accuracy_i <-  0;
# max_accuracy_AIC <- 0;
# max_formula <-  '';
# i <- 0
# n <- 500
# print('both')
# repeat {
#   d_set <- train # to train the model
#   both_out <- step(full_fit,direction="both",steps = 1, trace = 0)
#   # print(c('AIC: ',round(extractAIC(both_out)[2],0)))
#   full_fit <- glm(both_out$formula,data=d_set, family = 'binomial')
#   # print(both_out$formula)
#   d_set <- test # to test the model
#   d_set$b.prob <- predict(both_out, d_set, type="response")
#   accuracy_b <- (length(d_set$b.prob[c(d_set$b.prob >=.5 & d_set$response == 'Good')]) +            length(d_set$b.prob[c(d_set$b.prob <.5 & d_set$response == 'Bad')])) / length(d_set$b.prob)
#   # print(c('Accuracy Rate:',round(accuracy_b,3)))
#
#   if(accuracy_b > max_accuracy){
#     max_accuracy <- accuracy_b
#     max_formula <- both_out$call
#     max_accuracy_AIC <- extractAIC(both_out)
#     max_accuracy_i <- i
#   }
#
#   if(i == n){
#     break;
#   }
#
#   old_AIC <-  extractAIC(both_out)[2];
#   old_accuracy <-  accuracy_b;
#   old_call <- both_out$call
#
#   if(last_AIC == extractAIC(both_out)[2] & last_accuracy == accuracy_b & i%%10 == 0){
#       break;
#     }
#
#   if(i%%10 == 0){
#
#     last_AIC <-  extractAIC(both_out)[2];
#     last_accuracy <-  accuracy_b;
#
#     print('------------------------------------------')
#     print(Sys.time());
#     print(c('i:',i));
#     print(c('Final Accuracy Rate:',round(accuracy_b,3)));
#     print(c('Final AIC: ',round(extractAIC(both_out)[2],0)));
#     print(c('Final Formula',both_out$call));
#   }
#
#   i <- i + 1
# }
#
# print('#########################################')
#
# paste('max accuracy i:',max_accuracy_i)
# paste('max accuracy:',round(max_accuracy,3))
# paste('max accuracy AIC:',round(max_accuracy_AIC[2],0))
# print(c('max formula:',max_formula))
# print('vs')
# paste('Max i:',i)
# print(c('Final Accuracy Rate:',round(accuracy_b,3)))
# print(c('Final AIC: ',round(extractAIC(both_out)[2],0)))
# print(c('Final Formula',both_out$call))


# Both
# High accuracy:
# "max accuracy i: 6"
# "max accuracy: 0.789"
# "max accuracy AIC: 26210"
# glm(formula = response ~ amount + term + rate + home + verified +
#     reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio +
#     bcRatio + logPayment + logIncome + region + logTotalAcc +
#     rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim +
#     roottotalBal + roottotalBcLim, family = "binomial", data = d_set)

# Low AIC:
# "Final Accuracy Rate:" "0.788"
# "Final AIC: " "26209"
# "Final Formula"
# glm(formula = response ~ amount + term + rate + home + verified +
#     reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio +
#     bcRatio + logPayment + region + logTotalAcc + rootTotalRevBal +
#     rootaccOpen24 + rootbcOpen + roottotalLim + roottotalBal,
#     family = "binomial", data = d_set)

# second Order

# d_set <- train # to train the model
# full_fit <- glm(formula = response ~ amount + term + rate + home + verified +
#     reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio +
#     bcRatio + logPayment + logIncome + region + logTotalAcc +
#     rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim +
#     roottotalBal + roottotalBcLim, family = "binomial", data = d_set)
# null_fit <- glm(response~1,data=d_set, family = 'binomial')
# old_AIC <-  0;
# old_accuracy <- 0;
# last_AIC <-  0;
# last_accuracy <- 0;
# max_accuracy <-  0;
# max_accuracy_i <-  0;
# max_accuracy_AIC <- 0;
# max_formula <-  '';
# i <- 0
# n <- 500
# print('second order')
# repeat {
#   d_set <- train # to train the model
#   second_Order_out <- step(full_fit,scope = . ~ . ^2 ,direction="both",steps = 1, trace = 0)
#   full_fit <- glm(second_Order_out$formula,data=d_set, family = 'binomial')
#   # print(c('AIC: ',round(extractAIC(second_Order_out)[2],0)))
#   # print(second_Order_out$formula)
#   d_set <- test # to test the model
#   d_set$sec.prob <- predict(second_Order_out, d_set, type="response")
#   accuracy_sec <- (length(d_set$sec.prob[c(d_set$sec.prob >=.5 & d_set$response == 'Good')]) +            length(d_set$sec.prob[c(d_set$sec.prob <.5 & d_set$response == 'Bad')])) / length(d_set$sec.prob)
#   # print(c('Accuracy Rate:',round(accuracy_sec,3)))
#
#   if(accuracy_sec > max_accuracy){
#     max_accuracy <- accuracy_sec
#     max_formula <- second_Order_out$call
#     max_accuracy_AIC <- extractAIC(second_Order_out)
#     max_accuracy_i <- i
#   }
#
#   if(i == n){
#     break;
#   }
#
#   old_AIC <-  extractAIC(second_Order_out)[2];
#   old_accuracy <-  accuracy_sec;
#   old_call <- second_Order_out$call
#
#   if(last_AIC == extractAIC(second_Order_out)[2] & last_accuracy == accuracy_sec & i%%10 == 0 ){
#       break;
#     }
#
#   if(i%%10 == 0){
#
#     last_AIC <-  extractAIC(second_Order_out)[2];
#     last_accuracy <-  accuracy_sec;
#
#     print('------------------------------------------')
#     print(Sys.time());
#     print(c('i:',i));
#     print(c('Final Accuracy Rate:',round(accuracy_sec,3)));
#     print(c('Final AIC: ',round(extractAIC(second_Order_out)[2],0)));
#     print(c('Final Formula',second_Order_out$call));
#   }
#
#   i <- i + 1
# }
#
# print('#########################################')
#
# paste('max accuracy i:',max_accuracy_i)
# paste('max accuracy:',round(max_accuracy,3))
# paste('max accuracy AIC:',round(max_accuracy_AIC[2],0))
# print(c('max formula:',max_formula))
# print('vs')
# paste( 'i:',i)
# print(c('Final Accuracy Rate:',round(accuracy_sec,3)))
# print(c('Final AIC: ',round(extractAIC(second_Order_out)[2],0)))
# print(c('Final Formula',second_Order_out$call))



# Second Order
# High accuracy:
# "max accuracy i: 11"
# "max accuracy: 0.79"
# "max accuracy AIC: 26084"
# "max formula:"
# glm(formula = response ~ amount + term + rate + home + verified +
#     reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio +
#     bcRatio + logPayment + logIncome + region + logTotalAcc +
#     rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim +
#     roottotalBal + roottotalBcLim + term:roottotalBal + logPayment:roottotalBcLim +
#     term:rate + rate:roottotalBal + verified:openAcc + amount:delinq2yr +
#     reason:rootbcOpen + delinq2yr:logTotalAcc + region:rootbcOpen +
#     rate:delinq2yr + rate:rootaccOpen24 + rate:revolRatio, family = "binomial",
#     data = d_set)

# Low AIC:
# "i: 70"
# "Final Accuracy Rate:" "0.789"
# "Final AIC: " "25999"
# "Final Formula"
# glm(formula = response ~ amount + term + rate + home + verified +
#     reason + debtIncRat + delinq2yr + inq6mth + openAcc + revolRatio +
#     bcRatio + logPayment + logIncome + region + logTotalAcc +
#     rootTotalRevBal + rootaccOpen24 + rootbcOpen + roottotalLim +
#     roottotalBal + roottotalBcLim + term:roottotalBal + logPayment:roottotalBcLim +
#     term:rate + rate:roottotalBal + verified:openAcc + amount:delinq2yr +
#     reason:rootbcOpen + delinq2yr:logTotalAcc + rate:delinq2yr +
#     rate:revolRatio + rate:rootTotalRevBal + rootbcOpen:roottotalBcLim +
#     openAcc:rootbcOpen + rate:openAcc + verified:logPayment +
#     region:roottotalBal + openAcc:region + delinq2yr:region +
#     term:home + logPayment:rootTotalRevBal + rootbcOpen:roottotalLim +
#     term:debtIncRat + bcRatio:roottotalLim + logIncome:rootaccOpen24 +
#     logIncome:logTotalAcc + amount:logIncome + delinq2yr:logIncome +
#     verified:debtIncRat + rootaccOpen24:roottotalLim + debtIncRat:rootaccOpen24 +
#     term:region + verified:rootaccOpen24 + debtIncRat:bcRatio +
#     debtIncRat:rootbcOpen + debtIncRat:roottotalBal + revolRatio:rootaccOpen24 +
#     openAcc:roottotalBal + amount:logTotalAcc + rate:logTotalAcc +
#     region:roottotalLim + logPayment:rootbcOpen + debtIncRat:logIncome +
#     home:debtIncRat + rate:rootbcOpen + term:rootbcOpen + bcRatio:roottotalBcLim +
#     openAcc:region:roottotalBal, family = "binomial", data = d_set)









