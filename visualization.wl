(* ::Package:: *)

visualize3DMatrix[matrix3D_] := Module[{cubes, xLayers, yLayers, zLayers},
  
  {xMax, yMax, zMax} = {Length[matrix3D], Length[matrix3D[[1]]], Length[matrix3D[[1, 1]]]};
  
  Manipulate[
    Module[{slicedCubes},
      slicedCubes = Flatten[
        Table[
          If[matrix3D[[i, j, k]] == 1 && 
            (i <= xLayers) && 
            (j <= yLayers) && 
            (k <= zLayers), 
            Cuboid[{i - 1, j - 1, k - 1}], Nothing], 
          {i, 1, xMax}, 
          {j, 1, yMax}, 
          {k, 1, zMax}
        ]
      ];
      
      Graphics3D[{Opacity[0.6], Blue, slicedCubes}, 
        Boxed -> False, 
        Axes -> True, 
        AxesOrigin -> {0, 0, 0}, 
        AxesLabel -> {"X", "Y", "Z"}, 
        PlotRange -> All]
    ],
    {xLayers, 1, xMax, 1, Appearance -> "Labeled"},
    {yLayers, 1, yMax, 1, Appearance -> "Labeled"},
    {zLayers, 1, zMax, 1, Appearance -> "Labeled"},
    ControlPlacement -> Top,
    Initialization :> {xLayers = xMax; yLayers = yMax; zLayers = zMax}
  ]
]



(* example usage for cellular automata visualization *)

randomInitialState[x_, y_, z_] := RandomInteger[{0, 1}, {x, y, z}]

nextState3D[currentState_] := Module[{newState, neighbors, xMax, yMax, zMax},
  {xMax, yMax, zMax} = Dimensions[currentState];
  newState = currentState;

  Do[
    Module[{aliveNeighbors = 0},
      aliveNeighbors = Total[
        Table[
          If[
            (i + dx >= 1 && i + dx <= xMax) && 
            (j + dy >= 1 && j + dy <= yMax) && 
            (k + dz >= 1 && k + dz <= zMax) && 
            {dx, dy, dz} != {0, 0, 0, 0},
            currentState[[i + dx, j + dy, k + dz]],
            0
          ],
          {dx, -1, 1}, {dy, -1, 1}, {dz, -1, 1}
        ]
      ];

      If[currentState[[i, j, k]] == 1,
        newState[[i, j, k]] = If[aliveNeighbors == 2 || aliveNeighbors == 3, 1, 0];
        ,
        newState[[i, j, k]] = If[aliveNeighbors == 3, 1, 0];
      ];
    ], {i, 1, xMax}, {j, 1, yMax}, {k, 1, zMax}];
  
  newState
]

runCellularAutomaton[iterations_, x_, y_, z_] := 
 Module[{currentState, states},
  currentState = randomInitialState[x, y, z];
  states = {currentState};
  
  Do[
   currentState = nextState3D[currentState];
   AppendTo[states, currentState];
   , {iterations}];
  
  states
]

matrix3D = runCellularAutomaton[5, 10, 10, 10][[1]];
visualize3DMatrix[matrix3D]
