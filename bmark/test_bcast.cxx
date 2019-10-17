#include "../src/critter.h"
#include <random>

int main(int argc, char ** argv){
  size_t msg_size = atoi(argv[1]);
  size_t sub_comm_size = atoi(argv[2]);
  MPI_Init(&argc, &argv);
  int rank, world_size;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);
  srand48(rank);
  double* buf = (double*)malloc(msg_size*sizeof(double));
  /*for (int j=0; j<msg_size; j++){
    buf[j] = drand48();
  }*/
  MPI_Comm sub_comm;
  MPI_Comm_split(MPI_COMM_WORLD, rank<sub_comm_size, rank, &sub_comm);
  for (auto i=0; i<3; i++){
    critter::start();
    MPI_Bcast(buf, msg_size, MPI_DOUBLE, sub_comm_size-1, sub_comm);
    critter::stop();
  }
  MPI_Comm_free(&sub_comm);
  free(buf);
  MPI_Finalize();
  return 0;
}
