(* ::Package:: *)

voxelize[model_, resolution_] := Module[
    {reg, bounds, dx, dy, dz, meshReg},
    
    (* Convert model to region if it isn't already *)
    meshReg = Switch[Head[model],
        Graphics3D, BoundaryDiscretizeGraphics[model],
        BoundaryMeshRegion, model,
        MeshRegion, model,
        (* For example data like the bunny *)
        List, BoundaryDiscretizeGraphics[Graphics3D[model]],
        _, If[RegionQ[model], model, 
            Message["Unsupported model format"]; Return[$Failed]]
    ];
    
    (* Get bounds *)
    bounds = RegionBounds[meshReg];
    
    (* Calculate step sizes *)
    {dx, dy, dz} = (bounds[[All, 2]] - bounds[[All, 1]])/resolution;
    
    (* Create voxel matrix *)
    Table[
        If[RegionMember[meshReg, {x, y, z}], 1, 0],
        {x, bounds[[1, 1]], bounds[[1, 2]], dx},
        {y, bounds[[2, 1]], bounds[[2, 2]], dy},
        {z, bounds[[3, 1]], bounds[[3, 2]], dz}
    ]
]


tetraModel = Tetrahedron[1];
tetraVoxels = voxelize[tetraModel, 20];
ArrayPlot3D[tetraVoxels]


sphereModel = Ball[{{-1, -1, -1}}, 1];
sphereVoxels = voxelize[sphereModel, 20];
ArrayPlot3D[sphereVoxels]
