#!/bin/zsh
# 
set -e

echo "project clear begin"
rm -rf ./lame-source/xcframework
rm -rf ./lame-source/build.sh
rm -rf ./xcframework
cp build.sh ./lame-source

echo "compile start"
# to chdir
cd lame-source && sh build.sh && cd ..
cp -r lame-source/xcframework ./

echo "compile finish"
open xcframework