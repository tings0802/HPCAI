#!/bin/bash
# Author: Yuting Shih
# Date: 2020/06/06 Sat.
# Desc: build NAMD with Charm++ HPC-X OpenMPI + GCC 8.4.0 + FFTW 3.3.8

CHARM_ARCH=mpi-linux-x86_64-gfortran-gcc
CHARM_ARCH=mpi-linux-x86_64
CHARM_BASE=${WORK_DIR}/charm-v6.10.1/built
FFTW3_DIR=${WORK_DIR}/fftw-3.3.8/build-3.3.8-shared-gcc840-avx2-broadwell
HPCX_DIR=${WORK_DIR}/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-ubuntu16.04-x86_64

# compiler
GCC_DIR=/usr/local/gcc-8.4.0
GCC='"$GCC_DIR/bin/gcc "'
GXX='"$GCC_DIR/bin/g++ -std=c++0x"'
NATIVE_GCC_FLAGS='"-static-libstdc++ -static-libgcc -march=native -mtune=native -mavx2 -msse4.2 -O3 -DNDEBUG"'
GCC_FLAGS='"-static-libstdc++ -static-libgcc -march=broadwell -mtune=broadwell -mavx2 -msse4.2 -O3 -DNDEBUG"'

# NAMD
NAMD_URL=https://charm.cs.illinois.edu/gerrit/namd.git
CODE_NAME=namd
GIT_TAG=FETCH_HEAD
GIT_DIR=${WORK_DIR}/${CODE_NAME}.git
NAMD_DIR=${WORK_DIR}/${CODE_NAME}-${GIT_TAG}

function clone() {
	git clone --bare ${NAMD_URL} ${GIT_DIR}
	mkdir -p ${NAMD_DIR}
	git --bare --git-dir=${GIT_DIR} fetch --all --prune
	git --bare --git-dir=${GIT_DIR} --work-tree=${WORK_DIR} reset --mixed ${GIT_TAG}
	git --bare --git-dir=${GIT_DIR} --work-tree=${NAMD_DIR} clean -fxdn
	git --bare --git-dir=${GIT_DIR} --work-tree=${WORK_DIR} checkout-index --force --all --prefix=${NAMD_DIR}/
}

function build() {
	cd ${NAMD_DIR}
	module use ${HPCX_DIR}/modulefiles
	module purge && module load gcc/8.4.0 hpcx-mt-ompi
	./config Linux-x86_64-g++ --with-memopt --charm-base ${CHARM_BASE} --charm-arch ${CHARM_ARCH} \
	--with-fftw3 --fftw-prefix ${FFTW3_DIR} --cc ${GCC} --cc-opts ${GCC_FLAGS} --cxx ${GXX} --cxx-opts ${GCC_FLAGS}
	cd Linux-x86_64-g++ && make -j $(nproc)
	cd ${NAMD_DIR} && mv Linux-x86_64-g++ Linux-x86_64-g++-mpi-fftw3
	module purge
}

clone && time build