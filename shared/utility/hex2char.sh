#!/bin/sh
expr `echo "ibase=16; $(printf $1 | tr '[:lower:]' '[:upper:]')" | bc` "*" 2
