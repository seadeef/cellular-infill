(* ::Package:: *)

BeginPackage["visualization`"];
Needs["CAgeneration`"];
Needs["metrics`"];


visualize3DMatrix::usage = "visualize3DMatrix[n] displays n evolutions of a cellular automata given the following options: \
Shape describes the boundary that the CA is constrained: Prism, Sphere, or Cylinder \
Radius is relevant for Sphere and Cylinder \
Bounds is the list containing width, height, length for the rectangular prism \
Rule describes how the CA will evolve (see Wolfram docs) \
" 

Begin["`Private`"]

Options[visualize3DMatrix] = {"Shape"->"Prism", "Bounds"->{0,0,0}, "Radius"->0, "Height"->0, "Rule"-> {14, {2, 1}, {1, 1, 1}}, "Resolution"->0, "Mesh"->Octahedron[]};

visualize3DMatrix[n_, OptionsPattern[]] := 
 Module[{xMax, yMax, zMax, bitmask, slices, displaySlices},
  
 bitmask = Switch[OptionValue["Shape"],
    "Prism", prismBitmask[OptionValue["Bounds"]],
    "Sphere", sphereBitmask[OptionValue["Radius"]],
    "Cylinder", cylinderBitmask[OptionValue["Radius"], OptionValue["Height"]],
    "Custom", voxelizer[OptionValue["Mesh"], OptionValue["Resolution"]]
  ];

  {xMax, yMax, zMax} = Dimensions[bitmask];

  slices = NestList[newState3D[#, bitmask, OptionValue["Rule"]] &, CenterArray[1, {xMax, yMax, zMax}], n];
  displaySlices={slices,Map[isolatedParts,slices]};
  
  Manipulate[
   Module[{slicedCubes},
    slicedCubes = Flatten[
      Table[
       If[displaySlices[[displayMode]][[s]][[i,j,k]] == 1 && (i <= xLayers) &&
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
    Row[{"Infill: ",Style[ToString[NumberForm[infillPercentage[slices[[s]], bitmask]*100,{4,2},NumberPadding->{"","0"}]]<>"%",Bold]}],
    Row[{"connectivity: ",Style[ToString[NumberForm[connectivity[slices[[s]]]*100,{4,2},NumberPadding->{"","0"}]]<>"%",Bold]}]
    }]],

   {{xLayers, xMax, "x Layers"}, 1, xMax, 1, Appearance -> "Labeled"},
   {{yLayers, yMax, "y Layers"}, 1, yMax, 1, Appearance -> "Labeled"},
   {{zLayers, zMax, "z Layers"}, 1, zMax, 1, Appearance -> "Labeled"},
   {{s, 1, "Slice"}, 1, n, 1, Appearance -> "Labeled"},
   {{displayMode,1,"Display Mode"},{1->"Regular",2->"Isolated Parts"}},

   
   ControlPlacement -> Top,
   Initialization :> {xLayers = xMax; yLayers = yMax; zLayers = zMax}
   ]
  ]

End[]

EndPackage[]

