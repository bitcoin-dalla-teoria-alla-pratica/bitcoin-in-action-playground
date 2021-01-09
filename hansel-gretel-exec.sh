#!/bin/bash

echo "====> exec output on Hansel container <===="
docker exec -ti hansel $@

echo "====> exec output on Hansel container <===="
docker exec -ti gretel $@