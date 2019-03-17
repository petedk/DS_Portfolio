#!/usr/bin/env python
 
import sys
import re
 
def potential(dict):
  Probably = []
  Might = []
  p_result = ''
  m_result = ''
  # if 4 or more secondary connections count them as Probably
  for key, count in dict.items():
   if count >3:
     Probably.append(int(key))
     Probably.sort()
   # else if 2 or more secondary connections count them as Might
   elif count >=2:
     Might.append(int(key))
     Might.sort()   
  # collect results as strings
  s = ''
  for each in Probably:
    s += str(each) + ','
    p_result = s[0:len(s)-1]
  s = ''
  for each in Might:
    s += str(each) + ','
    m_result = s[0:len(s)-1] 
  return (m_result, p_result)

def print_output(old_key, m_result,p_result):
  # format and print result
  result = old_key+':'
  if m_result:
    result += 'Might('+m_result+')'
  if p_result:
    result += ' Probably('+p_result+')'
  print(result)

def exclude_list(key, value):
  # get exclude list (don't want to count first order friends as potential friends)
  pattern = re.compile("[^\s]+")
  exclude = pattern.findall(value[2:]) 
  exclude.append(key)
  return exclude

def build_dict(temp,exclude):
  curent_dict = {}
  for row in temp:
    for each in row:
      if(each not in exclude): # ignore first order friends in exclude list, and count how many times a potential friend shows up
        if each in curent_dict.keys():
          curent_dict[each] = curent_dict[each] + 1
        else:
          curent_dict[each] = 1
  return curent_dict

def main(argv):
  #Variables that keep track of the keys.
  key = ''
  pattern = re.compile("[^\s]+")
  old_key = None
  exclude = ['']
  temp = []

  for line in sys.stdin:
    line = line.strip()
    key, value = line.split('\t', 1)
    if (key == old_key): # another record for same key
      if(value[:2] == 'f:'): # if value[:2] == 'f:' build exclude list
        exclude = exclude_list(key, value)
      else:
        temp.append(pattern.findall(value[2:])) # build a list of the potential friends
    else: # new key or 1st key
      if old_key:# if not new.. all potential friends (temp list) and first order friends (exclude list) have been found. If temp is empty there are no potential friends
        curent_dict = build_dict(temp,exclude) # get dict of all potential friends
        m_result,p_result = potential(curent_dict) # method to turn dict into string of maybe and prob friends
        print_output(old_key,m_result,p_result) # method to print output
      # set or reset vars
      old_key = key
      temp = []
      exclude = ['']
      if(value[:2] == 'f:'):
        exclude = exclude_list(key, value)
      else: # else get temp[]
       temp.append(pattern.findall(value[2:]))	


# After last line is read... this checks max values for the last dictionary
  if temp:
    curent_dict = build_dict(temp,exclude) # get dict of all potential friends
    m_result,p_result = potential(curent_dict)
    print_output(old_key,m_result,p_result)


#Note there are two underscores around name and main
if __name__ == "__main__":
  main(sys.argv)