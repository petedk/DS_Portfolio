#!/usr/bin/env python
 
import sys

def find_big_spender(curent_dict):
  max_spend = -1000
  max_spender = None
  additional_spenders = None
  cust = None
  for key, total in curent_dict.items():
    if total == max_spend:
      if max_spender: # checking if there is a value for max_spender (not first pass to find max spender)
        cust = key.split(':')[1] # get cust portion of key
        if additional_spenders: # checking if there is a value for additional_spenders (not first additional_spenders)  
          additional_spenders = additional_spenders + ',' + cust # expand additional_spenders list
        else:
          additional_spenders = cust
      else:
        max_spender =  key # start max spender list
    elif total > max_spend: 
      max_spender =  key # new max spender
      max_spend = total # new max spend
  if cust: # if list of big spenders
    print(max_spender  + ',' + cust)
  else:
    print(max_spender)
    # print('{0}\t{1}'.format(max_spender, max_spend))
  
 
def main(argv):
  #Variables that keep track of the keys.
  curent_dict = {}
  curent_key = ''
  old_key = ''

  for line in sys.stdin:
    line = line.strip()
    # get key value par
    curent_key, value = line.split('\t', 1)
    # get customer and spend from value
    curent_cust, spend = value.split(',',1)
    spend = float(spend)
    if (curent_key == old_key): # another record for same key
      if (curent_key+':'+curent_cust in curent_dict): # another record for same cust
        # update dict with additional spend
        curent_dict[curent_key+':'+curent_cust] = curent_dict[curent_key+':'+curent_cust] + spend
      else: # new cust.. and new dict key
        curent_dict[curent_key+':'+curent_cust] = spend
    else: # new key or 1st key
      # If not 1st key... find max value from old key
      if old_key: # checking if there is a value for old_key (not first record)
        find_big_spender(curent_dict) # method to find and print big spender(s)
      # set or rest vars
      curent_dict = {}
      curent_dict[curent_key+':'+curent_cust] = spend
      old_key = curent_key


  # After last line is read... this checks max values for the last dictionary
  find_big_spender(curent_dict) # method to find and print big spender(s)

    
#Note there are two underscores around name and main
if __name__ == "__main__":
  main(sys.argv)
