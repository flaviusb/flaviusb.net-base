#!/bin/bash

for i in $bloglocation/*.sh
do
  location="$blogout/$(. $i; echo $CANONICAL).html"
  echo $(. $i; ./blog-post-container.sh) > $location
done
