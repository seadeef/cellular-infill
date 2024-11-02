Needs["CAgeneration`"];
Needs["metrics`"];
Needs["shapes`"];
Needs["visualization`"];

bounds = {16, 16, 16};
shape = sphere[8, bounds];
visualize3DMatrix[NestList[newState3D[#, shape, {14, {2, 1}, {1, 1, 1}}] &, CenterArray[1, bounds], 24], shape]
