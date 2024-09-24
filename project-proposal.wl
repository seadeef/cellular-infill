(* ::Package:: *)

(* ::Title:: *)
(*WELP Project Proposal*)


(* ::Section:: *)
(*Proj-Group-5*)


(* ::Item:: *)
(*Kevin Toren*)


(* ::Item:: *)
(*Ritvik Gupta*)


(* ::Item:: *)
(*Austin Jiang*)


(* ::Item:: *)
(*Mentor: Megan Davis*)


(* ::Section:: *)
(*Project Title: Using cellular automata to optimize 3D printer infill*)


(* ::Subsection:: *)
(*The Problem*)


(* ::Text:: *)
(*Procedurally generating 3D printer infills for arbitrary shapes using cellular automata.*)


(* ::Subsection:: *)
(*How you plan to solve it*)


(* ::Item:: *)
(*Generation -- given a 3D shell and a cellular automata rule, we need to evolve the cellular automata until it creates an infill structure*)


(* ::Subitem:: *)
(*Additive -- start out with one black cell somewhere and see how it evolves*)


(* ::Subitem:: *)
(*Subtractive -- start out with the entire 3D volume filled with black cells and see how the structure deteriorates*)


(* ::Subitem:: *)
(*Boundary condition -- extend the 2D concept of boundary conditions (left --> right vice versa) to a 3D shape so the cellular automata stays bounded within the 3D model*)


(* ::Item:: *)
(*Simulation -- search cellular automata for ideal infill rules*)


(* ::Subitem:: *)
(*Choose a "rule space" to search (4 neighbor/8 neighbor etc.)*)


(* ::Subitem:: *)
(*Either use brute force to search the entire space or use a genetic evolution algorithm to try to cut down on searches*)


(* ::Subitem:: *)
(*For each rule we test, we will use our generation algorithm to fill a shape of our choice (sphere, cube, or combination of multiple shapes) and then test it for strength & material usage*)


(* ::Subsubitem:: *)
(*If compute time is too high for solid body simulation, we could just choose rules based on infill alone (rules that, on average, result in a specific infill density)*)


(* ::Subsubitem:: *)
(*^^^^^ Make this a pre-filter, and then only run the strength simulation on the rules we find *)


(* ::Subsubitem:: *)
(*Compressibility and flexibility for soft materials*)


(* ::Subitem:: *)
(*Record the best rules we find*)


(* ::Item:: *)
(*Export -- using the infill in the real world*)


(* ::Subitem:: *)
(*Make our generation algorithm compatible with 3D model file formats or slicers*)


(* ::Subitem:: *)
(*Take our best candidate rules and create 3D prints with them*)


(* ::Subitem:: *)
(*See how well they compare against traditional infill*)


(* ::Subitem:: *)
(*If we never get to here, we could use our simulation algorithm to still test the rules against traditional infill (just no real world results)*)


(* ::Subsection:: *)
(*Why is this a good fit for you/your team?*)


(* ::Subsection:: *)
(*What data do you need?*)


(* ::Item:: *)
(*evidence that you've found, imported and verified that you have usable data*)


(* ::Subsection:: *)
(*Do you have any code showing your project is viable?*)


(* ::Section:: *)
(*Planning*)


(* ::Subsection:: *)
(*When will you meet with your group? How often? For how long?*)


(* ::Item:: *)
(*We have decided on a meeting time of 5:30 CST every Tuesday*)


(* ::Item:: *)
(*Every second week, our mentor will join us during this meeting to check up on our progress*)


(* ::Subsection:: *)
(*Where are you keeping your task list?*)


(* ::Item:: *)
(*We are using trello to keep track of our tasks https://trello.com/b/S6EvHL8S/welp-planning*)


(* ::Subsection:: *)
(*Outline your Sprints (recommended 3-6)*)


(* ::Subsubsection:: *)
(*Sprint 1*)


(* ::Item:: *)
(*Goals*)


(* ::Subitem:: *)
(*Represent random regular simple prism in Wolfram*)


(* ::Subitem:: *)
(*Figure out a format for representing 3D cellular automata rules in wolfram and calculate its evolution using a 3D matrix (Wolfram built-ins)*)


(* ::Subitem:: *)
(*Display the 3D evolution inside of the 3D model shell*)


(* ::Subitem:: *)
(*Figure out boundary conditions for simple 3D shapes (prisms, cylinder)*)


(* ::Subitem:: *)
(*Combine it all together and create a visualization of an arbitrary CA rule evolving within a simple 3D shell for x amount of steps*)


(* ::Item:: *)
(*How will you judge if you've accomplished the goals?*)


(* ::Subitem:: *)
(*Working visualization within Wolfram (with simple 3D shape and CA evolution)*)


(* ::Subitem:: *)
(*The CA has some sort of internal representation (matrix) that we can use later*)


(* ::Subitem:: *)
(*The CA never evolves outside the bounds of the 3D model and behaves uniformly around the edges*)


(* ::Subitem:: *)
(*We can find some examples of rules which expand to fill the model (like real infill)*)


(* ::Item:: *)
(*Who is responsible for what?*)


(* ::Subitem:: *)
(*Ritvik: Figure out a way to visualize the evolution of a 3D CA (Given a pre-made matrix of cells at each step), change the amount of steps, change the relative size of each cell in space (need an underlying system of measurement and how it relates to each cell), and ideally rotate/zoom/pan*)


(* ::Subitem:: *)
(*Austin + Kevin: Figure out how to evolve 3D cellular automata in Wolfram. Add simple boundary conditions to constrain the shape. Figure out a way to represent 3D CA rules and interpret it with our evolution algorithm. Figure out which type of rules, in general, create desirable results (e.g. complex, organic shapes vs. extremely geometric or sparse shapes)*)


(* ::Subsubsection:: *)
(*Sprint 2*)


(* ::Item:: *)
(*Create basic metrics for the 3D CA (such as percentage infill, percent of the volume being occupied by at least 1 cell, etc.). Also want to be able to take a CA rule and evolve until you get to an infill percentage closest to the target infill. Add metrics for strength/flexibility here*)


(* ::Item:: *)
(*Goals*)


(* ::Subitem:: *)
(*Wolfram functions for structural analysis, specifically flexibility and strength of material (figure out how to represent 3D printed plastics such as ABS, TPU, PLA)*)


(* ::Subitem:: *)
(*How to calculate infill percentage relative to object area*)


(* ::Subitem:: *)
(*Expand to include more complex 3D models (other than simple arbitrary shapes used earlier)*)


(* ::Subitem:: *)
(*Metrics (ranked):*)


(* ::Subsubitem:: *)
(*Infill percentage (ratio of filled space to total volume)*)


(* ::Subsubitem:: *)
(*Spread percentage (percent of the volume with at least one cell inside of it)*)


(* ::Subsubitem:: *)
(*Structural integrity*)


(* ::Subsubitem:: *)
(*Flexibility*)


(* ::Subsubitem:: *)
(*Entropy (Can we measure how "ordered" a CA rule is??)*)


(* ::Item:: *)
(*Judging completeness:*)


(* ::Subitem:: *)
(*Working analysis of any given model - including metric for flexibility, metric for infill percentage (also working visualization of flexibility and distribution of forces on object)*)


(* ::Subitem:: *)
(*Show given CA rule working on complicated 3D models (such as those found in Wolfram functions repository)*)


(* ::Item:: *)
(*Division of responsibilities:*)


(* ::Subitem:: *)
(*Ritvik: flexibility analysis and visualization*)


(* ::Subitem:: *)
(*Austin: infill optimization*)


(* ::Subitem:: *)
(*Kevin: get CA to work on complex 3D models*)


(* ::Subsubsection:: *)
(*Sprint 3*)


(* ::Item:: *)
(*Boundary condition for complex shape (adapt simple boundary condition to work with complex meshes (such as built in Wolfram meshes)*)


(* ::Item:: *)
(*Goals:*)


(* ::Subitem:: *)
(*Develop the boundary condition for an arbitrary 3D shell. *)


(* ::Subitem:: *)
(*Import an STL file and add it to the visualization*)


(* ::Subitem:: *)
(*Catch up on writing*)


(* ::Item:: *)
(*Judging completeness:*)


(* ::Subitem:: *)
(*Boundary condition works for random complex mesh (CA does not evolve past the bounds of the shape)*)


(* ::Subitem:: *)
(*The relative size of the 3D model and the CA grid makes sense*)


(* ::Subitem:: *)
(*Computational essay outline for first two sprints*)


(* ::Item:: *)
(*Division of responsibilities:*)


(* ::Subitem:: *)
(*Ritvik: visualization of imported model*)


(* ::Subitem:: *)
(*Kevin: boundary condition*)


(* ::Subitem:: *)
(*Austin: firming up essay writing up to this point*)


(* ::Subsubsection:: *)
(*Sprint 4*)


(* ::Item:: *)
(*Create the brute-force algorithm and use it to search through a pre-defined rule space. Need to keep track of the best result so far (i.e. one which gets closest to a given infill percentage). Play around with different methods for generating infill (additive vs. subtractive). *)


(* ::Item:: *)
(*Goals:*)


(* ::Subitem:: *)
(*Brute force search for best CA (incorporate genetic optimization or other form of optimization)*)


(* ::Subitem:: *)
(*Show this CA rule on 3D model (both basic and complex shapes)*)


(* ::Subitem:: *)
(*Decide what is the best way to generate infill*)


(* ::Item:: *)
(*Judging completeness:*)


(* ::Subitem:: *)
(*CA rule chosen*)


(* ::Subitem:: *)
(*Multiple example models generated with infill*)


(* ::Item:: *)
(*Division of responsibilities*)


(* ::Subitem:: *)
(*Ritvik + Austin: brute force algorithms for CA rule *)


(* ::Subitem:: *)
(*Kevin: figure out best way of generating infill, generate example models*)


(* ::Subsubsection:: *)
(*Sprint 5*)


(* ::Item:: *)
(*Take a CA-generated infill and figure out how to export into a slicer for 3D printing. During this time we could also be running the algorithm to find good candidate rules*)


(* ::Item:: *)
(*Goals:*)


(* ::Subitem:: *)
(*Take the CA-generated infill (which we've been developing in prior sprints) and figure out how to export it into a slicer software that is used for 3D printing.*)


(* ::Subitem:: *)
(*Simultaneously, start running the algorithm to identify good candidate rules for specific infill parameters, such as flexibility or strength.*)


(* ::Item:: *)
(*Judging completeness:*)


(* ::Subitem:: *)
(*Successfully export a CA-generated infill pattern into a slicer format like G-code, STL, or similar.*)


(* ::Subitem:: *)
(*A set of candidate rules that demonstrate potential in terms of specific metrics (flexibility, strength, etc.) generated from the brute-force algorithm.*)


(* ::Item:: *)
(*Division of responsibilities:*)


(* ::Subitem:: *)
(*Ritvik: Work on the integration between Wolfram and common slicer software, figuring out how to export CA-generated structures into slicer-compatible formats.*)


(* ::Subitem:: *)
(*Austin: create an algorithm to search for candidate CA rules that generate infill patterns optimized for various metrics (flexibility, strength, etc.).*)


(* ::Subitem:: *)
(*Kevin: Test the exported models in slicer software to ensure accuracy and compatibility for 3D printing.*)


(* ::Subsubsection:: *)
(*Sprint 6*)


(* ::Item:: *)
(*Create the entire interface (automatic importing, infill generation, visualization, rule selection based on desired parameters, and export). We would also make actual 3D prints here and test against established infill patterns*)


(* ::Item:: *)
(*Goals:*)


(* ::Subitem:: *)
(*Develop the full interface to automate the infill generation workflow. This includes automatic import of 3D models, generation of CA-based infills, visualization, rule selection based on parameters (e.g., infill percentage, flexibility, etc.), and final export for 3D printing.*)


(* ::Subitem:: *)
(*Begin actual 3D printing of generated infills and perform real-world testing, comparing them with established infill patterns from standard slicers.*)


(* ::Item:: *)
(*Judging completeness:*)


(* ::Subitem:: *)
(*Fully functional interface that allows for seamless import, infill generation, and export of the final infill pattern for 3D printing.*)


(* ::Subitem:: *)
(*Multiple 3D prints of CA-generated infills that are compared against traditional infill patterns in terms of strength, flexibility, and other metrics.*)


(* ::Subitem:: *)
(*Documented results from the physical testing of 3D-printed models, with comparisons to benchmark infill patterns.*)


(* ::Item:: *)
(*Division of responsibilities:*)


(* ::Subitem:: *)
(*Ritvik: Finalize the interface design, ensuring that all steps (from model import to export) are streamlined and user-friendly.*)


(* ::Subitem:: *)
(*Austin: Handle rule selection algorithms and ensure they function efficiently with real-world models. Also assist with interpreting the 3D print results for final optimization (My school has some free 3D printers so I can help as well).*)


(* ::Subitem:: *)
(*Kevin: Oversee 3D printing of the CA-generated infills and perform physical tests (flexibility, strength, etc.) to gather data for comparison against standard infill patterns.*)
