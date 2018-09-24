# You must install the tweepy package before using it!
# pip install tweepy
import tweepy
from time import sleep
import datetime
import pandas as pd

row_count_to_sleep_at = 17000
min_to_sleep = 12
tweets_per_request = 100
print_progress_row_count = 1000


class twitter_class(object):

    @staticmethod
    def api():
        consumer_key = ''
        consumer_secret = ''
        access_token = ''
        access_secret = ''

        # Use tweepy.OAuthHandler to create an authentication using the given key and secret
        auth = tweepy.OAuthHandler(consumer_key=consumer_key, consumer_secret=consumer_secret)
        auth.set_access_token(access_token, access_secret)

        # Connect to the Twitter API using the authentication
        # Connect to the Twitter API using the authentication
        api = tweepy.API(auth, wait_on_rate_limit=True, wait_on_rate_limit_notify=True, \
                         parser=tweepy.parsers.JSONParser())
        return (api)

    def search_twitter(api, hashtag, max_rows, start_date, end_date):
        current_row_count_for_sleep = 0
        for each in hashtag:
            print('Hashtag: ', each)
            again = True
            num_needed = max_rows
            tweet_list = []
            last_id = -1  # id of last tweet seen
            while len(tweet_list) < num_needed:
                try:
                    new_tweets = api.search(q='#%23' + each, tweet_mode='extended', since=start_date,\
                                            until=end_date, lang="en", count = tweets_per_request ,\
                                            max_id=str(last_id - 1))
                except tweepy.TweepError as e:
                    print("Error", e)
                    break
                else:
                    if not new_tweets:
                        print("Could not find any more tweets!")
                        break
                    tweet_list.extend(new_tweets['statuses'])
                    try:
                        last_id = new_tweets['statuses'][-1]['id']
                    except:
                        print('Last ID out of range', len(tweet_list))
                        break
                    print("...%s tweets downloaded so far" % (len(tweet_list)))
                    current_row_count_for_sleep += len(new_tweets['statuses'])
                    current_row_count_for_sleep = twitter_class.time_to_sleep(current_row_count_for_sleep)

            csv_df = twitter_class.build_df_to_save(tweet_list,each)
            twitter_class.write_to_csv(csv_df,each, start_date)

    def time_to_sleep(row_count):
        if (row_count > row_count_to_sleep_at):
            print('Sleep start:', datetime.datetime.now())
            row_count = 0
            for i in range(min_to_sleep):
                sleep(60)
                print('Slept for', i + 1, 'min(s).')
            print('Sleep end:', datetime.datetime.now())
        return (row_count)

    def build_df_to_save (tweet_list, hastag):
        # transform the tweepy tweets into a dataframe array that will populate the csv
        column_names = ['id', 'hashtags', 'retweet_id', 'user_id', 'user_loc', 'user_time_zone',
                        'user_created_at', 'user_desc', 'created_at','retweet_count' ,'text']
        nrows = len(tweet_list)
        outtweets = pd.DataFrame(index=range(nrows), columns=column_names)
        for i in range(nrows):
            if 'id' in tweet_list[i]:
                value = tweet_list[i]['id']
            else:
                value = ''
            outtweets['id'][i] = value

            if 'entities' in tweet_list[i]:
                value = []
                for tag in tweet_list[i]['entities']['hashtags']:
                    value.append(tag['text'])
            else:
                value = ''
            outtweets['hashtags'][i] = value

            if 'retweeted_status' in tweet_list[i]:
                value = tweet_list[i]['retweeted_status']['id']
            else:
                value = ''
            outtweets['retweet_id'][i] = value

            if 'user' in tweet_list[i]:
                outtweets['user_id'][i] = tweet_list[i]['user']['id']
                outtweets['user_loc'][i] = tweet_list[i]['user']['location']
                outtweets['user_time_zone'][i] = tweet_list[i]['user']['time_zone']
                outtweets['user_created_at'][i] = tweet_list[i]['user']['created_at']
                outtweets['user_desc'][i] = tweet_list[i]['user']['description']

            if 'created_at' in tweet_list[i]:
                value = tweet_list[i]['created_at']
            else:
                value = ''
            outtweets['created_at'][i] = value

            if 'retweet_count' in tweet_list[i]:
                value = tweet_list[i]['retweet_count']
            else:
                value = ''
            outtweets['retweet_count'][i] = value


            if 'full_text' in tweet_list[i]:
                value = tweet_list[i]['full_text'].encode("utf-8")
            else:
                value = ''
            outtweets['text'][i] = value

            if(i % print_progress_row_count ==0):
                print(i, 'rows have been preped for the csv file')
        return(outtweets)


    def write_to_csv(csv_df, hastag, date):
        # write the csv
        file_name = str(hastag) +'_' + date + '_tweets.csv'
        csv_df.to_csv(file_name, sep=',', index=False, encoding='utf-8')