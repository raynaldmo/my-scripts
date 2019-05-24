#!/usr/bin/env bash
# Fix gh-md-toc to properly generate Table of Contents (TOC) for my GitHub Wiki pages
# See https://github.com/ekalinin/github-markdown-toc for information on gh-md-toc script

SED=/usr/bin/sed

usage () {
  echo "Usage:   gh-md-toc-fixed.sh <github wiki page url>"
  echo "Example: gh-md-toc-fixed.sh https://github.com/raynaldmo/HOWTO/wiki/HOWTO.css"
  exit 1
}

if [ $# -ne 1 ]
then
  usage
fi

# This version strips leading whitespace from each line and adds two spaces
# to end of each line. Two spaces need to be added to end of each line otherwise 
# TOC won't render correctly.
# Don't use this version though because we want TOC entries to be indented
# $HOME/bin/gh-md-toc $1 | SED -e 's/^[ \t]*//' | SED -e 's/$/  /'

# Use this version instead
$HOME/bin/gh-md-toc $1 | SED -e 's/$/  /'


