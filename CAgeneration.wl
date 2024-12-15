BeginPackage["CAgeneration`"];

newState3D::usage = "newState3D[state, bitmask, rule] takes a 3D matrix \
of cell states and returns the next evolution with the given rule. \
Assumes a periodic boundary in the shape of a rectangular prism. A \
bitmask matrix can be specified in order to cut off parts of the grid \
that are not contained within the volume."

Begin["`Private`"]
newState3D[currentState_, bitmask_, 
   rule_] := 
  Module[{}, newState = CellularAutomaton[rule, currentState]; 
   newState[[1 ;; -1, 1]] = newState[[1 ;; -1, -2]];
   newState[[1 ;; -1, -1]] = newState[[1 ;; -1, 2]];
   newState[[1]] = newState[[-2]];
   newState[[-1]] = newState[[2]];
   newState[[1 ;; -1, 1 ;; -1, 1]] = 
    newState[[1 ;; -1, 1 ;; -1, -2]];
   newState[[1 ;; -1, 1 ;; -1, -1]] = 
    newState[[1 ;; -1, 1 ;; -1, 2]];
   BitAnd[newState, bitmask]
   ];

End[]

EndPackage[]