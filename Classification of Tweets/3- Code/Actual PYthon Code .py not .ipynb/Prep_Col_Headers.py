import pandas as pd
import datetime as dt
import math
from Final_Methods_V3 import final_methods as fm

# path = 'C:/Users/pete.kelley/Documents/DataScience/UW_MSDS/!UW-710/Final_Project/Reviewed/'
path = 'E:/DataScience/UW_MSDS/!UW-710/Final_Project/Reviewed/'
path_2 = 'E:/DataScience/UW_MSDS/!UW-710/Final_Project/Final_Output/Output_File/'
file = 'Training_Gun_Tweets_v6.csv'
df_tweet = pd.read_csv(path + file, encoding='utf-8')


# # for testing
# # df_tweet = df_tweet.head(n = 100)
# # # get list of hashtags
# print('hashtag -----------------------------------------------------')
# # ngrams
# n = 1
# min_count = 0.5
# trim_text = True
# word_vector = True
# # get all items in column
# hashtags = fm.getNGrams(df_tweet['hashtags'], n, trim_text, word_vector)
# # print('all_vals:','len:', len(hashtags),hashtags)
# # print('------------------------------------------------------')
# # # faltten file
# flat_hashtags = fm.flatten_list(hashtags)
# # print('flat_list:','len:', len(flat_hashtags),flat_hashtags)
# # print('------------------------------------------------------')
# # unique list
# uniq_hash = []
# [uniq_hash.append(x) for x in flat_hashtags if x not in uniq_hash]
# # print('uniq_list:','len:', len(uniq_hash),uniq_hash)
# # print('------------------------------------------------------')
# # top list
# top_hashtags = fm.top_list(uniq_hash, flat_hashtags, min_count)
# print('top:','len:', len(top_hashtags),top_hashtags)
# print('------------------------------------------------------')
# hashtag_series = pd.Series(top_hashtags)
# file = 'top_hashtags_v4.csv'
# hashtag_series.to_csv(path_2 + file, index=False, header = False, encoding = 'utf-8', mode='w')
# print('done')
#
#
# # get list of words
# print('words -----------------------------------------------------')
# # ngrams
# n = 1
# min_count = 0.5
# trim_text = True
# word_vector = False
# # get all items in column
# all_vals = fm.getNGrams(df_tweet['text'], n, trim_text, word_vector)
# # print('all_vals:','len:', len(all_vals),all_vals)
# # print('------------------------------------------------------')
# # # faltten file
# flat_list = fm.flatten_list(all_vals)
# # print('flat_list:','len:', len(flat_list),flat_list)
# # print('------------------------------------------------------')
# # unique list
# uniq_list = []
# [uniq_list.append(x) for x in flat_list if x not in uniq_list]
# # print('uniq_list:','len:', len(uniq_list),uniq_list)
# # print('------------------------------------------------------')
# # # top list
# top_list = fm.top_list(uniq_list, flat_list, min_count)
# print('top:','len:', len(top_list),top_list)
# print('------------------------------------------------------')
# text_series = pd.Series(top_list)
# file = 'top_word_list_v4.csv'
# text_series.to_csv(path_2 + file, index=False, header = False, encoding = 'utf-8', mode='w')
# print('done')


# # get list of words in user desc
print('user desc -----------------------------------------------------')
# ngrams
n = 1
min_count = 0.5
trim_text = False
word_vector = False
# get all items in column
all_vals = fm.getNGrams(df_tweet['user_desc'], n, trim_text, word_vector)
# print('all_vals:','len:', len(all_vals),all_vals)
# print('------------------------------------------------------')
# # faltten file
flat_list = fm.flatten_list(all_vals)
# print('flat_list:','len:', len(flat_list),flat_list)
# print('------------------------------------------------------')
# # unique list
uniq_list = []
[uniq_list.append(x) for x in flat_list if x not in uniq_list]
# print('uniq_list:','len:', len(uniq_list),uniq_list)
# print('------------------------------------------------------')
# # top list
top_desc = fm.top_list(uniq_list, flat_list, min_count)
print('top:','len:', len(top_desc),top_desc)
print('------------------------------------------------------')
desc_series = pd.Series(top_desc)
file = 'top_desc_list_v4.csv'
desc_series.to_csv(path_2 + file, index=False, header = False, encoding = 'utf-8', mode='w')

print('done')