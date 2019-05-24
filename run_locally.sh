#!/bin/bash

## Should be run after Turbine.msh is created
## Should be run only in this directory

## Store outputs in new folder in localruns
FOLDER=localruns/run.`ls localruns/ | wc -l`
mkdir -p $FOLDER
echo "Start time:                        " `date` >> $FOLDER/timings.txt

## Delete older intermediate files (except Turbine.msh)
rm -rf pimplefoam.log
rm -rf postProcessing
rm -rf processor*
rm -rf *.pos
rm -rf constant/polyMesh
echo "Finished removing old files:       " `date` >> $FOLDER/timings.txt

## Get ready for OpenFOAM computation
gmshToFoam ./Turbine.msh
createPatch -overwrite
renumberMesh -overwrite
rm -rf 0
cp -rf 0.orig 0
decomposePar
echo "Now ready for OpenFOAM computation:" `date` >> $FOLDER/timings.txt

## Run OpenFOAM computation
mpirun -np 4 pimpleFoam -parallel | tee pimplefoam.log
echo "Done with OpenFOAM computation:    " `date` >> $FOLDER/timings.txt

## Copy files to output folder
cp postProcessing/forces/0/coefficient.dat $FOLDER/
cp pimplefoam.log $FOLDER/
cp system/controlDict $FOLDER/
cp system/fvSchemes $FOLDER/
cp system/fvSolution $FOLDER/
echo "Done copying files:                " `date` >> $FOLDER/timings.txt
