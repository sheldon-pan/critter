#include "dispatch.h"
#include "../decomposition/container/comm_tracker.h"
#include "../decomposition/util/util.h"
#include "../decomposition/volumetric/volumetric.h"
#include "../decomposition/path/path.h"
#include "../decomposition/record/record.h"
#include "../optimization/path/path.h"

namespace critter{
namespace internal{

void allocate(MPI_Comm comm){
  switch (mechanism){
    case 0:
      decomposition::allocate(comm);
  }
}

void reset(){
  switch (mechanism){
    case 0:
      decomposition::reset();
  }
}

void initiate(size_t id, volatile double curtime, int64_t nelem, MPI_Datatype t, MPI_Comm cm,
              bool is_sender, int partner1, int partner2){
  switch (mechanism){
    case 0:
      decomposition::path::initiate(*(decomposition::blocking*)decomposition::list[id],curtime,nelem,t,cm,is_sender,partner1,partner2);
      break;
  }
}

void initiate(size_t id, volatile double curtime, volatile double itime, int64_t nelem,
              MPI_Datatype t, MPI_Comm cm, MPI_Request* request, bool is_sender, int partner){
  switch (mechanism){
    case 0:
      decomposition::path::initiate(*(decomposition::nonblocking*)decomposition::list[id],curtime,itime,nelem,t,cm,request,is_sender,partner);
      break;
  }
}

void complete(size_t id, int recv_source){
  switch (mechanism){
    case 0:
      decomposition::path::complete(*(decomposition::blocking*)decomposition::list[id],recv_source);
      break;
  }
}

void complete(double curtime, MPI_Request* request, MPI_Status* status){
  switch (mechanism){
    case 0:
      decomposition::path::complete(curtime,request,status);
      break;
  }
}

void complete(double curtime, int count, MPI_Request array_of_requests[], int* indx, MPI_Status* status){
  switch (mechanism){
    case 0:
      decomposition::path::complete(curtime,count,array_of_requests,indx,status);
      break;
  }
}

void complete(double curtime, int incount, MPI_Request array_of_requests[], int* outcount, int array_of_indices[], MPI_Status array_of_statuses[]){
  switch (mechanism){
    case 0:
      decomposition::path::complete(curtime,incount,array_of_requests,outcount,array_of_indices,array_of_statuses);
      break;
  }
}

void complete(double curtime, int count, MPI_Request array_of_requests[], MPI_Status array_of_statuses[]){
  switch (mechanism){
    case 0:
      decomposition::path::complete(curtime,count,array_of_requests,array_of_statuses);
      break;
  }
}

void propagate(MPI_Comm comm){
  switch (mechanism){
    case 0:
      decomposition::_MPI_Barrier.comm = comm;
      decomposition::path::propagate(decomposition::_MPI_Barrier);
      break;
  }
}

void collect(MPI_Comm comm){
  switch (mechanism){
    case 0:
      decomposition::volumetric::collect(comm);
      break;
  }
}

void final_accumulate(double last_time){
  switch (mechanism){
    case 0:
      decomposition::final_accumulate(last_time);
      break;
  }
}

void open_symbol(const char* symbol, double curtime){
  switch (mechanism){
    case 0:
      decomposition::open_symbol(symbol,curtime);
      break;
  }
}

void close_symbol(const char* symbol, double curtime){
  switch (mechanism){
    case 0:
      decomposition::close_symbol(symbol,curtime);
      break;
  }
}

void clear(){
  switch (mechanism){
    case 0:
      decomposition::clear();
      break;
  }
}

void record(std::ofstream& Stream){
  switch (mechanism){
    case 0:
      decomposition::record::invoke(Stream);
      break;
  }
}

void record(std::ostream& Stream){
  switch (mechanism){
    case 0:
      decomposition::record::invoke(Stream);
      break;
  }
}

}
}
