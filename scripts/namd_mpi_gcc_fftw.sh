CHARM_ARCH_UCX_GCC=ucx-linux-x86_64-gfortran-ompipmix-gcc \
CHARM_ARCH_UCX_ICC=ucx-linux-x86_64-ifort-ompipmix-icc \
CHARM_ARCH_MPI_GCC=mpi-linux-x86_64-gfortran-gcc \
CHARM_ARCH_MPI_ICC=mpi-linux-x86_64-ifort-icc \
CODE_NAME=charm \
CODE_GIT_TAG=FETCH_HEAD \
CODE_GIT_TAG=v6.10.1 \
GIT_WORK_TREE=$HOME/cluster/thor/code \
CHARM_CODE_DIR=$GIT_WORK_TREE/$CODE_NAME-$CODE_GIT_TAG-$(date +%y-%m-%d) \
CHARM_BASE=$CHARM_CODE_DIR/built \
FFTW3_LIB_DIR=$HOME/cluster/thor/application/libs/fftw \
GCC_FFTW3_LIB_DIR=$FFTW3_LIB_DIR/3.3.8-shared-gcc840-avx2-broadwell \
ICC_FFTW3_LIB_DIR=$FFTW3_LIB_DIR/3.3.8-shared-icc20-avx2-broadwell \
APP_MPI_DIR=$HOME/cluster/thor/application/mpi \
HPCX_FILES_DIR=$APP_MPI_DIR/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-4.7-1.0.0.1-redhat7.7-x86_64 \
PSXE_DIR=/global/software/centos-7/modules/langs/intel/2020.1.217 \
INTEL_LICENSE_FILE+=:27009@192.168.0.1 \
INTEL_COMPILER_DIR=$PSXE_DIR/compilers_and_libraries_2020.1.217/linux/bin \
MKL_DIR=$PSXE_DIR/compilers_and_libraries_2020.1.217/linux/mkl \
ICC_DIR=$PSXE_DIR/compilers_and_libraries_2020.1.217 \
ICC_PATH="$INTEL_COMPILER_DIR/intel64/icc" \
ICPC_PATH='"$INTEL_COMPILER_DIR/intel64/icpc -std=c++11"' \
ICC_FLAGS='"-static-intel -xBROADWELL -axBROADWELL,CORE-AVX2,SSE4.2 -O3 -DNDEBUG"' \
GCC_DIR=/global/software/centos-7/modules/langs/gcc/8.4.0 \
GCC_PATH='"$GCC_DIR/bin/gcc "' \
GXX_PATH='"$GCC_DIR/bin/g++ -std=c++0x"' \
NATIVE_GCC_FLAGS='"-static-libstdc++ -static-libgcc -march=native -mtune=native -mavx2 -msse4.2 -O3 -DNDEBUG"' \
GCC_FLAGS='"-static-libstdc++ -static-libgcc -march=broadwell -mtune=broadwell -mavx2 -msse4.2 -O3 -DNDEBUG"' \

CODE_NAME=namd \
CODE_GIT_TAG=FETCH_HEAD \
GIT_DIR=$HOME/github/$CODE_NAME.git \
GIT_WORK_TREE=$HOME/cluster/thor/code \
NAMD_CODE_DIR=$GIT_WORK_TREE/$CODE_NAME-$CODE_GIT_TAG-$(date +%y-%m-%d) \
NAMD_DIR=$NAMD_CODE_DIR \

cd $NAMD_DIR; 
### To build NAMD with Charm++ HPC-X UCX + GCC8.4.0 + FFTW3
CMD_BUILD_UCX_NAMD_GCC_FFTW3=" PATH=$GCC_DIR/bin:$PATH \
module purge && module load gcc/8.4.0 && \
./config Linux-x86_64-g++ --with-memopt \
--charm-base $CHARM_BASE --charm-arch $CHARM_ARCH_UCX_GCC \
--with-fftw3 --fftw-prefix $GCC_FFTW3_LIB_DIR \
--cc $GCC_PATH --cc-opts $GCC_FLAGS \
--cxx $GXX_PATH --cxx-opts $GCC_FLAGS \
&& cd Linux-x86_64-g++ && time -p make -j \
&& cd $NAMD_DIR && mv Linux-x86_64-g++ Linux-x86_64-g++-ucx-fftw3 \
&& module purge"
### To build NAMD with Charm++ HPC-X UCX + GCC8.4.0 + MKL
CMD_BUILD_UCX_NAMD_GCC_MKL=" PATH=$GCC_DIR/bin:$PATH \
module purge && module load gcc/8.4.0 && \
./config Linux-x86_64-g++ --with-memopt --charm-base $CHARM_BASE \
--charm-arch $CHARM_ARCH_UCX_GCC --with-mkl --mkl-prefix $MKL_DIR \
--cc $GCC_PATH --cc-opts $GCC_FLAGS \ --cxx $GXX_PATH --cxx-opts $GCC_FLAGS \
&& cd Linux-x86_64-g++ && time -p make -j \

&& cd $NAMD_DIR && mv Linux-x86_64-g++ Linux-x86_64-g++-ucx-mkl \
&& module purge"

### To build NAMD with Charm++ HPC-X OpenMPI + GCC8.4.0 + FFTW3
CMD_BUILD_MPI_NAMD_GCC_FFTW3=" module purge && module load gcc/8.4.0 && \
. $HPCX_FILES_DIR/hpcx-mt-init-ompi.sh && hpcx_load \
&& PATH=$GCC_DIR/bin:$PATH \
./config Linux-x86_64-g++ --with-memopt \
--charm-base $CHARM_BASE --charm-arch $CHARM_ARCH_MPI_GCC \
--with-fftw3 --fftw-prefix $GCC_FFTW3_LIB_DIR --cc $GCC_PATH --cc-opts $GCC_FLAGS 
--cxx $GXX_PATH --cxx-opts $GCC_FLAGS \ && cd Linux-x86_64-g++ && time -p make -j \
&& cd $NAMD_DIR && mv Linux-x86_64-g++ Linux-x86_64-g++-mpi-fftw3 \
&& hpcx_unload && module purge"

### To build NAMD with Charm++ HPC-X OpenMPI + GCC8.4.0 + MKL
CMD_BUILD_MPI_NAMD_GCC_MKL=" module purge && module load gcc/8.4.0 && \
. $HPCX_FILES_DIR/hpcx-mt-init-ompi.sh && hpcx_load \
&& PATH=$GCC_DIR/bin:$PATH \ ./config Linux-x86_64-g++ --with-memopt \
--charm-base $CHARM_BASE --charm-arch $CHARM_ARCH_MPI_GCC --with-mkl --mkl-prefix $MKL_DIR \
--cc $GCC_PATH --cc-opts $GCC_FLAGS --cxx $GXX_PATH --cxx-opts $GCC_FLAGS \
&& cd Linux-x86_64-g++ && time -p make -j \
&& cd $NAMD_DIR && mv Linux-x86_64-g++ Linux-x86_64-g++-mpi-mkl \
&& hpcx_unload && module purge"

### To build NAMD with Charm++ HPC-X UCX + ICC20u1 + FFTW3
CMD_BUILD_UCX_NAMD_ICC_FFTW3=" . $INTEL_COMPILER_DIR/compilervars.sh -arch intel64 -platform linux \
&& ./config Linux-x86_64-icc --with-memopt \
--charm-base $CHARM_BASE --charm-arch $CHARM_ARCH_UCX_ICC \
--with-fftw3 --fftw-prefix $ICC_FFTW3_LIB_DIR \ --cc $ICC_PATH --cc-opts $ICC_FLAGS \
--cxx $ICPC_PATH --cxx-opts $ICC_FLAGS \ && cd Linux-x86_64-icc && time -p make -j \
&& cd $NAMD_DIR && mv Linux-x86_64-icc Linux-x86_64-icc-ucx-fftw3;"

### To build NAMD with Charm++ HPC-X UCX + ICC20u1 + MKL
CMD_BUILD_UCX_NAMD_ICC_MKL=" . $INTEL_COMPILER_DIR/compilervars.sh -arch intel64 -platform linux \
&& ./config Linux-x86_64-icc --with-memopt \
--charm-base $CHARM_BASE --charm-arch $CHARM_ARCH_UCX_ICC \
--with-mkl --mkl-prefix $MKL_DIR \ --cc $ICC_PATH --cc-opts $ICC_FLAGS \
--cxx $ICPC_PATH --cxx-opts $ICC_FLAGS \ && cd Linux-x86_64-icc && time -p make -j \
&& cd $NAMD_DIR && mv Linux-x86_64-icc Linux-x86_64-icc-ucx-mkl;"

### To build NAMD with Charm++ HPC-X OpenMPI + ICC20u1 + FFTW3
CMD_BUILD_MPI_NAMD_ICC_FFTW3=" . $INTEL_COMPILER_DIR/compilervars.sh -arch intel64 -platform linux \
&& . $HPCX_FILES_DIR/hpcx-mt-init-ompi.sh && hpcx_load \ && ./config Linux-x86_64-icc --with-memopt \
--charm-base $CHARM_BASE --charm-arch $CHARM_ARCH_MPI_ICC \
--with-fftw3 --fftw-prefix $ICC_FFTW3_LIB_DIR \ --cc $ICC_PATH --cc-opts $ICC_FLAGS \
--cxx $ICPC_PATH --cxx-opts $ICC_FLAGS \ && cd Linux-x86_64-icc && time -p make -j \
&& cd $NAMD_DIR && mv Linux-x86_64-icc Linux-x86_64-icc-mpi-fftw3 \
&& hpcx_unload"

### To build NAMD with Charm++ HPC-X OpenMPI + ICC20u1 + MKL
CMD_BUILD_MPI_NAMD_ICC_MKL=" . $INTEL_COMPILER_DIR/compilervars.sh -arch intel64 -platform linux \
&& . $HPCX_FILES_DIR/hpcx-mt-init-ompi.sh && hpcx_load \ && ./config Linux-x86_64-icc --with-memopt \
--charm-base $CHARM_BASE --charm-arch $CHARM_ARCH_MPI_ICC \ --with-mkl --mkl-prefix $MKL_DIR \
--cc $ICC_PATH --cc-opts $ICC_FLAGS \ --cxx $ICPC_PATH --cxx-opts $ICC_FLAGS \
&& cd Linux-x86_64-icc && time -p make -j \
&& cd $NAMD_DIR && mv Linux-x86_64-icc Linux-x86_64-icc-mpi-mkl \
&& hpcx_unload"

eval $CMD_BUILD_UCX_NAMD_GCC_FFTW3
eval $CMD_BUILD_MPI_NAMD_GCC_FFTW3
eval $CMD_BUILD_UCX_NAMD_ICC_FFTW3
eval $CMD_BUILD_MPI_NAMD_ICC_FFTW3
eval $CMD_BUILD_UCX_NAMD_GCC_MKL;
eval $CMD_BUILD_MPI_NAMD_GCC_MKL;
eval $CMD_BUILD_UCX_NAMD_ICC_MKL;
eval $CMD_BUILD_MPI_NAMD_ICC_MKL;
wait
echo
$CMD_BUILD_UCX_NAMD_GCC_FFTW3
echo $CMD_BUILD_MPI_NAMD_GCC_FFTW3
echo $CMD_BUILD_UCX_NAMD_ICC_FFTW3
echo $CMD_BUILD_MPI_NAMD_ICC_FFTW3
echo $CMD_BUILD_UCX_NAMD_GCC_MKL;
echo $CMD_BUILD_MPI_NAMD_GCC_MKL;
echo $CMD_BUILD_UCX_NAMD_ICC_MKL;
echo $CMD_BUILD_MPI_NAMD_ICC_MKL;