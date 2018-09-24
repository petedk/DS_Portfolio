# install.packages("randomForest")
library(randomForest)
# install.packages('devtools')
library(devtools)
# install_github('MI2DataLab/randomForestExplainer')
library(randomForestExplainer)
# library(tm)
# library(ROCR)

# turn warning messages off globally
options(warn=-1)
# turn warning messages back on globally
# options(warn=0)

# Random Forests in R can only digest factors with up to 32 levels.

# import file
getwd()
setwd('E:/DataScience/UW_MSDS/!UW-710/Final_Project')
getwd()
file_name <- 'Final_Output/RF_Input/Training_Gun_Tweets_v6_ready_for_RF_2.csv'
#file_name <- 'Final_Output/RF_Input/Training_set_for_RF.csv'

tweets <-  read.csv(file_name, encoding = 'utf-8', skip = 0)
# # names(tweets) <- c('hashtags','user_loc','user_time_zone','retweet_count','Category','user_created_at.1gram','created_at.1gram','user_desc.5gram','text.5gram')
#
# # summary(tweets)


# Random Forest manages it's own training and testing
# test_set <- tweets[1:1000]
test_set <- tweets[4:3534]

# Section used to refine model

print('Start')
Sys.time()
set.seed(101)
rfm <- randomForest(test_set$Category~.,data=test_set, importance=TRUE, ntree=500 )
print(rfm)
Sys.time()

# Select mtry value with minimum out of bag(OOB) error.
mtry <- tuneRF(test_set[-1],test_set$Category, ntreeTry=500,
               stepFactor=1.5,improve=0.01, trace=TRUE, plot=TRUE, doBest=TRUE)

best.m <- mtry[mtry[, 2] == min(mtry[, 2]), 1]
print(mtry)
print(best.m)



# -------------------------------------------------------------------------------------------------
Sys.time()
set.seed(101)
rfm <- randomForest(test_set$Category~.,data=test_set,mtry = 27, importance=TRUE, ntree=300 )
print(rfm)

Sys.time()
set.seed(101)
rfm <- randomForest(test_set$Category~.,data=test_set,mtry = 27, importance=TRUE, ntree=400 )
print(rfm)

Sys.time()
set.seed(101)
rfm <- randomForest(test_set$Category~.,data=test_set,mtry = 27, importance=TRUE, ntree=500 )
print(rfm)

Sys.time()
set.seed(101)
rfm <- randomForest(test_set$Category~.,data=test_set, mtry = 27, importance=TRUE, ntree=600 )
print(rfm)

Sys.time()
set.seed(101)
rfm <- randomForest(test_set$Category~.,data=test_set, mtry = 27, importance=TRUE, ntree=800 )
print(rfm)

Sys.time()
set.seed(101)
rfm <- randomForest(test_set$Category~.,data=test_set, mtry = 27, importance=TRUE, ntree=1000 )
print(rfm)



# -------------------------------------------------------------------------------------------------

Sys.time()
set.seed(101)
rfm <- randomForest(test_set$Category~.,data=test_set, mtry = 27, importance=TRUE, ntree=600 )
print(rfm)
Sys.time()

# Save Random Forest Model
save(rfm,file = "Final_Output/RF_Input/RandForestModel.RData")

# Open Random Forest Model
load(file = "Final_Output/RF_Input/RandForestModel.RData")

# Explain Random Forest
explain_forest(rfm, interactions = TRUE, data = test_set)


#Evaluate variable importance
factors_list <- importance(rfm)
print(head(factors_list))
print(head(factors_list[,'MeanDecreaseAccuracy']))
write.csv(factors_list, 'Final_OutPut/RF_Output/Factors_List.csv', row.names = TRUE)
short_list <- factors_list[which(factors_list[,'MeanDecreaseAccuracy']>0),]
print(short_list)
short_list_names <- row.names(short_list)
print(head(short_list_names))
write.csv(short_list_names, 'Final_OutPut/RF_Output/Short_Factor_List.csv', row.names = TRUE)


varImpPlot(rfm)
# Mean Decrease Accuracy - How much the model accuracy decreases if we drop that variable.
# Mean Decrease Gini - Measure of variable importance based on the Gini impurity index used for the calculation of splits in trees.


# Prediction and Calculate Performance Metrics
pred1=predict(rfm, data= test_set, type = "response")
pred2=predict(rfm, data= test_set, type = "prob")
print(head(pred1))
print(head(pred2))


#Save predict to df
tweets['pred1'] <- pred1
tweets['pred2'] <- pred2
print(tweets[,c('Category','pred2','pred1')])
save_file <- tweets[,c('Category','pred2','pred1')]
print(head(save_file))

# Write file to csvs
write.csv(save_file, 'Final_OutPut/RF_Output/RandForestResult_goldenset_short.csv', row.names = FALSE)
write.csv(tweets, 'Final_OutPut/RF_Output/RandForestResult_goldenset.csv', row.names = FALSE)
print('done')
