#!/bin/bash

set -e

cd $realbloglocation

BY="All posts by publication date"
TEXT=
JUST_NAMES=`echo "$SORTED_NAME" | awk {'print $2'}`
for i in $JUST_NAMES
do
  PUBLISHDATE=`git log --branches=[p]ublish --pretty=format:%as -- $i | tail -n 1`
  TEXT+=$(. $realbloglocation/$i;
  TAGSET=
  for t in $TAGS
  do
    TAGSET+="<a href=\"https://flaviusb.net/blog/tags/$t\">$t</a> "
  done
  VERSIONS=
  HASHES=`git log --branches=[p]ublish --pretty=format:%H --skip 1 -- $i`
  if [ -n "$HASHES" ]
  then
    UPDATED_DATE=`git log --pretty=format:%as -n 1 $i`
    VERSIONS=" <span>Updated on ${UPDATED_DATE}. Older versions: "
    for h in $HASHES
    do
      THIS_DATE=`git log --pretty=format:%as -n 1 $h`
      VERSIONS+=" <a href=\"https://flaviusb.net/blog/posts/${CANONICAL}/${h}.html\">$THIS_DATE</a>"
    done
    VERSIONS+="</span>"
  fi
  cat <<END
<li><span class="date">$PUBLISHDATE</span> » <a href="https://flaviusb.net/blog/posts/${CANONICAL}.html">$TITLE</a>    <span>$TAGSET</span>$VERSIONS</li>
END
)
done
cat <<END
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Post Index: $BY</title>
  </head>
  <body>
<h1>Post Index: $BY</h1>
<ul class="posts">
$TEXT
</ul>
<p><a href="https://flaviusb.net/">Home</a>  |  <a href="https://flaviusb.net/blog/">Blog</a>  |  <a href="https://github.com/flaviusb">Code</a></p>
  </body>
</html>

END
