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


newState3D[currentState_,shape_:Null,rule_:{22,{2,1},{1,1,1}}]:=Module[{},newState=CellularAutomaton[rule,currentState];newState[[1;;-1,1]]=newState[[1;;-1,-2]];
newState[[1;;-1,-1]]=newState[[1;;-1,2]];
newState[[1]]=newState[[-2]];
newState[[-1]]=newState[[2]];
newState[[1;;-1,1;;-1,1]]=newState[[1;;-1,1;;-1,-2]];
newState[[1;;-1,1;;-1,-1]]=newState[[1;;-1,1;;-1,2]];
If[MatchQ[shape,Null],newState,BitAnd[newState,shape]]
]
visualize3DMatrix[slices_]:=
Module[{cubes,xLayers,yLayers,zLayers},{xMax,yMax,zMax,slicesMax}={Length[slices[[1]]],Length[slices[[1]][[1]]],Length[slices[[1]][[1,1]]],Length[slices]};
Manipulate[Module[{slicedCubes},slicedCubes=Flatten[Table[If[slices[[s]][[i,j,k]]==1&&(i<=xLayers)&&(j<=yLayers)&&(k<=zLayers),Cuboid[{i-1,j-1,k-1}],Nothing],{i,1,xMax},{j,1,yMax},{k,1,zMax}]];
Graphics3D[{Opacity[0.6],Blue,slicedCubes},Boxed->False,Axes->True,AxesOrigin->{0,0,0},AxesLabel->{"x","y","z"},PlotRange->{{0,xMax},{0,yMax},{0,zMax}}]],{{xLayers,xMax,"x Layers"},1,xMax,1,Appearance->"Labeled"},{{yLayers,yMax,"y Layers"},1,yMax,1,Appearance->"Labeled"},{{zLayers,zMax,"z Layers"},1,zMax,1,Appearance->"Labeled"},{{s,1,"Slice"},1,slicesMax,1,Appearance->"Labeled"},ControlPlacement->Top,Initialization:>{xLayers=xMax;yLayers=yMax;zLayers=zMax}]]

(*example of adding shape boundary for the CA*)
width=20;
height=20;
depth=20;
radius=8;
cylinderHeight=15;
sphere=Table[If[Norm[{x-width/2,y-height/2,z-depth/2}]<=radius,1,0],{x,1,width},{y,1,depth},{z,1,height}];
cylinder=Table[If[Norm[{x-width/2,y-height/2}]<=radius&&z<=cylinderHeight,1,0],{x,1,width},{y,1,depth},{z,1,height}];
visualize3DMatrix[NestList[newState3D[#,sphere,{30,{2,1},{1,1,1}}]&,CenterArray[1,{20,20,20}],12]]
visualize3DMatrix[NestList[newState3D[#,cylinder,{50,{2,1},{1,1,1}}]&,CenterArray[1,{20,20,20}],12]]


NewState3D[currentState_,shape_:Null,rule_:{22,{2,1},{1,1,1}}]:=Module[{},newState=CellularAutomaton[rule,currentState];
If[MatchQ[shape,Null],newState,BitAnd[newState,shape]]
]
InfillPercentage[slice_,shape_]:=Divide[Count[Flatten[slice],1],Count[Flatten[shape],1]]
SpreadCount[array_]:=Module[
{
paddedArray=ArrayPad[array,1,0],
dir={{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}},
count=0
},
Table[If[array[[i,j,k]]==1&&
Count[Map[paddedArray[[Sequence@@({i,j,k}+{1,1,1}+#)]]&,dir],1]>0
,count++,Null],
{i,Length[array]},{j,Length[array[[1]]]},{k,Length[array[[1,1]]]}];
count
]
SpreadPercentage[slice_]:=If[Count[Flatten[slice],1]>0,Divide[SpreadCount[slice],Count[Flatten[slice],1]],0]
Visualize3DMatrix[slices_,shape_]:=Module[{cubes,xLayers,yLayers,zLayers},{xMax,yMax,zMax,slicesMax}={Length[slices[[1]]],Length[slices[[1]][[1]]],Length[slices[[1]][[1,1]]],Length[slices]};
Manipulate[
Column[{
Module[{slicedCubes},slicedCubes=Flatten[Table[If[slices[[s]][[i,j,k]]==1&&(i<=xLayers)&&(j<=yLayers)&&(k<=zLayers),Cuboid[{i-1,j-1,k-1}],Nothing],{i,1,xMax},{j,1,yMax},{k,1,zMax}]];
Graphics3D[{Opacity[0.6],Blue,slicedCubes},Boxed->False,Axes->True,AxesOrigin->{0,0,0},AxesLabel->{"x","y","z"},PlotRange->{{0,xMax},{0,yMax},{0,zMax}}]],
Row[{"%Infill: ",Style[Dynamic[NumberForm[N[InfillPercentage[slices[[s]],shape]*100],{4,2},NumberPadding->{"","0"}]],Bold]}],
Row[{"%Spread: ",Style[Dynamic[NumberForm[N[SpreadPercentage[slices[[s]]]*100],{4,2},NumberPadding->{"","0"}]],Bold]}]
	}],
{{xLayers,xMax,"x Layers"},1,xMax,1,Appearance->"Labeled"},
{{yLayers,yMax,"y Layers"},1,yMax,1,Appearance->"Labeled"},
{{zLayers,zMax,"z Layers"},1,zMax,1,Appearance->"Labeled"},
{{s,1,"Slice"},1,slicesMax,1,Appearance->"Labeled"},ControlPlacement->Top,Initialization:>{xLayers=xMax;yLayers=yMax;zLayers=zMax}
]
]
width=20;
height=20;
depth=20;
radius=8;
cylinderHeight=15;
sphere=Table[If[Norm[{x-width/2,y-height/2,z-depth/2}]<=radius,1,0],{x,1,width},{y,1,depth},{z,1,height}];
cylinder=Table[If[Norm[{x-width/2,y-height/2}]<=radius&&z<=cylinderHeight,1,0],{x,1,width},{y,1,depth},{z,1,height}];
Visualize3DMatrix[NestList[NewState3D[#,sphere,{30,{2,1},{1,1,1}}]&,CenterArray[1,{20,20,20}],15],sphere]
