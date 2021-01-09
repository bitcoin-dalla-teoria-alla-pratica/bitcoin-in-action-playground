#!/usr/bin/env python
import sys

seconds = int(sys.argv[1])

a512 = int(seconds/512)

binValue = "{0:b}".format(a512)

print(binValue.zfill(16))
