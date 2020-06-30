#ifndef CRITTER__CONTAINER__SYMBOL_TRACKER_H_
#define CRITTER__CONTAINER__SYMBOL_TRACKER_H_

#include "../util.h"

namespace critter{
namespace internal{

// One instance for each unique symbol
class symbol_tracker{
  public:
    symbol_tracker() {}
    symbol_tracker(std::string name_);
    void stop(double save_time);
    void start(double save_time);
    bool operator<(const symbol_tracker& w) const ;

    std::string name;
    std::stack<double> start_timer;
    std::vector<double> cp_exclusive_contributions;
    std::vector<double> pp_exclusive_contributions;
    std::vector<double> cp_exclusive_measure;
    std::vector<double> pp_exclusive_measure;
    double* cp_numcalls; double* pp_numcalls; double* vol_numcalls;
    std::vector<double*> cp_incl_measure;
    std::vector<double*> cp_excl_measure;
    std::vector<double*> pp_incl_measure;
    std::vector<double*> pp_excl_measure;
    std::vector<double*> vol_incl_measure;
    std::vector<double*> vol_excl_measure;
    bool has_been_processed;
};

extern std::unordered_map<std::string,symbol_tracker> symbol_timers;

}
}

#endif /*CRITTER__CONTAINER__SYMBOL_TRACKER_H_*/
