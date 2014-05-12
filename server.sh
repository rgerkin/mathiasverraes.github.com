#!/bin/sh
echo .
echo "http://localhost:4000"
echo .
echo "Don't forget to update regularly:"
echo "bundle install"
echo .

#jekyll serve --watch

bundle exec jekyll serve --watch
