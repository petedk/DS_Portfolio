library(randomForest)

# turn warning messages off globally
options(warn=-1)
# turn warning messages back on globally
# options(warn=0)


# import file
getwd()
setwd('E:/DataScience/UW_MSDS/!UW-710/Final_Project')
getwd()

# prevent Scientific notation, allow is: scipen = 0
options(scipen = 999)

file_name <- 'Final_Output/RF_Input/Training_Gun_Tweets_v6_ready_for_RF_2.csv'
golden_set <-  read.csv(file_name, encoding = 'utf-8', skip = 0)

# Open Random Forest Model
load(file = "Final_Output/RF_Input/RandForestModel.RData")

# get list of files to for RF predition
list_of_Files <- list.files('Final_Output/RF_Input', pattern = '_step_', all.files = TRUE)
print(list_of_Files)


for (each in list_of_Files){
  # open file
  print(Sys.time())
  open_file_name <- paste0('Final_Output/RF_Input/',each)
  # for testing to pick 1 file
  # open_file_name <- paste0('Final_Output/RF_Input/',list_of_Files[1])
  # print(c('Open file:',open_file_name))
  tweet <-  read.csv( open_file_name, encoding = 'utf-8', skip = 0)
  # # tweet_df <- golden_set[,2:3564]
  tweet_df <- tweet[,12:dim(tweet)[2]]
  last_row <- dim(tweet[1])
  # # hack to get test DS to have the same factors as the golden set.
  tweet_df <- rbind(tweet_df, golden_set[,5:3534])
  # # get predictions
  pred1 <- predict(rfm, newdata = tweet_df[1:last_row[1],], type = "response")
  # print('Pred1')
  pred2 <- predict(rfm, newdata = tweet_df[1:last_row[1],], type = "prob")
  # print('Pred2')
  # drop RF Column Headers
  tweet <- tweet[1:11]
  # Add prediction
  # print('Add pred1 & pred2')
  tweet['pred1'] <- pred1
  tweet['pred2'] <- pred2
  # save results
  save_file_name <- paste0('Final_Output/RF_Output/Sm_File_Output/', substring(each,1,nchar(each)-18), 'RF_Output.csv')
  print(c('Save file:',save_file_name))
  write.csv(tweet, save_file_name, row.names = FALSE)
  print('Next file: --------------------------------------------------------------------------')
}
print(Sys.time())



days <- c('2018-02-24','2018-02-25','2018-03-03','2018-03-04')
# days <- c('2018-03-04')

# combine files by Day
print(c('Start',print(Sys.time())))
for (day in days){
  new = TRUE
  print(c('day:',day))
  list_RF_Files <- list.files('Final_Output/RF_Output/Sm_File_Output', pattern = day, all.files = TRUE)
  print(list_RF_Files)
  print(c('file count:',length(list_RF_Files)))
  i = 1
  for (each in list_RF_Files){
    print(Sys.time())
    rf_file_name <- paste0('Final_Output/RF_Output/Sm_File_Output/', each)
    print(c('i',i,'file',rf_file_name))
    temp_df <- read.csv( rf_file_name, encoding = 'utf-8', skip = 0)
    if(new){
      day_df <- temp_df
      new = FALSE
    }
    else{
      day_df <- rbind.data.frame(day_df,temp_df)
    }
    i = i + 1
  print(dim(day_df))
  save_file_name <- paste0('Final_Output/RF_Raw_Combined/', day, '_RF_n_Content_Combined.csv')
  print(save_file_name)
  write.csv(day_df,save_file_name, col.names = TRUE, row.names = TRUE)
  print('Next file: --------------------------------------------------------------------------')

  }
}
print(Sys.time())


# testing to ensure golden set has all the factors
list_1_dim <- c()
# for(each in golden_set)
for(i in seq(2, length(colnames(golden_set)))){
  g_set <- (summary(golden_set[i]))
  if(dim(g_set)[1] ==  1){
    list_1_dim <- c(list_1_dim, i)
    print(c('i',i))
  }
}
list_1_dim