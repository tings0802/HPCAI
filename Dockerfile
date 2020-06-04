# Author: Shih, Yu-Ting
# Date: 2020/06/04 Thu.
# Desc: build NAMD on Untuntu 16.04

FROM ubuntu:16.04

# install packages
RUN apt update && apt install -y \
	vim tmux locate environment-modules tcl python3 \
	git wget curl ssh net-tools \
	gcc g++ gfortran make cmake autoconf automake

WORKDIR /root
SHELL ["/bin/bash", "-c"]

ENV CHARM_URL=https://github.com/UIUC-PPL/charm.git \
	NAMD_URL=https://charm.cs.illinois.edu/gerrit/namd.git \
	FFTW_URL=http://www.fftw.org/fftw-3.3.8.tar.gz \
	HPCX_URL=http://content.mellanox.com/hpc/hpc-x/v2.6/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-ubuntu16.04-x86_64.tbz

ENV WORK_DIR=/root \
	SCRIPT_DIR=${WORK_DIR}/scripts \
	MODULE_DIR=${WORK_DIR}/modulefiles
RUN mkdir -p ${WORK_DIR} ${SCRIPT_DIR} ${MODULE_DIR}

# root ssh permision
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# GCC 8.4.0
ARG SCRIPT=gcc8.sh
COPY ${SCRIPT} ${SCRIPT_DIR}
RUN source ${SCRIPT_DIR}/${SCRIPT}

# FFTW 3.3.8
ARG SCRIPT=fftw_gcc.sh
COPY ${SCRIPT} ${SCRIPT_DIR}
RUN source ${SCRIPT_DIR}/${SCRIPT}

# HPC-X 2.6
RUN wget ${HPCX_URL} -O - | tar -xjC ${SCRIPT_DIR}

# Environment Modules
ARG HOST_MODULE_DIR=modulefiles
COPY ${HOST_MODULE_DIR} ${MODULE_DIR}
CMD source /etc/profile.d/modules.sh && module use ${MODULE_DIR} && bash

# Charm++ 6.10.1
ARG SCRIPT=charm_mpi_gcc.sh
COPY ${SCRIPT} ${SCRIPT_DIR}
# RUN source ${SCRIPT_DIR}/${SCRIPT}