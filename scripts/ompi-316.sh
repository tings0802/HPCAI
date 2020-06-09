#!/bin/bash
# Author: Yuting Shih
# Create: 2020/06/09 Tue.
# Desc: install OpenMPI 3.1.6

MAJOR=3
MINOR=1
MICRO=6
WORK_DIR=/root

CODE_NAME=openmpi-${MAJOR}.${MINOR}.${MICRO}
CODE_URL=https://download.open-mpi.org/release/open-mpi/v${MAJOR}.${MINOR}/${CODE_NAME}.tar.gz
BUILD_DIR=${WORK_DIR}/${CODE_NAME}-build
APP_DIR=${WORK_DIR}/${CODE_NAME}

wget ${CODE_URL} -O - | tar -xzC ${WORK_DIR}
mv ${CODE_NAME} ${BUILD_DIR}
cd ${BUILD_DIR}
./configure --prefix=${APP_DIR}
make -j $(nproc)
make install -j $(nproc)