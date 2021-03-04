#!/bin/bash

set -e

export realbloglocation=`readlink -f $bloglocation`
export realblogout=`readlink -f $blogout`
#invokedfrom=`pwd`
codeloc_temp=`readlink -f ${BASH_SOURCE[0]}`
export codeloc=`dirname $codeloc_temp`
#echo $codeloc

cd $realbloglocation

relevantfiles=`git ls-files *.sh`
#echo $relevantfiles
for i in $relevantfiles
do
  location="$realblogout/$(. $i; echo $CANONICAL).html"
  PUBLISHDATE=`git log --branches=[p]ublish --reverse --pretty=format:%as -n 1 $i`
  EDITDATE=`git log --branches=[p]ublish --pretty=format:%as -n 1 $i`
  echo $(. $i; export PUBLISHDATE="$PUBLISHDATE"; export EDITDATE="$EDITDATE"; . $codeloc/date-section.sh; $codeloc/blog-post-container.sh) > $location
done

DATEDNAME=
for i in $relevantfiles
do
  PUBLISHDATE=`git log --branches=[p]ublish --reverse --pretty=format:%as -n 1 $i`
  EDITDATE=`git log --branches=[p]ublish --pretty=format:%as -n 1 $i`
  #echo $i $DATE
  DATEDNAME="${DATEDNAME}
$PUBLISHDATE $i"
done
#echo "$DATEDNAME"
export SORTED_NAME=`echo "${DATEDNAME}" | sort -r`
# Now generate index

echo $($codeloc/blog-index-page.sh) > "$realblogout/index.html"

