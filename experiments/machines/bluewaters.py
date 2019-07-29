from subprocess import call

class bluewaters(object):
    """
    """
    BatchFileExtension="pbs"
    Batch="qsub"
    AllocationName="bahv"

    @staticmethod
    def set():
        """
	"""
        os.environ["SCRATCH"] = "/scratch/sciteam/hutter"
        #read -p "Do you want the Intel Programming Environment (I) or the GNU Programming Environment (G) (choose G if running on GPU): " bwPrgEnv
        bwPrgEnv="G"
        if (bwPrgEnv == "I"):
            if (os.environ["PE_ENV"] == "GNU"):
                call("module swap PrgEnv-gnu PrgEnv-intel")
            elif (os.environ["PE_ENV"] == "CRAY"):
                call("module swap PrgEnv-cray PrgEnv-intel")
        elif (bwPrgEnv == "G"):
            if (os.environ["PE_ENV"] == "INTEL"):
                call("module swap PrgEnv-intel PrgEnv-gnu")
            elif (os.environ["PE_ENV"] == "CRAY"):
                call("module swap PrgEnv-cray PrgEnv-gnu")
        #if (accelType == "n"):
        #    call("module load cblas")
        #else
        #    call("module load cudatoolkit")

    @staticmethod
    def script(scriptFile,testName,curNumNodes,curPPN,curTPR,numPEsPerNode,numHours,numMinutes,numSeconds):
        """
	"""
        scriptFile.write("#!/bin/bash\n")
        scriptFile.write("#PBS -l nodes=%d:ppn=%d:xe\n" %(curNumNodes,numPEsPerNode))
        scriptFile.write("#PBS -l walltime=%s:%s:%s\n" %(numHours,numMinutes,numSeconds))
        scriptFile.write("#PBS -N camfs\n")
        scriptFile.write("#PBS -e %s_%dnodes_%dppn_%dtpr.err\n" %(testName,curNumNodes,curPPN,curTPR))
        scriptFile.write("#PBS -o %s_%dnodes_%dppn_%dtpr.out\n" %(testName,curNumNodes,curPPN,curTPR))
        scriptFile.write("##PBS -m Ed\n")
        scriptFile.write("#PBS -M hutter2@illinois.edu\n")
        scriptFile.write("#PBS -A %s\n" %(AllocationName))
        scriptFile.write("#PBS -W umask=0027\n")
        #echo "cd ${PBS_O_WORKDIR}"
        scriptFile.write("#module load craype-hugepages2M  perftools\n")
        scriptFile.write("#export APRUN_XFER_LIMITS=1  # to transfer shell limits to the executable\n")
        scriptFile.write("export OMP_NUM_THREADS=%d\n" %(curTPR))
        #if [ "${nodeType}" == "N" ];
        #then
            #  export CRAY_CUDA_MPS=1
            #  export MPICH_RDMA_ENABLED_CUDA=1
        #fi

    @staticmethod
    def writeTest(scriptFile,numProcesses,ppn,tpr,AlgInputString):
        """
	"""
	Str1="aprun -n %d -N %d -d %d " %(numProcesses,ppn,tpr)
        ScriptFile.write(Str1+AlgInputString)
