(* ::Package:: *)

voxelize[model_, resolution_] := Module[
    {bounds, dx, dy, dz, xRange, yRange, zRange},
    
    bounds = RegionBounds[model];
    
    {dx, dy, dz} = (bounds[[All, 2]])/resolution;
    
    xRange = Range[bounds[[1, 1]], bounds[[1, 2]], dx];
    yRange = Range[bounds[[2, 1]], bounds[[2, 2]], dy];
    zRange = Range[bounds[[3, 1]], bounds[[3, 2]], dz];
    
    Table[
        If[RegionMember[model, {x, y, z}], 1, 0],
        {x, xRange},
        {y, yRange},
        {z, zRange}
    ]
]


tetraModel = BoundaryMeshRegion[Tetrahedron[1]];
tetraVoxels = voxelize[tetraModel, 20];
ArrayPlot3D[tetraVoxels, 
 AspectRatio -> Automatic,
 Boxed -> True,
 Axes -> True,
 PlotRange -> All]
