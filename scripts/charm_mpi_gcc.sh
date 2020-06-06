#!/bin/bash
# Author: Shih, Yu-Ting
# Date: 2020/06/05 Fri.
# Desc: build Charm++ v6.10.1 MPI executables with HPC-X OpenMPI and GCC 8.4.0

CODE_NAME=charm
GIT_TAG=v6.10.1
GIT_DIR=${WORK_DIR}/${CODE_NAME}.git
CHARM_DIR=${WORK_DIR}/${CODE_NAME}-${GIT_TAG}
HPCX_DIR=${WORK_DIR}/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-ubuntu16.04-x86_64
GCC=/usr/local/gcc-8.4.0/bin/gcc
NATIVE_GCC_FLAGS="-march=native -mtune=native -mavx2 -msse4.2 -O3 -DNDEBUG"
GCC_FLAGS="-static-libstdc++ -static-libgcc -march=broadwell -mtune=broadwell -mavx2 -msse4.2 -O3 -DNDEBUG"

function clone() {
	git clone --bare ${CHARM_URL} ${GIT_DIR}
	mkdir -p ${WORK_DIR} ${CHARM_DIR}
	git --bare --git-dir=${GIT_DIR} fetch --all --prune
	git --bare --git-dir=${GIT_DIR} --work-tree=${WORK_DIR} reset --mixed ${GIT_TAG} --
	git --bare --git-dir=${GIT_DIR} --work-tree=${CHARM_DIR} clean -fxdn
	git --bare --git-dir=${GIT_DIR} --work-tree=${WORK_DIR} checkout-index --force --all --prefix=${CHARM_DIR}/
}

function clean() {
	rm -fr ${CHARM_DIR}/built && mkdir -p ${CHARM_DIR}/built
}

function prepare() {
	MODULE_DIR=/root/modules
	mkdir -p ${MODULE_DIR}/gcc
	echo "#%Module" > ${MODULE_DIR}/gcc/8.4.0
	echo "prepend-path	PATH /usr/local/gcc-8.4.0/bin" >> ${MODULE_DIR}/gcc/8.4.0
	source /etc/profile.d/modules.sh
	module use ${MODULE_DIR} ${HPCX_DIR}/modulefiles
}

function build() {
	CHARM_BASE=${CHARM_DIR}/built
	OPTIONS=-j2 --with-production --basedir=${HPCX_DIR}/ompi gcc gfortran $GCC_FLAGS

	module purge && module load gcc/8.4.0 hpcx-mt-ompi
	mkdir -p ${CHARM_BASE} && cd ${CHARM_BASE}
	${CHARM_DIR}/build charm++ mpi-linux-x86_64 ${OPTIONS}
	module purge
}

prepare
clone && time build