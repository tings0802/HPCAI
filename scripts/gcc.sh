#!/bin/bash
# Author: Yuting Shih
# Date: 2020-06-10 Wed.
# Desc: Install GCC from source codes

function download() {
	MAJOR=${1}
	MINOR=${2}
	MICRO=${3}
	TOPDIR=/root

	APP_NAME=gcc-${MAJOR}.${MINOR}.${MICRO}
	GCC_URL=https://bigsearcher.com/mirrors/gcc/releases/${APP_NAME}/${APP_NAME}.tar.gz
	SOURCE_DIR=${TOPDIR}/${APP_NAME}
	BUILD_DIR=${TOPDIR}/${APP_NAME}-build

	mkdir -p ${TOPDIR} ${SOURCE_DIR} ${BUILD_DIR}
	wget ${GCC_URL} -O - | tar -xzC ${TOPDIR}
}

function install() {
	MAJOR=${1}
	MINOR=${2}
	MICRO=${3}
	TOPDIR=/root

	APP_NAME=gcc-${MAJOR}.${MINOR}.${MICRO}
	SOURCE_DIR=${TOPDIR}/${APP_NAME}
	BUILD_DIR=${TOPDIR}/${APP_NAME}-build
	
	mkdir -p ${TOPDIR} ${SOURCE_DIR} ${BUILD_DIR}
	unset LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUDE
	
	# install prerequisites
	cd ${SOURCE_DIR} && ./contrib/download_prerequisites

	# configure & compile
	cd ${BUILD_DIR}
	${SOURCE_DIR}/configure --prefix=/usr/local/${APP_NAME} --enable-threads=posix --disable-checking --disable-multilib
	make -j $(nproc)
	make install -j $(nproc)
}

module purge

# download 8 4 0
# download 7 5 0
# download 6 5 0

install 8 4 0
# install 7 5 0
# install 6 5 0