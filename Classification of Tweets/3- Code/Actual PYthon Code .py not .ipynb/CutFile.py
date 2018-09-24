import csv
import pandas as pd
import datetime as dt
import math

print(dt.datetime.now())
# path = 'RandomForest/'
# path = 'C:/Users/pete.kelley/Documents/DataScience/UW_MSDS/!UW-710/Final_Project/Raw_Files/'
path = 'E:/DataScience/UW_MSDS/!UW-710/Final_Project/Raw_Files/'
# path_2 = 'RandomForest/'
# path_2 = 'C:/Users/pete.kelley/Documents/DataScience/UW_MSDS/!UW-710/Final_Project/Final_Output/Output_File/'
path_2 = 'E:/DataScience/UW_MSDS/!UW-710/Final_Project/Final_Output/Output_File/'


load_file = ['nra_2018-02-24_tweets.csv', 'nra_2018-02-25_tweets.csv', 'nra_2018-03-03_tweets.csv', 'guncontrol_2018-02-24_tweets.csv', 'guncontrol_2018-02-25_tweets.csv', 'guncontrol_2018-03-03_tweets.csv']
load_file=['guncontrol_2018-03-04_tweets.csv']
# df_tweet = pd.read_csv(path + load_file, encoding='utf-8')

chunksize = 10 ** 5

for each in load_file:
    chunks = []
    for chunk in pd.read_csv(path + each, engine='python', chunksize=chunksize, encoding='utf-8', header = 'infer', iterator= True ):
        chunks.append(chunk)

    df_tweet = pd.concat(chunks, axis=0)
    print(df_tweet.shape)

    file_len = df_tweet.shape[0]
    for i in range(math.ceil(file_len/2000)):
        start_val = i*2000
        end_val = start_val + 2000
        if(end_val > file_len):
            end_val = file_len
        load = each[:-4] + '_step_' + str(i+1) + '.csv'
        # df_tweet.to_csv(path_2 + load_file, index=False)
        df_tweet[start_val:end_val].to_csv(path + load, sep=',', na_rep='', index=False, encoding='utf-8')
        print('file',load, 'saved')
