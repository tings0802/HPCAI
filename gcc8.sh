#!/bin/bash
# Author: Shih, Yu-Ting
# Date: 2020/05/27 Wed.
# Desc: Install GCC 8.4.0 from source codes

GCC_URL=https://bigsearcher.com/mirrors/gcc/releases/gcc-8.4.0/gcc-8.4.0.tar.gz
APP_NAME=gcc-8.4.0
ROOT_DIR=${HOME}
SOURCE_DIR=${ROOT_DIR}/${APP_NAME}
BUILD_DIR=${ROOT_DIR}/${APP_NAME}-build
TAR_FILE=${ROOT_DIR}/${APP_NAME}.tar.gz

mkdir -p ${ROOT_DIR} ${SOURCE_DIR} ${BUILD_DIR}

# get sources
wget ${GCC_URL} -O ${TAR_FILE}
tar -xaf ${TAR_FILE} -C ${ROOT_DIR}
# wget ${GCC_URL} -O - | tar -xzC ${ROOT_DIR}

# install prerequisites
unset LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUDE
cd ${SOURCE_DIR} && ./contrib/download_prerequisites

# configure & compile
cd ${BUILD_DIR}
${SOURCE_DIR}/configure --prefix=/usr/local/${APP_NAME} --enable-threads=posix --disable-checking --disable-multilib
make -j $(nproc)
make install -j $(nproc)

# set environment path
export PATH=${PATH}:${INSTALL_DIR}/bin