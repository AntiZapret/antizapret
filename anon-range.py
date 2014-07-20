#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Create list which can be used in https://github.com/edsu/anon
# Строит список, который можно использовать в https://github.com/edsu/anon
import re
import json

def generate(filename,namevar):
  ranges = {'ranges':{}}
  with open(filename) as f:
    for line in f.readlines():
      if re.match('#' + namevar + ': ', line):
        name = line.replace('#' + namevar + ': ','').replace('\n','')
        ranges['ranges'][name] = []
      elif re.match(r'^[0-9a-fA-F:]', line):
        if name in ranges['ranges']:
          ranges['ranges'][name].append(line.replace('\n',''))
        else:
          ranges['ranges'][name] = [line.replace('\n','')]
    print json.dumps(ranges, ensure_ascii = False, sort_keys=True, indent=2, separators=(',', ': '))

generate('blacklist4.txt','name')
generate('blacklist4.txt','enname')
