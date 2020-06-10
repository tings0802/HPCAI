#!/bin/bash
# Author: Yuting Shih
# Create: 2020-06-10 Wed.
# Desc: install OpenMPI of serveral versions

function install() {
	MAJOR=${1}
	MINOR=${2}
	MICRO=${3}
	TOPDIR=/root

	CODE_NAME=openmpi-${MAJOR}.${MINOR}.${MICRO}
	URL=https://download.open-mpi.org/release/open-mpi/v${MAJOR}.${MINOR}/${CODE_NAME}.tar.gz
	BUILD_DIR=${TOPDIR}/${CODE_NAME}-build
	APP_DIR=${TOPDIR}/${CODE_NAME}

	wget ${URL} -O - | tar -zxC ${TOPDIR}
	mv ${TOPDIR}/${CODE_NAME} ${BUILD_DIR}
	cd ${BUILD_DIR}
	./configure --prefix=${APP_DIR}
	make -j $(nproc)
	make install -j $(nproc)
	cd ${TOPDIR}
}

module purge
install 4 0 3
install 3 1 6
install 3 0 6