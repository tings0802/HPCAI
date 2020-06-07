# Author: Yuting Shih
# Date: 2020/06/05 Fri.
# Desc: build NAMD on Untuntu 16.04

FROM ubuntu:16.04
SHELL ["/bin/bash", "-c"]
WORKDIR /root

# install packages
RUN apt update && apt install -y \
	vim tmux locate environment-modules tcl python3 python3-pip \
	git wget curl ssh net-tools \
	gcc g++ gfortran make cmake autoconf automake

ENV	WORK_DIR=/root \
	HPCX_DIR=${WORK_DIR}/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-ubuntu16.04-x86_64 \
	CHARM_URL=https://github.com/UIUC-PPL/charm.git \
	NAMD_URL=https://charm.cs.illinois.edu/gerrit/namd.git \
	FFTW_URL=http://www.fftw.org/fftw-3.3.8.tar.gz \
	HPCX_URL=http://content.mellanox.com/hpc/hpc-x/v2.6/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-ubuntu16.04-x86_64.tbz

ENV SCRIPT_DIR=${WORK_DIR}/scripts \
	MODULE_DIR=${WORK_DIR}/modules \
	HPCX_MODULE=${HPCX_DIR}/modulefiles

RUN mkdir -p ${WORK_DIR} ${SCRIPT_DIR} ${MODULE_DIR}

# root ssh permision
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

COPY scripts ${SCRIPT_DIR}
COPY modules ${MODULE_DIR}

# GCC 8.4.0
RUN source ${SCRIPT_DIR}/gcc8.sh

# FFTW 3.3.8
RUN source ${SCRIPT_DIR}/fftw_gcc.sh

# HPC-X 2.6
RUN wget ${HPCX_URL} -O - | tar -xjC ${WORK_DIR}

# Charm++ 6.10.1
RUN source ${SCRIPT_DIR}/charm_mpi_gcc.sh

# Environment Modules
CMD source /etc/profile.d/modules.sh && module use ${MODULE_DIR} && module use ${HPCX_MODULE} && bash