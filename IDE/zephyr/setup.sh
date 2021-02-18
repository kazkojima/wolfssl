#!/bin/sh

# Check for zephyr directory on command line
if [ $# -ne 1 ]; then
    echo "Usage: $0 'zephyr project root directory path'" 1>&2
    exit 1
fi
ZEPHYR_DIR=$1

# Check zephyr directory exists
if [ ! -d $ZEPHR_DIR ]; then
    echo "Zephyr project directory does not exist: $ZEPHYR_DIR"
    exit 1
fi

# Create wolfssl sample directory if not exists yet
ZEPHYR_WOLFSSL_SAMPLE_DIR=$ZEPHYR_DIR/zephyr/samples/wolfssl
if [ ! -d $ZEPHYR_WOLFSSL_SAMPLE_DIR ]; then
   echo "Create wolfssl sample directory"
   mkdir $ZEPHYR_WOLFSSL_SAMPLE_DIR
fi

cd `dirname $0`


(cd lib; ./install_lib.sh $ZEPHYR_DIR)
(cd wolfssl_test; ./install_test.sh $ZEPHYR_DIR)
(cd wolfssl_tls_sock; ./install_sample.sh $ZEPHYR_DIR)
(cd wolfssl_tls_thread; ./install_sample.sh $ZEPHYR_DIR)

# Apply patch to add wolfssl as a module of zephyr
if [ -d $ZEPHYR_DIR/zephyr ]; then
    if grep -q wolfssl $ZEPHYR_DIR/zephyr/modules/Kconfig; then
	echo "zephyr tree is patched already"
	exit 1
    else
	echo "Add wolfssl to zephyr as a module"
	cat patches/zephyr-add-wolfssl-module.patch | patch -p1 -d $ZEPHYR_DIR/zephyr
    fi
fi
