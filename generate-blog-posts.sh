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
  PUBLISHDATE=`git log --branches=[p]ublish --pretty=format:%as -- $i | tail -n 1`
  EDITDATE=`git log --branches=[p]ublish --pretty=format:%as -n 1 -- $i`
  echo $(. $i; export PUBLISHDATE="$PUBLISHDATE"; export EDITDATE="$EDITDATE"; . $codeloc/date-section.sh; $codeloc/blog-post-container.sh) > $location
  # Now we do all the past versions for the page
  HASHES=`git log --branches=[p]ublish --pretty=format:%H --skip 1 -- $i`
  if [ -n "$HASHES" ]
  then
    for h in $HASHES
    do
      mkdir -p "$realblogout/$(. $i; echo $CANONICAL)/"
      location="$realblogout/$(. $i; echo $CANONICAL)/${h}.html"
      PUBLISHDATE=`git log --branches=[p]ublish --pretty=format:%as -- $i | tail -n 1`
      EDITDATE=`git log --pretty=format:%as -n 1 $h` # ← --branch interacts in a way that does not make sense to me with using a commit sha
      echo $(source <(git cat-file --textconv ${HASHES}:${i}); export PUBLISHDATE="$PUBLISHDATE"; export EDITDATE="$EDITDATE"; . $codeloc/date-past-version.sh; $codeloc/blog-post-container.sh) > $location
    done
  fi
done

DATEDNAME=
for i in $relevantfiles
do
  PUBLISHDATE=`git log --branches=[p]ublish --pretty=format:%as -- $i | tail -n 1`
  EDITDATE=`git log --branches=[p]ublish --pretty=format:%as -n 1 -- $i`
  #echo $i $DATE
  DATEDNAME="${DATEDNAME}
$PUBLISHDATE $i"
done
#echo "$DATEDNAME"
export SORTED_NAME=`echo "${DATEDNAME}" | sort -r`
# Now generate index

echo $($codeloc/blog-index-page.sh) > "$realblogout/index.html"

