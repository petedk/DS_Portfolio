#!/usr/bin/env python
 
import sys

def print_result(curent_dict):
  for key, total in curent_dict.items():
    if key == '_':
      key = ''
  print(key+':'+str(total))
 
def main(argv):
  #Variables that keep track of the keys.
  curent_dict = {}
  curent_key = ''
  old_key = None

  for line in sys.stdin:
    line = line.strip()
    curent_key, value = line.split('\t', 1)
    # print('curent_key:',curent_key,', value: ',value)
    if (curent_key == old_key): # another record for same key
      curent_dict[curent_key] = curent_dict[curent_key] + 1
    else: # new key or 1st key
      if old_key:
        print_result(curent_dict) # method to print results
      # set or reset vars
      curent_dict = {}
      curent_dict[curent_key] = 1
      old_key = curent_key


  # After last line is read... this checks max values for the last dictionary
  for key, total in curent_dict.items():
    print_result(curent_dict) # method to print results
    
#Note there are two underscores around name and main
if __name__ == "__main__":
  main(sys.argv)

