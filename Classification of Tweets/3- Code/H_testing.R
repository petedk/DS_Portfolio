# import file
getwd()
setwd('E:/DataScience/UW_MSDS/!UW-710/Final_Project')
getwd()
file_name <- 'Final_Output/RF_Raw_Combined/Htesting_final.csv'
tweet_summary_df <-  read.csv(file_name, encoding = 'utf-8', skip = 0)



# --------------------------------------------------------

# test if the % change in new users is significant
# % of new users in support of Gun Control:
prop.test(4505,29437, p = .136, alternative = 'greater')
# H_o  % gun control advicates that are new???% advicates for either side that are new

# The evidence supports rejecting Ho at the .01 significance level. There is a greater percentage of new users joining the conversation for Gun Control.


# 1-sample proportions test with continuity correction
#
# data:  4505 out of 29437, null probability 0.136
# X-squared = 72.585, df = 1, p-value < 0.00000000000000022
# alternative hypothesis: true p is greater than 0.136
# 95 percent confidence interval:
#   0.1496022 1.0000000
# sample estimates:
#   p
# 0.1530387

# -------------------------------------------------------

#% of new users in support of Gun Rights:
prop.test(3567,29820, p = .136, alternative = 'greater')
# the evidence does not support rejecting Ho

# 1-sample proportions test with continuity correction
#
# data:  3567 out of 29820, null probability 0.136
# X-squared = 67.97, df = 1, p-value = 1
# alternative hypothesis: true p is greater than 0.136
# 95 percent confidence interval:
#   0.1165445 1.0000000
# sample estimates:
#   p
# 0.1196177

# --------------------------------------------------------

# test if the % of tweets by new users is significant
# % of tweets by new users in support of Gun Control:
prop.test(8711,37635, p = .163, alternative = 'greater')
# H_o  % gun control tweets that are new to the converstation ???% tweets for either side that are new to the conversation
# The evidence supports rejecting Ho at the .01 significance level. There is a greater percentage of tweets in supportive of Gun Control that comes from new users vs percentage of tweets from all new users

# 1-sample proportions test with continuity correction
#
# data:  8711 out of 37635, null probability 0.163
# X-squared = 1292.4, df = 1, p-value < 0.00000000000000022
# alternative hypothesis: true p is greater than 0.163
# 95 percent confidence interval:
#   0.2278902 1.0000000
# sample estimates:
#   p
# 0.2314601

# -------------------------------------------------------

# % of tweets by new users in support of Gun Rights:
prop.test(8181,65682, p = .163, alternative = 'greater')
# the evidence does not support rejecting Ho

# 1-sample proportions test with continuity correction
#
# data:  8181 out of 65682, null probability 0.163
# X-squared = 711.29, df = 1, p-value = 1
# alternative hypothesis: true p is greater than 0.163
# 95 percent confidence interval:
#   0.1224432 1.0000000
# sample estimates:
#   p
# 0.1245547

# --------------------------------------------------------

# test if the % change users is significant
# % of users in support of Gun Control:
prop.test(12865, 29437, p = .442, alternative = 'greater')
# the evidence does not support rejecting Ho

# 1-sample proportions test with continuity correction
#
# data:  12865 out of 29437, null probability 0.442
# X-squared = 2.9221, df = 1, p-value = 0.9563
# alternative hypothesis: true p is greater than 0.442
# 95 percent confidence interval:
#   0.4322687 1.0000000
# sample estimates:
#   p
# 0.437035

# -------------------------------------------------------

#% of users in support of Gun Rights:
prop.test(13357,29820, p = .442, alternative = 'greater')
# H_o  % change week 1 to week 2 of gun rights advicates ???% change week 2 to week 2 of advicates for either side
# The evidence supports rejecting Ho at the .05 significance level. There is a greater percentage of users supporting Gun Rights

# 1-sample proportions test with continuity correction
#
# data:  13357 out of 29820, null probability 0.442
# X-squared = 4.2146, df = 1, p-value = 0.02004
# alternative hypothesis: true p is greater than 0.442
# 95 percent confidence interval:
#   0.4431724 1.0000000
# sample estimates:
#   p
# 0.4479209

# --------------------------------------------------------

# test if the % change of tweets is significant
# % of tweets in support of Gun Control:
prop.test(37635,123909, p = .338, alternative = 'greater')
# the evidence does not support rejecting Ho

# 1-sample proportions test with continuity correction
#
# data:  37635 out of 123909, null probability 0.338
# X-squared = 650.17, df = 1, p-value = 1
# alternative hypothesis: true p is greater than 0.338
# 95 percent confidence interval:
#   0.3015824 1.0000000
# sample estimates:
#   p
# 0.303731

# -------------------------------------------------------

#% of users in support of Gun Rights:
prop.test(65682, 179648, p = .338, alternative = 'greater')
# H_o  % change week 1 to week 2 of gun rights tweets ???% change week 2 to week 2 of tweets for either side
# The evidence supports rejecting Ho at the .01 significance level. There is a greater percentage of original tweets supporting Gun Rights.

# 1-sample proportions test with continuity correction
#
# data:  65682 out of 179648, null probability 0.338
# X-squared = 612.14, df = 1, p-value < 0.00000000000000022
# alternative hypothesis: true p is greater than 0.338
# 95 percent confidence interval:
#   0.3637453 1.0000000
# sample estimates:
#   p
# 0.365615

