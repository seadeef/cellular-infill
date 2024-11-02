(* ::Package:: *)

BeginPackage["visualization`"];
Needs["CAgeneration`"];
Needs["metrics`"];


visualize3DMatrix::usage = "visualize3DMatrix[slices, shape] takes a list of 3D evolution states and displays them visually within the given shape" 

Begin["Private`"]

visualize3DMatrix[slices_, shape_] := 
 Module[{cubes, xLayers, yLayers, zLayers},
  
  {xMax, yMax, zMax, slicesMax} = {Length[slices[[1]]], 
    Length[slices[[1]][[1]]], Length[slices[[1]][[1, 1]]], 
    Length[slices]};
  
  Manipulate[
   Module[{slicedCubes},
    slicedCubes = Flatten[
      Table[
       If[slices[[s]][[i, j, k]] == 1 && (i <= xLayers) && 
         (j <= yLayers) && (k <= zLayers),
        Cuboid[{i - 1, j - 1, k - 1}],
        Nothing
        ],
       {i, 1, xMax}, {j, 1, yMax}, {k, 1, zMax}
       ]
      ];
    
    Column[{
        Graphics3D[{Opacity[0.6], Blue, slicedCubes},
        Boxed -> False, Axes -> True, AxesOrigin -> {0, 0, 0}, 
        AxesLabel -> {"x", "y", "z"}, 
        PlotRange -> {{0, xMax}, {0, yMax}, {0, zMax}}],
    Row[{"%Infill: ",Style[Dynamic[NumberForm[N[InfillPercentage[slices[[s]],shape]*100],{4,2},NumberPadding->{"","0"}]],Bold]}]
    }]],

   {{xLayers, xMax, "x Layers"}, 1, xMax, 1, Appearance -> "Labeled"},
   {{yLayers, yMax, "y Layers"}, 1, yMax, 1, Appearance -> "Labeled"},
   {{zLayers, zMax, "z Layers"}, 1, zMax, 1, Appearance -> "Labeled"},
   {{s, 1, "Slice"}, 1, slicesMax, 1, Appearance -> "Labeled"},
   
   ControlPlacement -> Top,
   Initialization :> {xLayers = xMax; yLayers = yMax; zLayers = zMax}
   ]
  ]

End[]

EndPackage[]
