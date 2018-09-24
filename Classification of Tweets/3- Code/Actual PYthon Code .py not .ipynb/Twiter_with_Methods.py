from Twitter_Methods_V1 import twitter_class as twitter
import datetime


print('Start:',datetime.datetime.now())
max_tweets = 150000
hashtag = ['guncontrol','nra']


start_date_vector =['2018-02-24', '2018-02-25','2018-02-26','2018-02-27','2018-02-28','2018-03-01','2018-03-02',
                    '2018-03-03','2018-03-04']
end_date_vector =['2018-02-25', '2018-02-26','2018-02-27','2018-02-28','2018-03-01','2018-03-02','2018-03-03',
                  '2018-03-04', '2018-03-05']



for cycle in range(len(start_date_vector)):
    print('Cycle',cycle)
    start_date = start_date_vector[cycle]
    end_date = end_date_vector[cycle]
    print('Start of ',start_date,'to', end_date,'collection: ',datetime.datetime.now())
    # Get Tweets as list of Json Objects then Pandas DataFrames
    twitter_api = twitter.api()
    twitter.search_twitter(twitter_api, hashtag, max_tweets, start_date, end_date)

    print('End of ',start_date,'to', end_date,'collection: ',datetime.datetime.now())
    print('--------------------------------------------------------------')


print('Finsished program')