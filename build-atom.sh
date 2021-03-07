#!/bin/bash

set -e
LATESTUPDATE=`echo "$SORTED_NAME" | head -n 1 | awk {'print $1'}`
ENTRIES=
JUST_NAMES=`echo "$SORTED_NAME" | awk {'print $2'}`
for i in $JUST_NAMES
do
  EDITDATE=`git log --branches=[p]ublish --pretty=format:%aI -n 1 -- $i`
  ENTRIES+=$(. $realbloglocation/$i;
  cat <<END
  <entry>
    <title>$TITLE</title>
    <link href="https://flaviusb.net/blog/posts/${CANONICAL}.html"/>
    <id>https://flaviusb.net/blog/posts/${CANONICAL}.html</id>
    <updated>$EDITDATE</updated>
  </entry>
END
)
done
cat <<END
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>@flaviusb's blog posts</title>
  <link href="https://flaviusb.net/blog/"/>
  <link href="https://flaviusb.net/blog/atom.xml" rel="self"/>
  <updated>$LATESTUPDATE</updated>
  <author>
    <name>Justin (@flaviusb) Marsh</name>
  </author>
  <id>https://flaviusb.net/</id>
$ENTRIES
</feed>
END
