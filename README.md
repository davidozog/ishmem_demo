# ishmem_demo

To build Intel SHMEM v1.1.0, run the following commands:

```
unset BASE
./install_ishmem.sh
```

This will create an `ishmem_workspace` directory in the current working
directory. The workspace is placed within another directory corresponding to
the Git branch name. The default branch is `main`, which targets the Sunspot
system at the Argonne Leadership Computing Facility.

An alternative location for the workspace directory can be set with environment
variabale, BASE.

Please only run the `install_ishmem.sh` script from within the top-level
`ishmem_demo` directory.

To setup the ISHMEM environment for execution, run:

```
source ./env/vars.sh
```

Please only run the `./env/vars.sh` script from within the top-level
`ishmem_demo` directory.

After installation is complete and the environment is loaded, try running an
example. In the "examples" directory is a self-contained complete ISHMEM
project containing several small example programs:

```
cd examples
mkdir build
cd build
cmake ..
```

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
