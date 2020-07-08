#!/bin/bash
# Author: Yuting Shih
# Date: 2020-06-10 Wed.
# Desc: install Intel MPI

function install() {
	TOPDIR=/root
	CODE_NAME=parallel_studio_xe_2020_cluster_edition
	APP_DIR=${TOPDIR}/${CODE_NAME}
	TAR_FILE=${SOURCE_DIR}/${CODE_NAME}.tgz
	INTEL_SN=${SOURCE_DIR}/intel_sn

	tar -zxf ${TAR_FILE} -C ${TOPDIR}
	cd ${APP_DIR}
	sed -ine 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/' silent.cfg
	sed -ine 's/ARCH_SELECTED=ALL/ARCH_SELECTED=INTEL64/' silent.cfg
	sed -inre "s/\#ACTIVATION_SERIAL_NUMBER=snpat/ACTIVATION_SERIAL_NUMBER=$(cat ${INTEL_SN})/" silent.cfg
	sed -ine 's/ACTIVATION_TYPE=exist_lic/ACTIVATION_TYPE=serial_number/' silent.cfg
	./install.sh --silent silent.cfg
	rm ${INTEL_SN}
	cd ${TOPDIR}
}

install