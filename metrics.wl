BeginPackage["metrics`"]

InfillPercentage::usage = "InfillPercentage[slice, shape] gives the ratio of filled cells to possible cells within the shape";

Begin["`Private`"]

InfillPercentage[slice_,shape_]:=Divide[Count[Flatten[slice],1],Count[Flatten[shape],1]]
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
