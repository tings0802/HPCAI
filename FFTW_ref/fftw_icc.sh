#!/bin/bash
### To build shared library (single precision) with Intel C Compiler

CODE_NAME=fftw \
CODE_TAG=3.3.8 \
PSXE_DIR=/global/software/centos-7/modules/langs/intel/2020.1.217 \
ICC_DIR=$PSXE_DIR/compilers_and_libraries_2020.1.217 \
INTEL_LICENSE_FILE+=:27009@192.168.0.1 \
CODE_BASE_DIR=$HOME/cluster/thor/code \
CODE_DIR=$CODE_BASE_DIR/$CODE_NAME-$CODE_TAG \
INSTALL_DIR=$HOME/cluster/thor/application/libs/fftw \
CMAKE_PATH=/global/software/centos-7/modules/tools/cmake/3.16.4/bin/cmake \
ICC_PATH=$ICC_DIR/linux/bin/intel64/icc \
ICC_FLAGS='"-xBROADWELL -axBROADWELL,CORE-AVX2,SSE4.2 -O3 -DNDEBUG"' \

BUILD_LABEL=$CODE_TAG-shared-icc20-avx2-broadwell \
CMD_BUILD_SHARED_ICC=" \
    mkdir $CODE_DIR/build-$BUILD_LABEL; \
    cd $CODE_DIR/build-$BUILD_LABEL \
    && $CMAKE_PATH .. \
    -DBUILD_SHARED_LIBS=ON -DENABLE_FLOAT=ON \
    -DENABLE_OPENMP=OFF -DENABLE_THREADS=OFF \
    -DCMAKE_C_COMPILER=$ICC_PATH -DCMAKE_CXX_COMPILER=$ICC_PATH \
    -DENABLE_AVX2=ON -DENABLE_AVX=ON \
    -DENABLE_SSE2=ON -DENABLE_SSE=ON \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/$BUILD_LABEL \
    -DCMAKE_C_FLAGS_RELEASE=$ICC_FLAGS \
    -DCMAKE_CXX_FLAGS_RELEASE=$ICC_FLAGS \
    && time -p make VERBOSE=1 V=1 install -j \
    && cd $INSTALL_DIR/$BUILD_LABEL && ln -s lib64 lib | tee $BUILD_LABEL.log "

eval $CMD_BUILD_SHARED_ICC &
echo $CMD_BUILD_SHARED_ICC

# ==========================

#!/bin/sh
CODE_NAME=fftw \
CODE_TAG=3.3.8 \
PSXE_DIR=/opt/intel/compilers_and_libraries_2020.0.166 \
CODE_DIR=/home/t2/$CODE_NAME-$CODE_TAG \
CMAKE_PATH=/usr/bin/cmake \
INSTALL_DIR=/home/t2/fftw-build \
ICC_PATH=$PSXE_DIR/linux/bin/intel64/icc \
ICC_FLAGS='"-xBROADWELL -axBROADWELL,CORE-AVX2,SSE4.2 -O3 -DNDEBUG"' \


### To build shared library (single precision) with Intel C Compiler
BUILD_LABEL=$CODE_TAG-shared-icc20-avx2-broadwell
CMD_BUILD_SHARED_ICC="
mkdir $CODE_DIR/build-$BUILD_LABEL && \
cd $CODE_DIR/build-$BUILD_LABEL \
&& $CMAKE_PATH .. \
-DBUILD_SHARED_LIBS=ON -DENABLE_FLOAT=ON \
-DENABLE_OPENMP=OFF -DENABLE_THREADS=OFF \
-DCMAKE_C_COMPILER=$ICC_PATH -DCMAKE_CXX_COMPILER=$ICC_PATH \
-DENABLE_AVX2=ON -DENABLE_AVX=ON \
-DENABLE_SSE2=ON -DENABLE_SSE=ON \
-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/$BUILD_LABEL \
-DCMAKE_C_FLAGS_RELEASE=$ICC_FLAGS \
-DCMAKE_CXX_FLAGS_RELEASE=$ICC_FLAGS \
&& time -p make VERBOSE=1 V=1 install -j \
&& cd $INSTALL_DIR/$BUILD_LABEL && ln -s lib64 lib | tee $BUILD_LABEL.log "

eval $CMD_BUILD_SHARED_ICC 
wait
echo $CMD_BUILD_SHARED_ICC