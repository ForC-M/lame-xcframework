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
        if [ $arm64_iphone == 0 ];then
            PLATFORM="iphoneos"
            SIMULATOR="-miphoneos-version-min=7.0"
            arm64_iphone=1
        else
            PLATFORM="iphonesimulator"
            SIMULATOR="-mios-simulator-version-min=7.0"
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
    CFLAGS="-fembed-bitcode $SIMULATOR" \
    LDFLAGs="-fembed-bitcode $SIMULATOR"
    make clean
    make -j8
    make install
done

lipo -create `find xcframework/iphoneos -name *.a` -output xcframework/iphoneos/lame
lipo -create `find xcframework/iphonesimulator -name *.a` -output xcframework/iphonesimulator/lame

mkdir -p xcframework/iphoneos/lame.framework/Headers
mkdir -p xcframework/iphonesimulator/lame.framework/Headers

cp xcframework/iphoneos/lame xcframework/iphoneos/lame.framework
cp xcframework/iphonesimulator/lame xcframework/iphonesimulator/lame.framework
cp xcframework/iphoneos/arm64/include/lame/*.h xcframework/iphoneos/lame.framework/Headers
cp xcframework/iphonesimulator/x86_64/include/lame/*.h xcframework/iphonesimulator/lame.framework/Headers

xcodebuild -create-xcframework -framework xcframework/iphonesimulator/lame.framework -framework xcframework/iphoneos/lame.framework -output xcframework/lame.xcframework

rm -r xcframework/iphoneos
rm -r xcframework/iphonesimulator