# ishmem_demo

To build Intel SHMEM v1.1.0, run:

```
unset BASE
./install_ishmem.sh
```

This will create an `ishmem_workspace` directory in the current working
directory. The workspace is within another directory corresponding to the Git
branch name. The default branch is `main`, which targets the Sunspot system at
Argonne National Lab. An alternative location for the workspace directory can
be set with env var $BASE. Please run the `install_ishmem.sh` script from
within the top-level `ishmem_demo` directory.

After installation is complete, try running an example. In the "example"
directory is a self-contained complete ISHMEM project:

```
cd example
mkdir build
cd build
cmake .. -DISHMEM_INSTALL_PREFIX=${ISHMEM_ROOT}
```

To revive the ISHMEM environment quickly, for example, in a new terminal
session:

```
source ./env/vars.sh
```

That script is also invoked by `./install_ishmem.sh`
Please run the `vars.sh` script from within the top-level `ishmem_demo`
directory.

To start an interactive job on a single Sunspot node:

```
qsub -l select=<num_nodes> -l walltime=30:00 -A Aurora_deployment -q workq -I
```

where <num_nodes> is 1. Multiple nodes are also supported.

To execute a helloworld test allocated to all 6 GPUs (two-tiles per GPU) on a
single node:

```
mpirun -N 12 -n 12 ./examples/1_helloworld
```

contact:  david.m.ozog@intel.com
          md.rahman@intel.com
