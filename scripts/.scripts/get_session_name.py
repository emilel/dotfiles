#!/bin/python

import sys

names = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
sessions = sys.argv[1:]
name = next(name for name in names if name not in sessions)
print(name)
