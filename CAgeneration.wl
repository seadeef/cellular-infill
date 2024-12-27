BeginPackage["CAgeneration`"];

newState3D::usage = "newState3D[state, bitmask, rule] takes a 3D matrix \
of cell states and returns the next evolution with the given rule. \
Assumes a periodic boundary in the shape of a rectangular prism. A \
bitmask matrix can be specified in order to cut off parts of the grid \
that are not contained within the volume."

voxelizer::usage = "voxelizer[model, resolution] takes a model mesh and generates a bitmask with an amount of subdivided regions specified by resolution"
prismBitmask::usage = "prismBitmask[bounds] takes a list of {w,l,h} and generates a rectangular prism bitmask"
sphereBitmask::usage = "sphereBitmask[radius] generates a sphere bitmask with specified radius"
cylinderBitmask::usage = "cylinderBitmask[radius, height] generates a cylinder bitmask with specified radius and height"


Begin["`Private`"]
newState3D[currentState_, bitmask_, 
   rule_] := 
  Module[{}, newState = CellularAutomaton[rule, currentState]; 
   newState[[1 ;; -1, 1]] = newState[[1 ;; -1, -2]];
   newState[[1 ;; -1, -1]] = newState[[1 ;; -1, 2]];
   newState[[1]] = newState[[-2]];
   newState[[-1]] = newState[[2]];
   newState[[1 ;; -1, 1 ;; -1, 1]] = 
    newState[[1 ;; -1, 1 ;; -1, -2]];
   newState[[1 ;; -1, 1 ;; -1, -1]] = 
    newState[[1 ;; -1, 1 ;; -1, 2]];
   BitAnd[newState, bitmask]
   ];

voxelizer[model_, resolution_] := Module[
    {bounds, dx, dy, dz, xRange, yRange, zRange},
    
    bounds = RegionBounds[model];
    
    d = Min[(bounds[[All, 2]]-bounds[[All, 1]])]/resolution;
    
    xRange = Range[bounds[[1, 1]]+d/2, bounds[[1, 2]], d];
    yRange = Range[bounds[[2, 1]]+d/2, bounds[[2, 2]], d];
    zRange = Range[bounds[[3, 1]]+d/2, bounds[[3, 2]], d];
    
    Table[
        If[RegionMember[model, {x, y, z}], 1, 0],
        {x, xRange},
        {y, yRange},
        {z, zRange}
    ]
]

prismBitmask[bounds_] := ConstantArray[1, bounds]
sphereBitmask[r_] := Table[If[Norm[{x, y, z}]<=r,1,0],{x,-r,r},{y,-r,r},{z,-r,r}]
cylinderBitmask[r_, h_] := Table[If[Norm[{x, y}]<=r,1,0],{x,-r,r},{y,-r,r},{z,0,h}]
   
End[]

EndPackage[]