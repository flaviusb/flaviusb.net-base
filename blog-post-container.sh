#!/bin/bash

cat <<END
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>$TITLE</title>
    <link rel="stylesheet" type="text/css" href="https://flaviusb.net/syntax.css"/>
    <link href='https://fonts.googleapis.com/css?family=Inconsolata' rel='stylesheet' type='text/css'/>
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon"/>
    <link rel="icon" href="https://flaviusb.net/favicon.ico" type="image/x-icon"/>
    <!-- <link href="https://flaviusb.net/atom.xml" type="application/atom+xml" rel="alternate" title="Blog Atom Feed" /> -->
    <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" />
  </head>
  <body class="highlight">
<h1>$TITLE</h1>
$DATETEXT
$TEXT
<p><a href="https://flaviusb.net/">Home</a>  |  <a href="https://flaviusb.net/blog/">Blog</a>  |  <a href="https://github.com/flaviusb">Code</a></p>
  </body>
</html>
END
