# install.packages("Amelia")
# update.packages()
# library(Amelia)
# AmeliaView()
require(Amelia)
library(forecast)

getwd()
setwd('E:/DataScience/UW_MSDS/!UW-700/Assigments/FinalProject')
getwd()
# Load data
exams <- read.csv('Exams_missing_data.csv', header = TRUE, fileEncoding = "UTF-8-BOM")
print(head(exams))
# summary of data
summary(exams)

# map missing values
missmap(exams)

# viewAmelia opens up a gui
# AmeliaView()

# Amelia
# exams_out1 <- amelia(exams, m = 5, ts = "MonthEnd", p2s=2, cs = "Examinations")
exams_out1 <- amelia(exams, m = 5, ts = 'Month', p2s = 2, polytime = 2)
exams_out1
exams_out1[1]

# write amelia files to csv
write.amelia(obj = exams_out1, file.stem = 'E:/DataScience/UW_MSDS/!UW-700/Assigments/FinalProject/outdata/outdata')

summary(exams_out1)
# plot results
dev.off()
plot(exams_out1, which.vars = 1:2)
compare.density(exams_out1, var = 'Examinations')
overimpute(exams_out1, var = 'Examinations')
disperse(exams_out1, dims = 1, m = 5)


# Model the data that has had missing values imputed:
# read in the final imputed file:
# Load data
exams_imputed <- read.csv('exams_imputed.csv', fileEncoding = "UTF-8-BOM")
print(head(exams_imputed ))
# summary of data
summary(exams_imputed )

# plot time series
plot.ts(exams_imputed)
# forecast using Holt-Winters Exponential Smoothing
# Let R calculate best values for alpha and beta
exams_imputed.mean <- HoltWinters(exams_imputed, gamma=FALSE)
# check on alpha
exams_imputed.mean
exams_imputed.predict <- predict(exams_imputed.mean, n.ahead = 12, prediction.interval = TRUE)
exams_imputed.predict
# look at the fitted values
exams_imputed.mean$fitted
# Plot data
plot.ts(exams_imputed, xlim=c(0, 108), ylim=c(0,8000) )
lines(exams_imputed.mean$fitted[,1], col="green")
lines(exams_imputed.predict[,1], col="blue")
lines(exams_imputed.predict[,2], col="red")
lines(exams_imputed.predict[,3], col="red")

# Error measures
accuracy(test,exams_imputed[,1][3:96])
# accuracy(test,exams_imputed[,1][3:96])
#               ME     RMSE     MAE       MPE     MAPE
# Test set 17.70739 326.1431 249.068 -9.263005 21.83722

# save fitted output to csv
write.csv(exams_imputed.mean$fitted[,1], 'ts.fitted_data.csv')
# save predictions
write.csv(exams_imputed.predict, 'ts.predict.csv')


# try ARIMA forcast

# build a time series from data
exams_imputed_TS  <- ts(exams_imputed)
# review the time series
exams_imputed_TS
# plot the time series to find any trends, seasonality, etc.
plot(exams_imputed_TS, ylab = "Number of Exams Requested", xlab = "Months")
# Assess the time series using (autocorrelation function)ACF and PACF (partial autocorrelation function)
acf(exams_imputed_TS)
pacf(exams_imputed_TS)
# both graphs have large spikes to the left that die out. This indicates there are both autoregressive and moving averages in the data.
# Therefor we will use the ARIMA model (Combo of Autoregresion and moving averages)

# use diffing for data transformation. R can find optimal diffing number
ndiffs(x = exams_imputed_TS)
# plot to see the effect of diffing
plot(diff(exams_imputed_TS, 1))
# fit the ARIMA model, let R determine the best P,D,Q. P is the order (number of time lags),
# d is the degree of differencing (the number of times the data have had past values subtracted), q is the order of the moving-average model.
myBestForecast  <- auto.arima(x = exams_imputed_TS)
# review the ARIMA model
myBestForecast
# Minimize the AIC (Akaike's Information Criterion) value
# Minimize Bayesian information criterion
# Coefficients:
#         ar1      ma1    drift
#       -0.3394  -0.4799  53.9414
# s.e.   0.1348   0.1212  13.0275
# AIC=1375.96   AICc=1376.41   BIC=1386.18

# check the ACF and PACF of the ARIMA model residuals
acf(myBestForecast$residuals)
pacf(myBestForecast$residuals)
# Both test are good and all values in the center of the graph are within the bounds
# the acf had the first value the was 1 and outside of the bounds
# check the coefficients
coef(myBestForecast)
# predict next 12 months using the ARIMA model
NextForecasts  <- forecast(myBestForecast, h=12)
# review the predictions
NextForecasts
# plot the predictions
# plot.forecast(NextForecasts)
plot(NextForecasts)

#Error measures
summary(NextForecasts)
# Error measures:
#                   ME     RMSE      MAE       MPE     MAPE      MASE         ACF1
# Training set 1.07797 321.1866 232.1428 -11.63198 21.22446 0.7659349 -0.002879773
# this is the better one

print(NextForecasts$fitted)
# save fitted output to csv
write.csv(NextForecasts$fitted, 'ARIMA.fitted.csv')
# save predictions
write.csv(NextForecasts, 'ARIMA.predict.csv')




