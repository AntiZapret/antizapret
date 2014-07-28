#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Строит список, который можно использовать в https://github.com/edsu/anon
import re
import json

ranges = {'ranges':{}}
with open('blacklist4.txt') as f:
  for line in f.readlines():
    if re.match(r'#name: ', line):
      name = line.replace('#name: ','').replace('\n','')
    elif re.match(r'^[0-9a-fA-F:]', line):
      if name in ranges['ranges']:
        ranges['ranges'][name].append(line.replace('\n',''))
      else:
        ranges['ranges'][name] = [line.replace('\n','')]
  print json.dumps(ranges, ensure_ascii = False, sort_keys=True, indent=4, separators=(',', ': '))
