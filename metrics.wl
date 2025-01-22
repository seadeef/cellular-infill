(* ::Package:: *)

BeginPackage["metrics`"]
Needs["CAgeneration`"]

infillPercentage::usage = 
    "infillPercentage[slice, shape] gives the ratio of filled cells to possible cells within the shape";
bfsConnectedParts::usage = 
    "bfsConnectedParts[vis, q] uses BFS to toggle all cells in vis that connect to source cells in q";
isolatedParts::usage = 
    "isolatedParts[slice] gives a slice that only contains cells isolated from the bottom";
connectivity::usage = 
    "connectivity[slice] gives the ratio of isolated cells in slice";
optimize::usage = "optimize[rulesMax, statesMax] searches rulesMax many rules for statesMax many states \
to find candidates within Infill[[2]] range of Infill[[1]] and above the connectivity threshold. \
Has the same options as visualize3DMatrix for describing the rule and shape";

connectedParts::usage = "connectedParts[slice] gives the matrix with all isolated parts removed"

Begin["`Private`"]

Options[optimize] = {"Infill"->-1, "Connectivity"->-1, "Shape"->"Prism", "Bounds"->{0,0,0}, "Radius"->0, "Height"->0, "Rule"-> {1, {2, 1}, {1, 1, 1}}, "Resolution"->0, "Mesh"->Octahedron[]};

infillPercentage[slice_, shape_] := 
    N[Divide[Count[Flatten[slice], 1], Count[Flatten[shape], 1]]]

bfsConnectedParts[vis_, q_] := 
    Module[{dir = {{0, 0, 1}, {1, 0, 0}, {-1, 0, 0}, {0, 1, 0}, {0, -1, 0}, {1, 1, 0}, {1, -1, 0}, {-1, 1, 0}, {-1, -1, 0}},
            visit = vis,
            queue = q,
            length = Length[vis],
            width = Length[vis[[1]]],
            height = Length[vis[[1, 1]]],
            pos = 1, cur},
        While[pos <= Length[queue],
            cur = queue[[pos]];
            pos++;
            Map[
                If[cur[[1]] + #[[1]] >= 1 &&
                   cur[[1]] + #[[1]] <= length &&
                   cur[[2]] + #[[2]] >= 1 &&
                   cur[[2]] + #[[2]] <= width &&
                   cur[[3]] + #[[3]] <= height &&
                   visit[[cur[[1]] + #[[1]], cur[[2]] + #[[2]], cur[[3]] + #[[3]]]] == 1,
                   visit[[cur[[1]] + #[[1]], cur[[2]] + #[[2]], cur[[3]] + #[[3]]]] = 0;
                   AppendTo[queue, {cur[[1]] + #[[1]], cur[[2]] + #[[2]], cur[[3]] + #[[3]]}];
                ] &,
                dir
            ];
        ];
        visit
    ]

isolatedParts[slice_] :=
    If[AllTrue[Flatten[slice], # === 0 &], slice,
    Module[{length = Length[slice],
            width = Length[slice[[1]]],
            height = Length[slice[[1, 1]]],
            visit = slice,
            startIndex, queue},
        If[Count[Flatten[slice], 1] == 0, 1,
            startIndex = Flatten[Table[If[slice[[x, y, z]] == 1, z, Nothing], {z, height}, {x, length}, {y, width}]][[1]];
            queue = Flatten[Table[If[slice[[x, y, startIndex]] == 1,
                                     visit[[x, y, startIndex]] = 0;
                                     {x, y, startIndex},
                                     Nothing],
                            {x, length}, {y, width}], 1];
            bfsConnectedParts[visit, queue]
        ]
    ]]

connectedParts[slice_] := BitXor[slice, isolatedParts[slice]];

connectivity[slice_] := 
    If[AllTrue[Flatten[slice], # === 0 &], 0,
    Module[{length = Length[slice],
            width = Length[slice[[1]]],
            height = Length[slice[[1, 1]]],
            visit = slice,
            startIndex, queue},
        If[Count[Flatten[slice], 1] == 0, 1,
            startIndex = Flatten[Table[If[slice[[x, y, z]] == 1, z, Nothing], {z, height}, {x, length}, {y, width}]][[1]];
            queue = Flatten[Table[If[slice[[x, y, startIndex]] == 1,
                                     visit[[x, y, startIndex]] = 0;
                                     {x, y, startIndex},
                                     Nothing],
                            {x, length}, {y, width}], 1];
            If[Count[Flatten[slice], 1] == 0, 1,
               1 - N[Divide[Count[Flatten[bfsConnectedParts[visit, queue]], 1], Count[Flatten[slice], 1]]]
            ]
        ]
    ]]



optimize[rulesMax_, statesMax_, OptionsPattern[]] := 
  Module[{bitmask, rule=OptionValue["Rule"], infill=OptionValue["Infill"], connectivityTreshold=OptionValue["Connectivity"]},

  bitmask = Switch[OptionValue["Shape"],
    "Prism", prismBitmask[OptionValue["Bounds"]],
    "Sphere", sphereBitmask[OptionValue["Radius"]],
    "Cylinder", cylinderBitmask[OptionValue["Radius"], OptionValue["Height"]],
    "Custom", voxelizer[OptionValue["Mesh"], OptionValue["Resolution"]]
  ];
      
 DistributeDefinitions[newState3D, infillPercentage, connectivity, CenterArray, rule, bitmask, infill, connectivityTreshold];


Flatten[ParallelCombine[
    Function[currRule, 
    Reap[Nest[
      With[
        {test = newState3D[#, bitmask, ReplacePart[rule, 1 -> currRule[[1]]]]},
        If[
          (infill[[1]] == -1 || 
           Abs[infillPercentage[test, bitmask] - infill[[1]]] < infill[[2]]) && 
          (connectivityTreshold == -1 || connectivity[test] > connectivityTreshold),
          Sow[test],
          test
        ]
      ] &, 
      CenterArray[1, Dimensions[bitmask]], 
      statesMax
    ]][[2]]], Range[rule[[1]], rulesMax], Method->"FinestGrained"

],1]]

End[]

EndPackage[]
