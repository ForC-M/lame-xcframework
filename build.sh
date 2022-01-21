#!/usr/bin/env zsh
set -e

# for m1
ARCH="arm64 arm64 x86_64 armv7 armv7s"
SOURCE_PATH=`pwd`/xcframework
arm64_iphone=0

for arch in $ARCH 
do
    if [ "$arch" == "x86_64" ];then
		PLATFORM="iphonesimulator"
		SIMULATOR="-mios-simulator-version-min=7.0"
        HOST=x86_64-apple-darwin
	elif [ "$arch" == "arm64" ];then
        HOST=arm-apple-darwin
        SIMULATOR="-miphoneos-version-min=7.0"
        if [ $arm64_iphone == 0 ];then
            PLATFORM="iphoneos"
            arm64_iphone=1
        else
            PLATFORM="iphonesimulator"
        fi
    else 
       HOST=arm-apple-darwin
       SIMULATOR="-miphoneos-version-min=7.0"
       PLATFORM="iphoneos"
	fi
    ./configure \
    --disable-shared \
    --disable-frontend \
    --host=$HOST \
    --prefix="$SOURCE_PATH/$PLATFORM/$arch" \
    CC="xcrun -sdk $PLATFORM clang -arch $arch" \
    CFLAGS="-fembed-bitcode-marker $SIMULATOR" \
    LDFLAGs="-fembed-bitcode-marker $SIMULATOR"
    make clean
    make -j8
    make install
done




