#!/bin/bash
# author: wh
# date: 2025-11-11
# docs: https://tdlib.github.io/td/build.html?language=Java

# xcode-select --install
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gperf cmake openssl coreutils
brew install openjdk
git clone https://github.com/tdlib/td.git
cd td
rm -rf build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DJAVA_HOME=/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/ -DOPENSSL_ROOT_DIR=/opt/homebrew/opt/openssl/ -DCMAKE_INSTALL_PREFIX:PATH=../example/java/td -DTD_ENABLE_JNI=ON ..
cmake --build . --target install
cd ..
cd example/java
rm -rf build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DJAVA_HOME=/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/ -DCMAKE_INSTALL_PREFIX:PATH=../../../tdlib -DTd_DIR:PATH=$(greadlink -e ../td/lib/cmake/Td) ..
cmake --build . --target install
cd ../../..
cd ..
ls -l td/tdlib