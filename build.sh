#!/bin/zsh
set -e

# for m1
ARCH="arm64 arm64 x86_64 armv7 armv7s i386"
SOURCE_PATH=`pwd`/xcframework

arm64_iphone=0
for arch in $ARCH 
do
    if [ "$arch" = "i386" -o "$arch" = "x86_64" ]
    then
		PLATFORM="iphonesimulator"
		if [ "$arch" = "x86_64" ]
		then
		    SIMULATOR="-mios-simulator-version-min=7.0"
            HOST=x86_64-apple-darwin
		else
		    SIMULATOR="-mios-simulator-version-min=5.0"
            HOST=i386-apple-darwin
		fi
	elif [ "$arch" = "arm64" ]
        HOST=arm-apple-darwin
        SIMULATOR="-miphoneos-version-min=7.0"
        if [ $arm64_iphone == 0 ]
        then
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
    --disable-shared --disable-frontend \
    --host=$HOST \
    --prefix="$SOURCE_PATH" \
    CC="xcrun -sdk $PLATFORM clang -arch $arch" \
    CFLAGS="-arch $arch -fembed-bitcode $SIMULATOR" \
    LDFLAGs="-arch $arch -fembed-bitcode $SIMULATOR"
    make clean
    make -j8
    make install
fi




