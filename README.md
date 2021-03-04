# flaviusb.net-base
Static site generator for my personal website

## Installation

Clone this repo and the blog post repo.

Make sure you have discount installed; on gentoo for example via `emerge --ask app-text/discount`.

## Running

Replacing the values of bloglocation, baseout and blogout with the correct values for your system, run:
```shell
bloglocation=../flaviusb.net-blog/ baseout=../flaviusb.net-out/ blogout=../flaviusb.net-out/blog/ ./generate-blog-posts.sh
```
