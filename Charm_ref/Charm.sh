#!/bin/bash
# Charm++ v6.10.1 benchmark guideline

CODE_NAME=charm \
CODE_GIT_TAG=FETCH_HEAD \
CODE_GIT_TAG=v6.10.1 \
GIT_DIR=$HOME/github/$CODE_NAME.git \
GIT_WORK_TREE=$HOME/cluster/thor/code \
CHARM_CODE_DIR=$GIT_WORK_TREE/$CODE_NAME-$CODE_GIT_TAG-$(date +%y-%m-%d) \
CHARM_DIR=$CHARM_CODE_DIR \ APP_MPI_PATH=$HOME/cluster/thor/application/mpi \
HPCX_FILES_DIR=$APP_MPI_PATH/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64 \
HPCX_MPI_DIR=$HPCX_FILES_DIR/ompi \ HPCX_UCX_DIR=$HPCX_FILES_DIR/ucx \ UCX_DIR=$SELF_BUILT_DIR \
UCX_DIR=$HPCX_UCX_DIR \ GCC_DIR=/global/software/centos-7/modules/langs/gcc/8.4.0/bin \
NATIVE_GCC_FLAGS="-march=native -mtune=native -mavx2 -msse4.2 -O3 -DNDEBUG" \
GCC_FLAGS="-static-libstdc++ -static-libgcc -march=broadwell -mtune=broadwell -mavx2 -msse4.2 -O3 -DNDEBUG" \
ICC_FLAGS="-static-intel -xBROADWELL -axBROADWELL,CORE-AVX2,SSE4.2 -O3 -DNDEBUG" \ PSXE_DIR=/global/software/centos-7/modules/langs/intel/2020.1.217 \
INTEL_LICENSE_FILE+=:27009@192.168.0.1 \ INTEL_COMPILER_DIR=$PSXE_DIR/compilers_and_libraries_2020.1.217/linux/bin \


CMD_REBUILD_BUILD_DIR="rm -fr $CHARM_DIR/built && mkdir $CHARM_DIR/built;"

### To build UCX executables with HPC-X OpenMPI + GCC8.4.0
CMD_BUILD_UCX_CHARM_GCC=" module purge && module load gcc/8.4.0 \
&& cd $CHARM_DIR/built \
&& time -p ../build charm++ ucx-linux-x86_64 ompipmix \
-j --with-production \
--basedir=$HPCX_MPI_DIR \
--basedir=$UCX_DIR \
gcc gfortran $GCC_FLAGS \
&& module purge;"

### To build MPI executables with HPC-X OpenMPI + GCC8.4.0
CMD_BUILD_MPI_CHARM_GCC=" module purge && module load gcc/8.4.0 \
&& . $HPCX_FILES_DIR/hpcx-mt-init-ompi.sh \
&& hpcx_load \ && cd $CHARM_DIR/built \
&& time -p ../build charm++ mpi-linux-x86_64 \
-j --with-production \
--basedir=$HPCX_MPI_DIR \
gcc gfortran $GCC_FLAGS \
&& hpcx_unload && module purge;"

### To build UCX executables with HPC-X OpenMPI + ICC20u1
CMD_BUILD_UCX_CHARM_ICC=" . $INTEL_COMPILER_DIR/compilervars.sh -arch intel64 -platform linux \
&& cd $CHARM_DIR/built \
&& time -p ../build charm++ ucx-linux-x86_64 ompipmix \
-j --with-production \
--basedir=$HPCX_MPI_DIR \
--basedir=$UCX_DIR \
icc ifort $ICC_FLAGS;"

### To build MPI executables with HPC-X OpenMPI + ICC20u1
CMD_BUILD_MPI_CHARM_ICC=" . $INTEL_COMPILER_DIR/compilervars.sh -arch intel64 -platform linux \
&& . $HPCX_FILES_DIR/hpcx-mt-init-ompi.sh \
&& hpcx_load \
&& cd $CHARM_DIR/built \
&& time -p ../build charm++ mpi-linux-x86_64 \
-j --with-production \
--basedir=$HPCX_MPI_DIR \
icc ifort $ICC_FLAGS \
&& hpcx_unload;"

eval $CMD_REBUILD_BUILD_DIR;
eval $CMD_BUILD_UCX_CHARM_GCC &
eval $CMD_BUILD_MPI_CHARM_GCC &
eval $CMD_BUILD_UCX_CHARM_ICC &
eval $CMD_BUILD_MPI_CHARM_ICC &
wait
echo $CMD_REBUILD_BUILD_DIR;
echo $CMD_BUILD_UCX_CHARM_GCC;
echo $CMD_BUILD_MPI_CHARM_GCC;
echo $CMD_BUILD_UCX_CHARM_ICC;
echo $CMD_BUILD_MPI_CHARM_ICC;