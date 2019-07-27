launchbscf () {
  # launch scaLAPACK_CF
  local scale=\${1}
  local binaryPath=\${2}
  local numIterations=\${3}
  local launchID=\${4}
  local NumNodes=\${5}
  local ppn=\${6}
  local tpr=\${7}
  local matrixDimM=\${8}
  local matrixDimMorig=\${8}
  local minBlockSize=\${9}
  local maxBlockSize=\${10}
  local nodeIndex=\${11}
  local scaleRegime=\${12}
  local nodeCount=\${13}
  for ((k=\${minBlockSize}; k<=\${maxBlockSize}; k*=2))
  do
    # Set up the file string that will store the local benchmarking results
    local fileString="DataFiles/results_${tag4}_\${scale}_\${NumNodes}nodes_\${matrixDimM}dimM_\${k}bSize_\${numIterations}numIter_\${ppn}ppn_\${tpr}tpr_\${curLaunchID}launchID"
    # 'PreFile' requires NumNodes specification because in the 'Pre' stage, we want to keep the data for different node counts separate.
    local PreFile="${tag4}_\${scale}_\${matrixDimM}_\${k}_\${ppn}_\${tpr}_\${NumNodes}nodes"
    local PostFile="${tag4}_\${scale}_\${matrixDimMorig}_\${k}_\${ppn}_\${tpr}"
    local UpdatePlotFile1="${tag4}_\${scale}_\${matrixDimMorig}_\${k}"
    local UpdatePlotFile2="${tag4}_\${scale}_\${ppn}_\${tpr}"

    if [ \${nodeIndex} == 0 ];
    then
      # Write to plotInstructions file
      WriteMethodDataForPlotting 0 \${UpdatePlotFile1} \${UpdatePlotFile2} ${tag4} \${PostFile} \${k} \${ppn} \${tpr}
      writePlotFileNameScalapackCholesky \${PostFile} $SCRATCH/${fileName}/plotInstructions.sh 1
    fi

    WriteMethodDataForCollectingStage1 ${tag4} \${PreFile} \${PreFile} \${PreFile}_blah $SCRATCH/${fileName}/collectInstructionsStage1.sh
    WriteMethodDataForCollectingStage2 \${launchID} ${tag4} \${PreFile} \${PreFile} \${PreFile}_blah \${PostFile} \${PostFile} \${PostFile} $SCRATCH/${fileName}/collectInstructionsStage2.sh
    launchJobsPortal \${binaryPath} ${tag4} \${fileString} \${curLaunchID} \${NumNodes} \${ppn} \${tpr} \${matrixDimM} \${k} \${numIterations} $SCRATCH/${fileName}/\${fileString}
    writePlotFileNameScalapackCholesky \${fileString} $SCRATCH/${fileName}/collectInstructionsStage1.sh 0
  done
}
