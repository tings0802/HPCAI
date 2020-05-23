#!/bin/bash
# Author: Shih, Yu-Ting
# Date: 2020/05/23 Sat.
# Desc: build Charm++ v6.10.1 MPI executables with HPC-X OpenMPI and GCC 8.4.0

# Get source codes
CODE_NAME=charm
GIT_DIR=${SOURCE_DIR}/${CODE_NAME}.git
git clone --bare ${CHARM_URL} ${GIT_DIR}

# Checkout Charm++ v6.10.1
GIT_TAG=v6.10.1
WORK_TREE=${SOURCE_DIR}
CODE_DIR=${WORK_TREE}/${CODE_NAME}-${GIT_TAG}
mkdir -p ${WORK_TREE} ${CODE_DIR}
git --bare --git-dir=${GIT_DIR} fetch --all --prune
git --bare --git-dir=${GIT_DIR} --work-tree=${WORK_TREE} reset --mixed ${GIT_TAG} --
git --bare --git-dir=${GIT_DIR} --work-tree=${CODE_DIR} clean -fxdn
git --bare --git-dir=${GIT_DIR} --work-tree=${WORK_TREE} checkout-index --force --all --prefix=${CODE_DIR}/

# Build Charm++ v6.10.1
CHARM_DIR=${CODE_DIR} \
HPCX_DIR=${SOURCE_DIR}/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-ubuntu16.04-x86_64 \
HPCX_MPI_DIR=$HPCX_DIR/ompi \
GCC=/usr/bin/gcc \
NATIVE_GCC_FLAGS="-march=native -mtune=native -mavx2 -msse4.2 -O3 -DNDEBUG" \
GCC_FLAGS="-static-libstdc++ -static-libgcc -march=broadwell -mtune=broadwell -mavx2 -msse4.2 -O3 -DNDEBUG" \

CMD_REBUILD_BUILD_DIR="rm -fr ${CHARM_DIR}/built && mkdir -p ${CHARM_DIR}/built;"
# module purge && module load gcc/8.4.0 &&
CMD_BUILD_MPI_CHARM_GCC=" \
	. $HPCX_DIR/hpcx-mt-init-ompi.sh \
	&& hpcx_load \
	&& mkdir -p ${CHARM_DIR}/built \
	&& cd ${CHARM_DIR}/built \
	&& time -p ../build charm++ mpi-linux-x86_64 \
	-j --with-production \
	--basedir=$HPCX_MPI_DIR \
	gcc gfortran $GCC_FLAGS \
	&& hpcx_unload && module purge;"

eval $CMD_BUILD_MPI_CHARM_GCC
wait
echo $CMD_BUILD_MPI_CHARM_GCC