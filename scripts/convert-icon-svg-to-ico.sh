#!/bin/bash

convert static/logo/geek-logo.svg -resize 16x16 static/logo/favicon-16x16.png
convert static/logo/geek-logo.svg -resize 32x32 static/logo/favicon-32x32.png
convert static/logo/geek-logo.svg -resize 64x64 static/logo/favicon-64x64.png

convert \
    static/logo/favicon-16x16.png \
    static/logo/favicon-32x32.png \
    static/logo/favicon-64x64.png \
    static/favicon.ico

rm -f \
    static/logo/favicon-16x16.png \
    static/logo/favicon-32x32.png \
    static/logo/favicon-64x64.png
