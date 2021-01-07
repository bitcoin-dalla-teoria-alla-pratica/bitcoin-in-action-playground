#!/usr/bin/env python
import time
import sys

plus = 20

if len(sys.argv) >= 2:
    plus = int(sys.argv[1])

ts=time.time()
if len(sys.argv) == 3:
    ts = int(sys.argv[2])

now = int(ts)

forward = plus + now

print(forward, end='')
