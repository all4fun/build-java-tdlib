#!/bin/bash
# author: wh
# date: 2025-11-11
# docs: https://tdlib.github.io/td/build.html?language=Java

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install make git zlib1g-dev libssl-dev gperf php-cli cmake default-jdk g++ -y
git clone --branch master https://github.com/tdlib/td.git
cd td
php SplitSource.php
rm -rf build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=../example/java/td -DTD_ENABLE_JNI=ON ..
cmake --build . --target install
cd ..
cd example/java
rm -rf build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=../../../tdlib -DTd_DIR:PATH=$(readlink -e ../td/lib/cmake/Td) ..
cmake --build . --target install
cd ../../..
php SplitSource.php --undo
cd ..
ls -l td/tdlib
