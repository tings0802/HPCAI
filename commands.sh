#!/bin/bash
# Author: Shih, Yu-Ting
# Date: 2020/05/22 Fri.
# Desc: To build FFTW shared library for NAMD

mkdir -p ${SOURCE_DIR} && wget ${FFTW_URL} -O ${FFTW_SOURCE}
tar -xf ${FFTW_SOURCE} -C ${SOURCE_DIR}

mkdir -p ${SOURCE_DIR} && wget ${FFTW_URL} -O - | tar -xzC ${SOURCE_DIR}
cd fftw-3.3.8
vim install.sh

chmod +x install.sh
module load intel/2019.10.24
sudo ./install.sh