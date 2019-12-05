
# critter
Welcome! If you are looking for a lightweight tool to both analyze and predict the critical path costs of your distributed-memory MPI program, you have come to the right place. `critter` seeks to understand both the critical path and the average (per-process) path of your MPI program, and counts the following metrics for each:

1. number of bytes communicated
2. communication time
3. idle time
4. estimated communication cost
5. estimated synchronization cost
6. overlap time
7. total runtime

`critter` also counts the first five metrics above for each tracked MPI routine (see table below).

`critter` provides three levels of support:
1. counting critical/per-process path measures and outputting data to the standard output file
2. both counting and tracking the critical/per-process path measures and critical path itself, as identified by local synchronization points inherent in your program (any intercepted MPI routine)
3. micro-benchmarks for predicting based on critical path from level2

Using both the micro-benchmarks and the tracked critical path, `critter` can re-assemble the communication costs and provide an accurate assessment and prediction for strong scaling and weak scaling tests for any node count.

See the lists below for an accurate depiction of our current support.

## Build and use instructions
`configure` compiler and flags in `config/config.mk` (MPI installation and C++11 are required). Run `make` in the main directory to generate the library file `./lib/libcritter.a`. Include `critter.h` in all files that use MPI in your application, remove all `include mpi.h`, and link to `./lib/libcritter.a`. Make sure to run `export CRITTER_VIZ=ON` before building your application for levels 2 and 3 support.

`critter` provides three routines to the user: `critter::start()`, `critter::stop()`, and `critter::print(int size, double* data)`. The first two create the window within which all MPI routines are intercepted and tracked. The latter is optional and is provided to allow the user to include diagnostic data for the test, including information such as residual or raw performance.

Each of `critter`'s three levels of support require increasing user input. If you want level 1 support, simply follow the directions above, create your own scripts, and look for `critter`'s output to stdout.

Levels 2 and 3 require more user input, but provide much stronger tools for analysis and prediction, and save all of the hassle in writing script files and plotting data.

Depending on the machine, the user should run `python setup.py develop --user` to register the python library. We have provided a few sample instruction files under `experiments/` that should be modified for your needs. Each invocation of the instructions file will generate a test directory under both `Tests/` and `$SCRATCH/`, the latter of which should contain all relevant data.

The user should build his/her program separately, and then inject the corresponding binary into `critter`'s `bin/` directory. All binary names should correspond to the `algorithm` class instance tag specified in the instructions file.

In addition to writing the instructions file, the user need also write a file under `experiments/machines` to specify exactly how the machine handles a few key details (such as providing the launch and scheduling information). See one of the provided example files.

## Advice
Large-scale tests can be expensive, and if you are using `critter`'s levels 2/3 support, we want to make sure you agree with the generated tests.
1. always run `generate` without `launch` first and inspect the generated script files in the test directory. Once satisfied, erase the generated test directories (optional but convenient) and add the `launch` method directly after the `generate` method
2. remove all binaries in the `bin/` (in test directory)  before applying `tar -cvf`
3. plot names can be specified in `instructions.py` for each test
4. due to scaplot assumptions, users can only specify node counts that range in a multiplicative manner
5. don't have any `'+'` characters in the file path to `critter`, nor in any of the arguments. `critter` uses this character to parse file strings
6. make sure your binaries are not named `test_allreduce` or similar for other benchmarks
7. make sure any communication requiring a tag doesn't use a tag of the same value as critter' internal tag critter::internal::tag. If there is a conflict, simply modify critter's internal tag and rebuild instead of modifying your source code.

## Design decisions
Critter will never assume a communication protocol more limiting than what is specified in the MPI Standard to propogate critical paths. As such, it will never break the semantics of your parallel program and limit forward progress in tracking critical paths. If and only if the MPI implementation performs a communication protocol more limiting than is necessary (i.e. requiring synchronous handshake between processes calling MPI_Send and MPI_Receive), it may report an erroneous critical path measure.
1. Critter assumes any blocking collective routine performs a synchronization at the start, and thereby does not force a limiting communication protocol in order to propogate the critical paths before the collective routine takes place. It allows processes to jump back into the user code without further synchronization once the collective routine completes.
2. Critter assumes that in any asynchronous p2p communication, the sender does not wait on the receiver, and thus need not accumulate the receiver's critical path information.
3. In any p2p communication, Critter forces the sender to send another message containing its critical path information. This message will use the same communication protocol. For example, if critter intercepts MPI_Isend, the sender will use another MPI_Isend to propogate its critical path information to the receiver, thus keeping the communication protocol at nonblocking.

## Current support
|     MPI routine         |   tracked   |   tested   |    benchmarks   |     
| ----------------------- | ----------- | ---------- | --------------- |
| MPI_Barrier             |   yes       |   no       |   no            |
| MPI_Bcast               |   yes       |   yes      |   yes           |
| MPI_Reduce              |   yes       |   yes      |   yes           |
| MPI_Allreduce           |   yes       |   yes      |   yes           |
| MPI_Gather              |   yes       |   no       |   no            |
| MPI_Gatherv              |   yes       |   no       |   no            |
| MPI_Allgather           |   yes       |   yes      |   yes           |
| MPI_Allgatherv           |   yes       |   no      |   no           |
| MPI_Scatter             |   yes       |   no       |   no            |
| MPI_Scatterv             |   yes       |   no       |   no            |
| MPI_Reduce_Scatter      |   yes       |   no       |   no            |
| MPI_Alltoall            |   yes       |   no       |   no            |
| MPI_Alltoallv           |   yes       |   no       |   no            |
| MPI_Ibcast               |   no       |   no      |   no           |
| MPI_Ireduce              |   no       |   no      |   no           |
| MPI_Iallreduce           |   no       |   no      |   no           |
| MPI_Igather              |   no       |   no       |   no            |
| MPI_Igatherv              |   no       |   no       |   no            |
| MPI_Iallgather           |   no       |   no      |   no           |
| MPI_Iallgatherv           |   no       |   no      |   no           |
| MPI_Iscatter             |   no       |   no       |   no            |
| MPI_Iscatterv             |   no       |   no       |   no            |
| MPI_Ireduce_Scatter      |   no       |   no       |   no            |
| MPI_Ialltoall            |   no       |   no       |   no            |
| MPI_Ialltoallv           |   no       |   no       |   no            |
| MPI_Send           |   yes       |   no       |   yes            |
| MPI_Recv           |   yes       |   no       |   yes            |
| MPI_Isend           |   yes       |   no       |   no            |
| MPI_Irecv           |   yes       |   no       |   no            |
| MPI_Sendrecv           |   yes       |   no       |   yes            |
| MPI_Sendrecv_replace           |   yes       |   yes       |   yes            |
