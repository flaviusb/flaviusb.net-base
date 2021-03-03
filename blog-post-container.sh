#!/bin/bash

cat <<END
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>$TITLE</title>
  </head>
  <body>
<h1>$TITLE</h1>
$TEXT
<p><a href="https://flaviusb.net/">Home</a>  |  <a href="https://flaviusb.net/blog/">Blog</a>  |  <a href="https://github.com/flaviusb">Code</a></p>
  </body>
</html>
END
