#!/bin/bash

# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause

# Sets BASE env var if unset:
if [[ -f ${PWD}/env/vars.sh ]]; then
    source ${PWD}/env/vars.sh
else
    echo "Please run this script from within the top-level project directory."
    exit 1
fi

mkdir -p ${BASE}

# Note: if 'sos' directory is there, it's assumed to be there and working.
if [[ -d ${BASE}/sos ]]; then
    echo "Workspace directory (${BASE}) already exists."
    while :
    do
       read -p "Delete and rebuild existing workspace? (y/n/q) " new_workspace
       if [[ "$new_workspace" == "y" ]]; then
           rm -rf ${BASE}
           mkdir -p ${BASE}
           break
       elif [[ "$new_workspace" == "n" ]]; then
           echo "Only rebuilding the workspace..."
           sleep 1
           break
       elif [[ "$new_workspace" == "q" ]]; then
           exit 1
       else
           echo "must select 'y' or 'n'"
       fi
    done
else
    echo "BASE does not exist"
    new_workspace="y"
fi

#Clone/Build OFI
cd ${BASE}
git clone https://github.com/ofiwg/libfabric.git
cd libfabric
git checkout ${LIBFABRIC_BRANCH}
./autogen.sh
mkdir build
cd build
../configure --prefix=${OFI_PREFIX} --with-ze=${L0_PREFIX} --with-dlopen=no
make -j
make install

#Clone/Build SOS
cd ${BASE}
if [[ "$new_workspace" == "y" ]]; then
    git clone --recurse-submodules https://github.com/davidozog/SOS.git sos
fi
cd sos
git checkout ${SOS_BRANCH}
./autogen.sh
mkdir build
cd build
../configure --prefix=${SHMEM_DIR} --with-ofi=${OFI_PREFIX} --enable-pmi-simple --disable-fortran --enable-ofi-mr=basic --enable-hard-polling --disable-bounce-buffers --enable-ofi-hmem --disable-ofi-inject --enable-mmap CC=icx CXX=icpx
make -j32
make install

#Download and install CMake:
cd ${BASE}
wget https://github.com/Kitware/CMake/releases/download/v3.30.4/cmake-3.30.4-linux-x86_64.tar.gz
tar xzf cmake-3.30.4-linux-x86_64.tar.gz
mkdir install
mv cmake-3.30.4-linux-x86_64 install
export PATH=${PWD}/install/cmake-3.30.4-linux-x86_64/bin:$PATH

#Clone/Build Level Zero
cd ${BASE}
git clone https://github.com/oneapi-src/level-zero.git
cd level-zero
git checkout $LEVEL_ZERO_BRANCH
mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=${L0_PREFIX} ..
make -j
make install

#Clone/Build ISHMEM
cd ${BASE}
if [[ "$new_workspace" == "y" ]]; then
    git clone https://github.com/oneapi-src/ishmem.git ishmem
fi
cd ishmem
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${ISHMEM_ROOT} -DCMAKE_BUILD_TYPE=Release -DENABLE_OPENSHMEM=ON -DSHMEM_INSTALL_PREFIX=${SHMEM_DIR} -DL0_INSTALL_PREFIX=${L0_PREFIX} -DBUILD_TEST=NO -DBUILD_PERF_TEST=YES -DCTEST_SCHEDULER=mpi
make -j32
make install
