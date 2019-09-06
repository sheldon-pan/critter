### Below: variables set by user

import os
import math
from operator import (__mul__,__add__,__div__,__sub__)
from critter import (bench,algorithm)

from machines import (stampede2)
from libraries import (camfs)

CritterPath=os.environ["HOME"]+"/critter/"
MachineType=stampede2
LibraryTypeList=[camfs]
fileID="benchQR1"
roundID=1
NumLaunchesPerBinary=1
numTests=1
numHours="01"
numMinutes="00"
numSeconds="00"
email="hutter2@illinois.edu"
if (os.system("hostname |grep \"porter\"") != 256):
    minPEcountPerNode=1
    maxPEcountPerNode=16
elif (os.system("hostname |grep \"stampede2\"") != 256):
    minPEcountPerNode=64          # Note: this will need to be changed before launching Critter runs
    maxPEcountPerNode=128
elif (os.system("hostname |grep \"h2o\"") != 256):
    minPEcountPerNode=16
    maxPEcountPerNode=32
nodeMinList=[1]
nodeMaxList=[8]
ppnMinList=[32]
ppnMaxList=[64]
tprMinList=[1]
tprMaxList=[4]
nodeScaleFactorList=[2]
ppnScaleFactorList=[2]
tprScaleFactorList=[2]
nodeScaleOperatorList=[__mul__]
ppnScaleOperatorList=[__mul__]
tprScaleOperatorList=[__mul__]
Algorithm1 = algorithm("camfs_cacqr2",\
                       [8192,512,1,0,0,0,3],\
		       [8192,512,8,0,0,0,3],\
		       [1,1,2,1,1,1,1],\
		       [__mul__,__mul__,__mul__,__mul__,__mul__,__mul__,__mul__],\
                       lambda x: 0,\
                       lambda InputList,HardwareList: ((((HardwareList[0]*HardwareList[1])/(InputList[2]**2))>=InputList[2]) and (InputList[4] <= int(math.log(InputList[2])))),\
		       [[1,1,1,1,1,1,1]],\
		       [[__mul__,__mul__,__mul__,__mul__,__mul__,__mul__,__mul__]])
File1 = [["critter",[]],["perf",["Performance","Residual","Deviation from Orthogonality"]]]
Test1=[[Algorithm1],"Strong Scaling: 8192x512 matrix",File1]
TestList=[Test1]

Launcher = bench(CritterPath,MachineType,LibraryTypeList,fileID,roundID,NumLaunchesPerBinary,\
                 numTests,numHours,numMinutes,numSeconds,email,minPEcountPerNode,maxPEcountPerNode,\
		 nodeMinList,nodeMaxList,ppnMinList,ppnMaxList,tprMinList,tprMaxList,nodeScaleFactorList,ppnScaleFactorList,tprScaleFactorList,\
                 nodeScaleOperatorList,ppnScaleOperatorList,tprScaleOperatorList,TestList)
#Launcher.build()
Launcher.generate()
#Launcher.launch()