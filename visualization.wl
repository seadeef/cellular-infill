(* ::Package:: *)

Graphics3D[
	Cuboid/@RotateLeft/@ - 
	Position[CellularAutomaton[<|"Dimension"->2, "Neighborhood"->5, "OuterTotalisticCode"->942|>, CenterArray[{{1}}, (100 + 3) {1, 1}], 50], 1]
]
