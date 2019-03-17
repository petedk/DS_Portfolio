#!/usr/bin/env python
#Be sure the indentation is identical and also be sure the line above this is on the first line
import sys
import re
def main(argv):
  line = sys.stdin.readline()
  pattern = re.compile("[^\s]+")
  result = ''
  while line:
    part1, part2 = line.split(':')
    # Get the raw data to identify all first order friends, this will be used as an exclude list in the reducer
    # 1: 2 3 4
    # part 1 = 1
    # part 2 = 2 3 4
    result += part1.strip()+'\tf:'+part2.strip() + '\n' 
    # result = 1	f:2 3 4
    # create a new list for every one of my first order friends, and then show all of theie potential friends
    f_list = [] 
    # for each of the primary persons friends
    for friend in pattern.findall(part2):
      f_list.append(friend)
    for i in range(len(f_list)):
      temp = ''
      # create a list of all of my friends, except the ith friend
      temp_l = [element for j, element in enumerate(f_list) if j != i]
      for part in temp_l:
        temp += part + ' '
      # add additonal result to output for the ith friend and their potential friends
      result += f_list[i]+'\tp:'+temp + '\n'
      # result = 1	f:2 3 4\n2	p:3 4\n3	p:2 4\n4	p:2 3\n
  
  
    line = sys.stdin.readline()
  print(result[:-1])

#Note there are two underscores around name and main
if __name__ == "__main__":
  main(sys.argv)

    
    