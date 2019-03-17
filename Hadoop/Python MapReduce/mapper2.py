#!/usr/bin/env python
#Be sure the indentation is identical and also be sure the line above this is on the first line
import sys
import re
def main(argv):
  line = sys.stdin.readline()
  pattern = re.compile("[^\s]+")
  letter_vector = []
  letter_string = None
  final_string = []
  while line:
    for word in pattern.findall(line):
      letter_string = ''
      for letter in word.lower():
        if letter in 'aeiou':
          letter_vector.append(letter) # get list of all vowels for each word
      if len(letter_vector) == 0: # place holder IF there are no vowels in the word
        letter_string = '_'
      else:
        letter_vector.sort()
      for each in letter_vector:
        letter_string = letter_string + each # captures letter_vector or place holder as a string 
      final_string.append(letter_string) # add all word to final string
      letter_vector = []
      
    for each in final_string:
      print(each + '\t' +'1')
    final_string = []
    line = sys.stdin.readline()

#Note there are two underscores around name and main
if __name__ == "__main__":
  main(sys.argv)

    
    