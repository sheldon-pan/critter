launchbsqr () {
  # launch scaLAPACK_QR
  local binaryTag=\${1}
  local scale=\${2}
  local binaryPath=\${3}
  local numIterations=\${4}
  local launchID=\${5}
  local NumNodes=\${6}
  local ppn=\${7}
  local tpr=\${8}
  local matrixDimM=\${9}
  local matrixDimN=\${10}
  local matrixDimMorig=\${11}
  local matrixDimNorig=\${12}
  local numProwsorig=\${13}
  local numPcolsorig=\${14}
  local numProws=\${15}
  local minBlockSize=\${16}
  local maxBlockSize=\${17}
  local nodeIndex=\${18}
  local scaleRegime=\${19}
  local nodeCount=\${20}
  for ((k=\${minBlockSize}; k<=\${maxBlockSize}; k*=2))
  do
    # Set up the file string that will store the local benchmarking results
    local fileString="DataFiles/results_\${binaryTag}_\${scale}_\${NumNodes}nodes_\${matrixDimM}dimM_\${matrixDimN}dimN_\${numProws}numProws_\${k}bSize_\${numIterations}numIter_\${ppn}ppn_\${tpr}tpr_\${curLaunchID}launchID"
    # 'PreFile' requires NumNodes specification because in the 'Pre' stage, we want to keep the data for different node counts separate.
    local PreFile="\${binaryTag}_\${scale}_\${matrixDimM}_\${matrixDimN}_\${numProws}_\${k}_\${ppn}_\${tpr}_\${NumNodes}nodes"
    local PostFile="\${binaryTag}_\${scale}_\${matrixDimMorig}_\${matrixDimNorig}_\${numProwsorig}_\${k}_\${ppn}_\${tpr}"
    local UpdatePlotFile1="\${binaryTag}_\${scale}_\${matrixDimMorig}_\${matrixDimNorig}_\${numPcolsorig}_\${k}"
    local UpdatePlotFile2="\${binaryTag}_\${scale}_\${matrixDimMorig}_\${matrixDimNorig}_\${ppn}_\${tpr}"

    # Plot instructions only need a single output per scaling study
    if [ \${nodeIndex} == 0 ];
    then
      WriteMethodDataForPlotting 0 \${UpdatePlotFile1} \${UpdatePlotFile2} \${binaryTag} \${PostFile} \${numProws} \${k} \${ppn} \${tpr}
      writePlotFileNameScalapackQR \${PostFile} $SCRATCH/${fileName}/plotInstructions.sh 1
    fi

    WriteMethodDataForCollectingStage1 \${binaryTag} \${PreFile} \${PreFile}_NoFormQ \${PreFile}_FormQ $SCRATCH/${fileName}/collectInstructionsStage1.sh
    WriteMethodDataForCollectingStage2 \${launchID} \${binaryTag} \${PreFile} \${PreFile}_NoFormQ \${PreFile}_FormQ \${PostFile} \${PostFile}_NoFormQ \${PostFile}_FormQ $SCRATCH/${fileName}/collectInstructionsStage2.sh
    launchJobsPortal \${binaryPath} \${binaryTag} \${fileString} \${curLaunchID} \${NumNodes} \${ppn} \${tpr} \${matrixDimM} \${matrixDimN} \${k} \${numIterations} 0 \${numProws} 1 0 $SCRATCH/${fileName}/\${fileString}
    writePlotFileNameScalapackQR \${fileString} $SCRATCH/${fileName}/collectInstructionsStage1.sh 0
  done
}
