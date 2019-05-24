#!/bin/bash

## Should be run after Turbine.msh is created
## Should be run only in this directory


## Delete older intermediate files (except Turbine.msh)
rm -rf pimplefoam.log
rm -rf postProcessing
rm -rf processor*
rm -rf *.pos
rm -rf constant/polyMesh

## Get ready for OpenFOAM computation
gmshToFoam ./Turbine.msh
createPatch -overwrite
renumberMesh -overwrite
rm -rf 0
cp -rf 0.orig 0
decomposePar

## Run OpenFOAM computation
mpirun -np 4 pimpleFoam -parallel | tee pimplefoam.log
