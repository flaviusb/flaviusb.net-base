#!/bin/bash

set -e

export realbloglocation=`readlink -f $bloglocation`
export realblogout=`readlink -f $blogout`
export realbaseout=`readlink -f $baseout`
#invokedfrom=`pwd`
codeloc_temp=`readlink -f ${BASH_SOURCE[0]}`
export codeloc=`dirname $codeloc_temp`
#echo $codeloc

mkdir -p $realblogout/posts
mkdir -p $realblogout/tags
cd $realbloglocation

relevantfiles=`git ls-files *.sh`
#echo $relevantfiles
for i in $relevantfiles
do
  location="$realblogout/posts/$(. $i; echo $CANONICAL).html"
  PUBLISHDATE=`git log --branches=[p]ublish --pretty=format:%as -- $i | tail -n 1`
  EDITDATE=`git log --branches=[p]ublish --pretty=format:%as -n 1 -- $i`
  echo $(. $i; export PUBLISHDATE="$PUBLISHDATE"; export EDITDATE="$EDITDATE"; . $codeloc/date-section.sh; $codeloc/blog-post-container.sh) > $location
  # Now we do all the past versions for the page
  HASHES=`git log --branches=[p]ublish --pretty=format:%H --skip 1 -- $i`
  if [ -n "$HASHES" ]
  then
    for h in $HASHES
    do
      mkdir -p "$realblogout/posts/$(. $i; echo $CANONICAL)/"
      location="$realblogout/posts/$(. $i; echo $CANONICAL)/${h}.html"
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

BY="All posts by publication date"

echo $(export BY=$BY; $codeloc/blog-index-page.sh) > "$realblogout/index.html"

# Now generate tag index pages

declare -A tags

for i in $relevantfiles
do
  TAG=$(. $i; echo $TAGS)
  PUBLISHDATE=`git log --branches=[p]ublish --pretty=format:%as -- $i | tail -n 1`
  for atag in $TAG
  do
    tags[${atag}]="${tags[${atag}]}
$PUBLISHDATE $i"
  done
done
for i in ${!tags[@]}
do
  BY="All posts tagged '$i' by publication date"
  SORTED_NAME=`echo "${tags[$i]}" | sort -r`
  #echo "$i: ${tags[$i]}"
  mkdir -p "$realblogout/tags/$i/"
  echo $(export BY=$BY; $codeloc/blog-index-page.sh) > "$realblogout/tags/$i/index.html"
done

# Copy files over

cp "$codeloc/files/syntax.css"  "$realbaseout/syntax.css"
cp "$codeloc/files/favicon.png" "$realbaseout/favicon.png"
