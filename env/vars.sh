#!/bin/bash

# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: BSD-3-Clause

source /opt/intel/oneapi/setvars.sh --force

if [[ -z ${BASE} ]]; then
    THIS_DIR=$(pwd)
    if [ "$(basename ${THIS_DIR})" = "ishmem_demo" ]; then
    else
        echo "\nWARNING! This directory name is not 'ishmem_demo'"
        echo "           please run from top-level project directory\n"
    fi
    export BASE=${THIS_DIR}/ishmem_workspace/$(git rev-parse --abbrev-ref HEAD)
    echo "BASE env var is unset, workspace directory set to ${BASE}"
else
    export BASE=${BASE}
fi

#Set environment variables
export SOS_BRANCH=nomerge/mmap
export SHMEM_DIR=${BASE}/install/sos
export ISHMEM_ROOT=${BASE}/install/ishmem
export SHMEM_INSTALL_PREFIX=${SHMEM_DIR}
export PMI_MAX_KVS_ENTRIES=1000000
export FI_PROVIDER="verbs;ofi_rxm"
export FI_CXI_OPTIMIZED_MRS=0
export FI_CXI_DEFAULT_CQ_SIZE=131072
export EnableImplicitScaling=0
export SYCL_DEVICE_FILTER=:gpu
export LIBFABRIC_BRANCH=v1.22.0
export OFI_PREFIX=${BASE}/install/libfabric
export L0_PREFIX=${BASE}/install/level-zero

#Set path and library path:
export PATH=${SHMEM_DIR}/bin:${ISHMEM_ROOT}/bin:$PATH
export LD_LIBRARY_PATH=${SHMEM_DIR}/lib:${SHMEM_DIR}/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${ISHMEM_ROOT}/lib:${ISHMEM_ROOT}/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${OFI_PREFIX}/lib:${OFI_PREFIX}/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${L0_PREFIX}/lib:${L0_PREFIX}/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/cray/pe/pmi/6.1.9/lib:$LD_LIBRARY_PATH
unset ZE_FLAT_DEVICE_HIERARCHY
