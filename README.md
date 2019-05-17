# Vertical-Axis Wind Turbine mesh

This makes a mesh of a vertical-axis wind turbine.

## Requirements
This has been tested with `gmsh 3.0.6`.
You will also need OpenFOAM.

It will be helpful to have ParaView.

## How to run

1. Generate the mesh.

```
gmsh ./1.txt -3 -smooth 2 -clmax .25 -o ./Turbine.msh
```

2. Converts mesh file to OpenFOAM.
```
gmshToFoam ./Turbine.msh
createPatch -overwrite
renumberMesh -overwrite
```

**NOTE: Kunal had an issue so he added $End at the end of the Turbine.msh and it ran ok.**

3. Sometimes the `0/` files have been overwritten, so copy the original files from `0.orig/`.
```
rm -rf 0
cp -rf 0.orig 0
```

4. Decomposes the mesh into pieces, so you can run in parallel.
```
decomposePar
```

5. Remove the mesh file; you dont need it anymore.
```
rm -rf ./Turbine.msh
```

6. scp files to the supercomputer (i.e. Comet).

7. Remove all intermediate files:
```
rm -rf processor*
rm -rf *.pos
rm -rf *.msh
cd constant
rm -rf polyMesh
```

8. Run OpenFOAM on the supercomputer!
