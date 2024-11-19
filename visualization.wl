(* ::Package:: *)

BeginPackage["visualization`"];
Needs["CAgeneration`"];
Needs["metrics`"];


visualize3DMatrix::usage = "visualize3DMatrix[slices, shape] takes a list of 3D evolution states and displays them visually within the given shape" 

Begin["Private`"]

Visualize3DMatrix[slices_,shape_]:=Module[{
cubes,xLayers,yLayers,zLayers,displayMode,
displaySlices={slices,Map[IsolatedParts,slices]}
},
{xMax,yMax,zMax,slicesMax}={Length[slices[[1]]],Length[slices[[1]][[1]]],Length[slices[[1]][[1,1]]],Length[slices]};
Manipulate[
Column[{
Magnify[Module[{slicedCubes},slicedCubes=Flatten[Table[If[displaySlices[[displayMode]][[s]][[i,j,k]]==1&&(i<=xLayers)&&(j<=yLayers)&&(k<=zLayers),Cuboid[{i-1,j-1,k-1}],Nothing],{i,1,xMax},{j,1,yMax},{k,1,zMax}]];
Graphics3D[{Opacity[0.8],Blue,slicedCubes},Boxed->False,Axes->True,AxesOrigin->{0,0,0},AxesLabel->{"x","y","z"},PlotRange->{{0,xMax},{0,yMax},{0,zMax}}]],1.5],
Row[{"Infill: ",Style[ToString[NumberForm[InfillPercentage[slices[[s]],shape]*100,{4,2},NumberPadding->{"","0"}]]<>"%",Bold]}],
Row[{"Connectivity: ",Style[ToString[NumberForm[Connectivity[slices[[s]]]*100,{4,2},NumberPadding->{"","0"}]]<>"%",Bold]}]
	}],
{{xLayers,xMax,"Layer X"},1,xMax,1,Appearance->"Labeled"},
{{yLayers,yMax,"Layer Y"},1,yMax,1,Appearance->"Labeled"},
{{zLayers,zMax,"Layer Z"},1,zMax,1,Appearance->"Labeled"},
{{s,1,"Slice"},1,slicesMax,1,Appearance->"Labeled"},
{{displayMode,1,"Display Mode"},{1->"Regular",2->"Isolated Parts"}},
ControlPlacement->Top,Initialization:>{xLayers=xMax;yLayers=yMax;zLayers=zMax}
]
]

End[]

EndPackage[]
