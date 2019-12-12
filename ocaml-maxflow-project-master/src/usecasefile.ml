open Graph
open Printf
open String

type path = string
(* Format of usecase projet tutoré files:
   % This is a comment
   % Lucie=1 Sophie=2 ... Adeline=n, Projetx= n+1....Projety=z
   % Le nombre maximal d'élève par projet est fixé à 6
   % declarer un eleve: e n°e de 1 à n
    e 1
    e 2
    e 3
   %declarer les projet: p n°p de n à z
    p 4
    p 5
    p 6
   %declarer les voeux: v n°e n°p 1_n°v   
    v 0 0 1_1
    v 0 0 1_2
*)

(* Format of usecase bipartie matching:
   % This is a comment
   % Lucie=1 Sophie=2 ... Adeline=n, hotex= n+1....hotey=z
   % declarer un invite: e n°e de 1 à n
    e 1
    e 2
    e 3
   %declarer les hote: p n°p de n à z
    p 4
    p 5
    p 6
   %declarer les affinité: v n°e n°p 1_0
    v 0 1_0
    v 0 1_0
*)

let write_file path graph =

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "%% This the result matching .\n\n" ;


  let rec loop id1 outarc=
    begin match outarc with
      |[]-> fprintf ff " %d did'not found a match \n" id1 ;
      |(id2,strlab)::rest-> 
        let flow= match (split_on_char '/' strlab) with 
          |str1::str2::rest-> (int_of_string str1)
          |_::[]|[]-> assert false 
        in

        if flow=1 then 
          fprintf ff "%d match with %d\n" id1 id2 
        else loop id1 rest end
  in

  let rec noeud l  =  
    match l with 
    |[]-> []
    |(id1,_)::rest-> id1::noeud rest
  in

  let rec go l= match l with
    |[]->fprintf ff "\n%% End of matching\n" 
    |id::rest-> loop id (out_arcs graph id); go rest in
  go (noeud (out_arcs graph 0)) ;
  close_out ff ;
  ()

(* Reads a line with a student: create a node dans link it to the source  *)
let read_node_e  graph line =
  try Scanf.sscanf line "e %d " (fun id -> let new_graph= new_node graph id in new_arc new_graph 0 id "1_0"  )
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"
(* Reads a line with a project: create a node and link it to the sink  *)
let read_node_p max_e graph line =
  try Scanf.sscanf line "p %d " (fun id -> let new_graph= new_node graph id in new_arc new_graph id (max_int-1) (string_of_int(max_e)^"_0")  )
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a line with an arc. *)
let read_arc graph line =
  try Scanf.sscanf line "v %d %d %s" (fun id1 id2 label -> new_arc graph id1 id2 label)
  with e ->
    Printf.printf "Cannot read arc in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a comment or fail. *)
let read_comment graph line =
  try Scanf.sscanf line " %%" graph
  with _ ->
    Printf.printf "Unknown line:\n%s\n%!" line ;
    failwith "from_file"

let from_file max_e path =

  let infile = open_in path in

  (* Read all lines until end of file. 
   * n is the current node counter. *)
  let rec loop n graph =
    try
      let line = input_line infile in

      (* Remove leading and trailing spaces. *)
      let line = String.trim line in

      let (n2, graph2) =
        (* Ignore empty lines *)
        if line = "" then (n, graph)

        (* The first character of a line determines its content : n or e. *)
        else 

          match line.[0] with
          | 'e' -> (n+1, read_node_e  graph line)
          | 'p' -> (n+1, read_node_p max_e graph line)
          | 'v' -> (n, read_arc graph line)

          (* It should be a comment, otherwise we complain. *)
          | _ -> (n, read_comment graph line)
      in      
      loop n2 graph2

    with End_of_file -> graph (* Done *)
  in

  let final_graph = loop 0 (new_node  (new_node empty_graph 0) (max_int-1)) in

  close_in infile ;
  final_graph

