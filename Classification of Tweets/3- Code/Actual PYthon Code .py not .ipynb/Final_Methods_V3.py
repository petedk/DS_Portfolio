import pandas as pd
import datetime as dt
import math
import numpy as np
import math
import re
import string
from nltk import ngrams



class final_methods(object):

    @staticmethod
    def prep_words(df_column):
        words = []
        for row in df_column:
            try:
                if (row[0] == 'b'):
                    row = row[1:]
                for each in row[1:-2].split(','):
                    for word in each.split():
                        if(type(word) == 'float'):
                            words.append(word)
                        else:
                            words.append(word.lower().replace('"', '').replace("'", "").replace('@','').strip())
            except:
                words.append('')
        return(words)

    def getNGrams(df_column, n, trim=True, vector_cell = True):
        # print('df_column:',df_column)
        ngram_result = []
        for row in df_column:
            if(vector_cell):
                row = ''.join(row)
            try:
                if (row[0] == 'b'):
                    wordlist = row[1:]
            except:
                row = row
            if(trim):
                row = row[1:-1]
            # print('row_posttrim:', row)
            try:
                if(len(row.split()) < n):
                    n_row = len(row.split())
                else:
                    n_row = n
                word_list = []
                # print('len:',len(row.split()))
                # print('n - 1:', n_row - 1)
                # print('range:',range(len(row.split())-(n_row-1)))
                for i in range(len(row.split())-(n_row-1)):
                    temp = []
                    for word in row.split()[i:i+n_row]:
                        # print('word:', word.lower().replace('"', '').replace("'", "").replace('!', '').replace("?", "").replace(".", "").replace(",", "").strip())
                        temp.append(word.lower().replace('"', '').replace("'", "").replace('!', '')\
                                    .replace("?","").replace(".", "").replace(",", "").replace("&", "")\
                                    .replace("\\", "").strip())
                        # print('temp: ', temp)
                    word_list.append(temp)
                    # print('wordlist:', word_list)
                ngram_result.append(word_list)
            except:
                ngram_result.append('')
                ngram_result = ngram_result[:-1]

            # print('ngram:', ngram_result)
        return (ngram_result)

    def combine_col(df, start_num, end_num, col_count):
        span = end_num - start_num
        # print(span, end_num, start_num)
        cycles = math.ceil(span/5)
        for i in range(cycles):
            if(i%1000 == 0):
                print(i, 'of', cycles, '-', dt.datetime.now())
            i_min = start_num + (i) * 5
            i_max = start_num  + (i)*5 + 4
            # print('Start', start_num, 'i', i_min, i_max, 'len:', span)
            if (i_max > end_num ):
                i_max = end_num
            # print('Adjusted i_max',i_max,)
            temp_df = df.iloc[:,i_min: i_max]
            # print('temp_df',temp_df)
            new = pd.Series([','.join(row.astype(str)) for row in temp_df.values], index=temp_df.index)
            # print('new', new)
            df[col_count+ i] = pd.Series(new, index=df.index)
        col_count += i
        return (col_count)
    def one_row_n_grams(wordlist, n, trim=True, vector_cell = True):
        # print('----------------------------------')
        # print('One row wordlist: ', wordlist, len(wordlist))
        if (vector_cell):
            # print('vector_cell: ', vector_cell, 'Wordlist:', wordlist)
            wordlist = ''.join(wordlist)
            # print('Wordlist: ', wordlist)
        try:
            if (wordlist[0] == 'b'):
                wordlist = wordlist[1:]
        except:
            # print('except')
            return ()
        if(trim):
            wordlist = wordlist[1:-1]
        # print('wordlist:', wordlist)
        # print('len:',len(wordlist.split()))
        if(len(wordlist.split()) < n):
            n = len(wordlist.split())
        t_list = []
        for i in range(len(wordlist.split())-(n-1)):
            temp = wordlist.lower().replace('"', '').replace("'", "").replace('!', '') \
                  .replace("?", "").replace(",", "").replace(".", "").replace("#", "") \
                       .replace("@", "").replace(":", "").replace(";", "").replace("/", "")\
                       .replace("-", "").replace("\\n", "").replace("\\","").replace("~","").split()[i:i+n]
            # temp = temp.replace("\\", "")
            # print('temp:', temp)
            if(len(temp)> 0):
                t_list.append(temp)
        # print('t_list:',t_list)
        return (t_list)

    def build_n_grams(df_column, n):
        ngram_result = []
        for row in df_column:
            try:
                if (row[0] == 'b'):
                    row = row[1:]
                # print('row:',row)
                for each in row[1:-2].split(','):
                    if (n > len(each)):
                        n = len(each)
                    # print('each:',each)
                    temp = ngrams(each.split(), n)
                    # print('temp:',temp)
                    for t in temp:
                        # print('t:',t)
                        ngram_result.append(t)
            except:
                ngram_result.append('')
        return (ngram_result)


    def match_ngrams(vector, level, n, trim, vector_cell):
        # print('n:',n)
        result = []
        # for item in vector:
        for row in list(vector):
            # print('----------------------------------')
            found = '!'
            # print('row', row)
            try:
                # print('Try, row:',row)
                n_gram_row = final_methods.one_row_n_grams(row, n, trim,vector_cell)
                # print(n_gram_row)
                # print('n_gram',n_gram_row)
                for each in n_gram_row:
                    # used when top lists are from file
                    # print('cell:',each[0], len(each[0]),'level:',level[0], len(level[0]))
                    if (each[0] == level[0]):
                        # print('true')
                        found = level[0]
                    # used with top list is being discovered
                    # print('cell:',each[0],'level:',level)
                    # if (each[0] == level):
                    #     print('true')
                    #     found = level
            except:
                found = '!'
            result.append(found)
        # print('result', result)
        return (result)


    def match_level(vector, level):
        result = []
        # for item in vector:
        for row in list(vector):
            # print('----------------------------------')
            found = 0
            # print('row', row)
            try:
                for each in row[1:-1].lower().replace('"', '').replace("'", "").split(','):
                    # print('cell',each.strip(),level)
                    if (each.strip() == level):
                        # print('true')
                        found = 1
            except:
                found = 0
            result.append(found)
        # print('result', result)
        return (result)

    def flatten_list(list):
        flat_file = []
        for sublist in list:
            for item in sublist:
                flat_file.append(item[0])
        return (flat_file)

    def top_list(uniq_list, flat_list, min_count):
        top_list = []
        for each in uniq_list:
            if(flat_list.count(each)>min_count):
                top_list.append(each)
        return (top_list)

    def add_new_col_df(col_prefix , list,column_name, df, n, trim_text, word_vector):
        i = 1
        l = len(list)
        for level in list:
            # print('i', i, 'len', l)
            # print(level)
            # print(level[0])
            if(i % 250 == 0 ):
                print('Added ',i, 'out of ', l, 'columns. - ',dt.datetime.now())
            new_col = col_prefix + str(level[0])
            df[new_col] = final_methods.match_ngrams(df[column_name], level, n, trim_text, word_vector)
            i += 1

    def remove_common_words(vector):
        common_words = ('_&amp;','a', 'about', 'after', 'all', 'also', 'an', 'and', 'any', 'are', 'as', 'at', 'back','be', 'because', 'been',
        'believe', 'bring', 'but', 'by', 'can', 'come', 'could', 'day', 'did', 'do', 'down', 'even', 'first', 'from', 'get',
        'give', 'go', 'good', 'has', 'hat', 'have', 'he', 'her', 'him', 'his', 'how', 'i', 'if', 'in', 'into', 'is', 'it',
        'its', 'just', 'know', 'last', 'like', 'look', 'make', 'me', 'most', 'must', 'my', 'new',  'of', 'on', 'one',
        'only', 'or', 'other', 'our', 'out', 'over', 'person', 'say', 'see', 'she', 'should', 'so', 'some', 'take', 'than', 'that',
        'the', 'their', 'them', 'then', 'there', 'these', 'they', 'think', 'this', 'time', 'to', 'two', 'under', 'up', 'us',
        'use', 'want', 'was', 'way', 'we', 'well', 'were', 'what', 'when', 'which', 'who', 'will', 'with', 'work', 'would',
        'year', 'you', 'your')

        text = [word if word not in common_words else '' for word in vector]
        return(text)

