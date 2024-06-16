#!/bin/bash

# flutter pub run pigeon --input pigeons/bottom_container.dart

# download sdk
VERSION=0.0.1
# iOS
IOS_FRAMEWORK_PATH=ios/Frameworks
IOS_ZIP=ios_${VERSION}.zip
IOS_ZIP_PATH=$IOS_FRAMEWORK_PATH/$IOS_ZIP
rm -rf $IOS_FRAMEWORK_PATH
mkdir -p $IOS_FRAMEWORK_PATH
curl -L -o $IOS_ZIP_PATH "https://github.com/LinXunFeng/flutter_chat_packages_pub/releases/download/chat_bottom_container/${IOS_ZIP}"
unzip $IOS_ZIP_PATH -d $IOS_FRAMEWORK_PATH
rm $IOS_ZIP_PATH
# Android
