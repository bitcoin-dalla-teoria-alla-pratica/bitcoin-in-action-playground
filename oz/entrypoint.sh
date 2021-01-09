#!/bin/bash

yarn
echo "==========================================================="
echo "$(date) - Oz container up and running!!" >> /var/log/oz.log
echo "$(date) - Append to /var/log/oz.log to see message here!" >> /var/log/oz.log
tail -f /var/log/oz.log