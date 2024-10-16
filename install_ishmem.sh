#!/bin/bash

# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause

export HTTP_PROXY=http://proxy.alcf.anl.gov:3128
export HTTPS_PROXY=http://proxy.alcf.anl.gov:3128
export http_proxy=http://proxy.alcf.anl.gov:3128
export https_proxy=http://proxy.alcf.anl.gov:3128
git config --global http.proxy http://proxy.alcf.anl.gov:3128

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

#Clone/Build SOS
cd ${BASE}
if [[ "$new_workspace" == "y" ]]; then
    git clone --recurse-submodules https://github.com/Sandia-OpenSHMEM/SOS.git sos
fi
cd sos
./autogen.sh
mkdir build
cd build
../configure --prefix=${SHMEM_DIR} --with-ofi=${OFI_PREFIX} --with-pmi=${PMI_PREFIX} --disable-fortran --enable-ofi-mr=basic --enable-ofi-manual-progress --disable-libtool-wrapper --disable-bounce-buffers --enable-mr-endpoint --enable-ofi-hmem --disable-ofi-inject --disable-nonfetch-amo --enable-manual-progress CC=icx CXX=icpx
make -j32
make install

#Clone/Build ISHMEM
cd ${BASE}
if [[ "$new_workspace" == "y" ]]; then
    git clone https://github.com/oneapi-src/ishmem.git ishmem
fi
cd ishmem
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${ISHMEM_ROOT} -DCMAKE_BUILD_TYPE=Release -DENABLE_OPENSHMEM=ON -DSHMEM_INSTALL_PREFIX=${SHMEM_DIR} -DL0_INSTALL_PREFIX=${L0_PREFIX} -DBUILD_TEST=NO -DBUILD_PERF_TEST=YES
make -j32
make install
