#!/bin/python

import sys

print(sys.argv)
group_size, session_name = sys.argv[1:]
print(group_size)

SESSION_FG = "colour237,bold"
SESSION_BG = "colour172"
style = (
    "#["
    f"bg={SESSION_BG}"
    f",fg={SESSION_FG}"
    f",{'italics' if group_size and int(group_size) > 1 else 'noitalics'}"
    "]"
)

print(f"{style}  {session_name}  ")
