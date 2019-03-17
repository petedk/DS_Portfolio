#!/usr/bin/env python
#Be sure the indentation is identical and also be sure the line above this is on the first line
import sys
import re
def main(argv):
  line = sys.stdin.readline()
  while line:
    # split line by ','
    parts = line.split(',')
    # check to make sure this isn't the header row.. if it is the header row don't do anything with the data
    if(('InvoiceNo' not in parts[0]) and (parts[0][0] != 'C') and (len(parts[6]) > 0 )):
      # get the data from part 4 of the line and split into data parts 
      date = parts[4].split('/')
      # check if 1 digit month
      if(len(date[0] )==1):
        date = str('0'+date[0])
      else:
        date = str(date[0])
      # print output in the form of mm,country tab customer,caspend
      key = str(date +','+parts[7].strip('\n'))
      sales = str(float(parts[3]) * float(parts[5]))
      value = str(parts[6]+','+ sales)
      print('{0}\t{1}'.format(key, value))

    line = sys.stdin.readline()

#Note there are two underscores around name and main
if __name__ == "__main__":
  main(sys.argv)
