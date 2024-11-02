BeginPackage["shapes`"];

sphere::usage = "sphere[radius] represents a sphere with specified radius"
cylinder::usage = "cylinder[height] represents a cylinder with specified height"

Begin["`Private`"]

sphere[radius_, bounds_]:=Module[{width=bounds[[1]], depth=bounds[[2]], height=bounds[[3]]},
    Table[If[Norm[{x-width/2,y-height/2,z-depth/2}]<=radius,1,0],{x,1,width},{y,1,depth},{z,1,height}]
];

cylinder[radius_, cylinderHeight_, bounds_]:=Module[{width=bounds[[1]], depth=bounds[[2]], height=bounds[[3]]},
    Table[If[Norm[{x-width/2,y-height/2}]<=radius&&z<=cylinderHeight,1,0],{x,1,width},{y,1,depth},{z,1,height}]
];

End[]
EndPackage[]