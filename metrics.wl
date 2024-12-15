(* ::Package:: *)

BeginPackage["metrics`"]
Needs["CAgeneration`"]

InfillPercentage::usage = 
    "InfillPercentage[slice, shape] gives the ratio of filled cells to possible cells within the shape";
BFSConnectedParts::usage = 
    "BFSConnectedParts[vis, q] uses BFS to toggle all cells in vis that connect to source cells in q";
IsolatedParts::usage = 
    "IsolatedParts[slice] gives a slice that only contains cells isolated from the bottom";
Connectivity::usage = 
    "Connectivity[slice] gives the ratio of isolated cells in slice";
Optimize::usage = "Optimize[rulesMax, statesMax] searches rulesMax many rules for statesMax many states \
to find candidates within Infill[[2]] range of Infill[[1]] and above the Connectivity threshold. \
Has the same options as visualize3DMatrix for describing the rule and shape";

Begin["`Private`"]

Options[Optimize] = {"Infill"->-1, "Connectivity"->-1, "Shape"->"Prism", "Bounds"->{0,0,0}, "Radius"->0, "Height"->0, "Rule"-> {14, {2, 1}, {1, 1, 1}}};

InfillPercentage[slice_, shape_] := 
    N[Divide[Count[Flatten[slice], 1], Count[Flatten[shape], 1]]]

BFSConnectedParts[vis_, q_] := 
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

IsolatedParts[slice_] :=
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
            BFSConnectedParts[visit, queue]
        ]
    ]]

Connectivity[slice_] := 
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
               1 - N[Divide[Count[Flatten[BFSConnectedParts[visit, queue]], 1], Count[Flatten[slice], 1]]]
            ]
        ]
    ]]

Optimize[rulesMax_, statesMax_, OptionsPattern[]] := 
  Module[{bitmask, rule=OptionValue["Rule"], infill=OptionValue["Infill"], connectivity=OptionValue["Connectivity"]},

  bitmask = Switch[OptionValue["Shape"],
    "Prism", ConstantArray[1, OptionValue["Bounds"]],
    "Sphere", Module[{r=OptionValue["Radius"]}, Table[If[Norm[{x, y, z}]<=r,1,0],{x,-r,r},{y,-r,r},{z,-r,r}]],
    "Cylinder", Module[{r=OptionValue["Radius"], h=OptionValue["Height"]}, Table[If[Norm[{x, y}]<=r,1,0],{x,-r,r},{y,-r,r},{z,0,h}]]
  ];

  Flatten[Reap[Table[
  Nest[With[{test = 
       newState3D[#, bitmask, ReplacePart[rule, 1 -> currRule]]}, 
     If[(infill[[1]] == -1 || 
         Abs[InfillPercentage[test, bitmask] - infill[[1]]] < 
          infill[[2]]) && (connectivity == -1 || 
         Connectivity[test] > connectivity), Sow[test], test]] &, 
   CenterArray[1, Dimensions[bitmask]], statesMax], {currRule, 0, rulesMax}]][[2]], 1]
]

End[]

EndPackage[]

