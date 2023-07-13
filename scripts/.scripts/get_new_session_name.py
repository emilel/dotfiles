#!/bin/python

import sys
import itertools

numbers = itertools.count(2)
session = sys.argv[1].split("[")[0]
sessions = sys.argv[2:]
name = next(
    new_name for number in numbers if (new_name := f"{session}.{str(number)}") not in sessions
)
print(name)
