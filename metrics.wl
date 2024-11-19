(* ::Package:: *)

BeginPackage["metrics`"]

InfillPercentage::usage = "InfillPercentage[slice, shape] gives the ratio of filled cells to possible cells within the shape";
BFSConnectedParts::usage = "BFSConnectedParts[vis, q] uses BFS to toggle all cells in vis that connect to source cells in q";
IsolatedParts::usage = "IsolatedParts[slice] gives a slice that only contain cells isolated from the bottom";
Connectivity::usage = "Connectivity[slice] gives the ratio of isolated cells in slice";

Begin["`Private`"]

InfillPercentage[slice_,shape_]:=N[Divide[Count[Flatten[slice],1],Count[Flatten[shape],1]]]

BFSConnectedParts[vis_,q_]:=Module[{
dir={{0,0,1},{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{1,1,0},{1,-1,0},{-1,1,0},{-1,-1,0}},
visit=vis,
queue=q,
length=Length[vis],
width=Length[vis[[1]]],
height=Length[vis[[1,1]]],
pos=1,cur
},
While[pos<=Length[queue],
cur=queue[[pos]];
pos++;
Map[
If[cur[[1]]+#[[1]]>=1&&
cur[[1]]+#[[1]]<=length&&
cur[[2]]+#[[2]]>=1&&
cur[[2]]+#[[2]]<=width&&
cur[[3]]+#[[3]]<=height&&
visit[[cur[[1]]+#[[1]],cur[[2]]+#[[2]],cur[[3]]+#[[3]]]]==1,
visit[[cur[[1]]+#[[1]],cur[[2]]+#[[2]],cur[[3]]+#[[3]]]]=0;
AppendTo[queue,{cur[[1]]+#[[1]],cur[[2]]+#[[2]],cur[[3]]+#[[3]]}];
]&
,dir]
];
visit
]
IsolatedParts[slice_]:=Module[{
length=Length[slice],
width=Length[slice[[1]]],
height=Length[slice[[1,1]]],
visit=slice,
startIndex,queue
},
If[Count[Flatten[slice],1]==0,True,
startIndex=Flatten[Table[If[slice[[x,y,z]]==1,z,Nothing],{z,height},{x,length},{y,width}]][[1]];
queue=Flatten[Table[If[slice[[x,y,startIndex]]==1,
visit[[x,y,startIndex]]=0;{x,y,startIndex},
Nothing],{x,length},{y,width}],1];
BFSConnectedParts[visit,queue]
]
]
Connectivity[slice_]:=Module[{
length=Length[slice],
width=Length[slice[[1]]],
height=Length[slice[[1,1]]],
visit=slice,
startIndex,queue
},
If[Count[Flatten[slice],1]==0,1,
startIndex=Flatten[Table[If[slice[[x,y,z]]==1,z,Nothing],{z,height},{x,length},{y,width}]][[1]];
queue=Flatten[Table[If[slice[[x,y,startIndex]]==1,
visit[[x,y,startIndex]]=0;{x,y,startIndex},
Nothing],{x,length},{y,width}],1];
If[Count[Flatten[visit],1]==0,1,
1-N[Divide[Count[Flatten[BFSConnectedParts[visit,queue]],1],Count[Flatten[visit],1]]]]
]
]
End[]

EndPackage[]
(*
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
*)
