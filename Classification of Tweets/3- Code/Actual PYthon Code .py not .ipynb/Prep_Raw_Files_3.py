import pandas as pd
import datetime as dt
import math
import csv
import os
import fnmatch
from Final_Methods_V3 import final_methods as fm

print(dt.datetime.now())
# path = 'RandomForest/'
# path = 'C:/Users/pete.kelley/Documents/DataScience/UW_MSDS/!UW-710/Final_Project/Raw_Files/'
path = 'E:/DataScience/UW_MSDS/!UW-710/Final_Project/Raw_Files/'
# path_2 = 'RandomForest/'
# path_2 = 'C:/Users/pete.kelley/Documents/DataScience/UW_MSDS/!UW-710/Final_Project/Final_Output/Output_File/'
path_2 = 'E:/DataScience/UW_MSDS/!UW-710/Final_Project/Final_Output/Output_File/'


# file_name = ['nra_2018-02-24_tweets_step_']
# file_count = [45]
# file_name = ['Training_Gun_Tweets_v6']
# file_count = [1]

# for j in range(1):

    # for i in range(file_count[j], 2, 1):
    # for i in range(file_count[j], 30, -1):
objects = fnmatch.filter(os.listdir(path), '*.csv')
i = 1
for load_file in objects:
    # load_file = file_name[j] + str(i) + '.csv'
    # load_file = 'Training_Gun_Tweets_v6.csv'
    print(path,load_file)

    # df_tweet = pd.read_csv('E:/DataScience/UW_MSDS/!UW-710/Final_Project/Raw_Files/Training_Gun_Tweets_v6.csv',
    # encoding='utf-8')
    df_tweet = pd.read_csv(path + load_file, encoding='utf-8')

    # # drop unused columns
    # drop_col = ['retweet_id']
    # # drop_col = ['id', 'retweet_id', 'user_id', 'user_loc', 'user_time_zone', 'user_created_at', 'created_at',
    # # 'retweet_count']
    # for each in drop_col:
    #     df_tweet = df_tweet.drop([each], axis=1)

    # for testing
    # df_tweet = df_tweet[1096:1097]

    col_count = 0

    first_col = df_tweet.shape[1]
    print('hashtag -----------------------------------------------------')
    n = 1
    trim_text = True
    word_vector = False
    # top list
    file = 'top_hashtags_v5.csv'
    with open(path_2 + file, 'r', encoding='utf-8') as f:
      reader = csv.reader(f)
      top_hashtags = list(reader)
    print('top:',len(top_hashtags))
    # print('top:','len:', len(top_hashtags),top_hashtags)
    print('------------------------------------------------------')
    # create new columns (Random Forest can only take 32 levels for any given column
    fm.add_new_col_df('#_',top_hashtags, 'hashtags', df_tweet, n, trim_text, word_vector)
    last_col = df_tweet.shape[1]
    # # combine columns
    # col_count = fm.combine_col(df_tweet, first_col, last_col, col_count)
    # # drop columns
    # print('Drop hashtags')
    # for each in top_hashtags:
    #     df_tweet = df_tweet.drop('#_' + each[0], axis=1)
    print('done')

    first_col = df_tweet.shape[1]
    # get list of words
    print('words -----------------------------------------------------')
    # ngrams
    n = 1
    min_count = 0.5
    trim_text = True
    word_vector = False
    # # top list
    file = 'top_word_list_v6.csv'
    with open(path_2 + file, 'r', encoding='utf-8') as f:
      reader = csv.reader(f)
      top_list = list(reader)
    print('top:', len(top_list))
    # print('top:','len:', len(top_list),top_list)
    print('------------------------------------------------------')
    # create new columns (Random Forest can only take 32 levels for any given column
    fm.add_new_col_df('t_', top_list, 'text', df_tweet, n, trim_text, word_vector)
    # for testing
    # fm.add_new_col_df('t_',top_list[57:59], 'text', df_tweet, n, trim_text, word_vector)
    last_col = df_tweet.shape[1]
    # combine columns
    # col_count = fm.combine_col(df_tweet, first_col, last_col, col_count)
    # # drop columns
    # print('Drop words')
    # for each in top_list:
    #     df_tweet = df_tweet.drop('t_' + each[0], axis=1)
    # print('done')

    first_col = df_tweet.shape[1]+1
    # # # get list of words in user desc
    print('user desc -----------------------------------------------------')
    # ngrams
    n = 1
    min_count = 0.5
    trim_text = False
    word_vector = False
    # top list
    file = 'top_desc_list_v6.csv'
    with open(path_2 + file, 'r', encoding='utf-8') as f:
      reader = csv.reader(f)
      top_desc = list(reader)
    print('top:', len(top_desc))
    # print('top:','len:', len(top_desc),top_desc)
    print('------------------------------------------------------')
    # create new columns (Random Forest can only take 32 levels for any given column
    fm.add_new_col_df('u_',top_desc, 'user_desc', df_tweet, n, trim_text, word_vector)
    # last_col = df_tweet.shape[1]
    # # # # combine columns
    # # # col_count = fm.combine_col(df_tweet, first_col, last_col, col_count+1)
    # # # # drop columns
    # # # print('Drop user desc')
    # # # for each in top_desc:
    # # #     df_tweet = df_tweet.drop('u_' + each[0], axis=1)
    # # # print('done user desc')
    # # # drop extra columns
    # # # dropping the following becuase they are redundant ['hashtags','user_desc','text']


    # drop_col = ['hashtags', 'user_desc','text']
    # for each in drop_col:
    #     df_tweet = df_tweet.drop([each], axis=1)
    print('Save file')
    load = load_file[:-4]+'_ready_for_RF_2.csv'
    # df_tweet.to_csv(path_2 + load_file, index=False)
    # df_tweet.to_csv('~/'+ path_2 + load, sep=',', na_rep='', index=False, encoding='utf-8')
    df_tweet.to_csv(path_2 + load, sep=',', na_rep='', index=False, encoding='utf-8')

    print(dt.datetime.now())
    print('done with file ',load_file, i)
    i += 1
    # break
print('done with all cycles')