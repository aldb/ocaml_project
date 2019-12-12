open Gfile
open Usecasefile
open Tools
open FfAlgorithm
open AlgoBusackerGowen

let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 6 then
    begin
      Printf.printf "\nUsage: %s [f|b] infile source sink outfile | u infile max_eleve 0 outfile \n\n%!" Sys.argv.(0) ;
      exit 0
    end ;


  (* Arguments are : programme(1) infile(2) source-id(3)|max_eleve sink-id(4) outfile(5) *)

  let prog= Sys.argv.(1)
  and infile = Sys.argv.(2)
  and outfile = Sys.argv.(5)

  and _source = int_of_string Sys.argv.(3) (* max eleve pour usecase problem *)
  and _sink = int_of_string Sys.argv.(4)
  in



  (* get for dislplay algorithm *)

  let get_rgr_b string_graph id_source id_destination= 
    match busacker_gowen string_graph  id_source id_destination with 
    |(rgr,_,_)-> rgr
  in 

  let get_max_cost string_graph id_source id_destination= 
    match busacker_gowen string_graph  id_source id_destination with 
    |(_,_,max_cost)-> max_cost
  in

  let get_max_flow string_graph id_source id_destination= 
    match ff_algo string_graph  id_source id_destination with 
    |(_,max_flow)-> max_flow
  in

  let get_rgr_f string_graph id_source id_destination= 
    match ff_algo string_graph  id_source id_destination with 
    |(rgr,max_flow)-> rgr
  in 

  match  prog with
  |"f"->
    begin 
      (* Open file *)
      let graph = Gfile.from_file infile 
      in

      Printf.printf "\nFlow Max: %s \n%!" (string_of_int  ( get_max_flow graph _source _sink)) ;

      let graph_flow= flow_of_residual graph (get_rgr_f graph _source _sink)
      in

      let () = export outfile graph_flow in 
      ()
    end 
  |"b"->
    begin
      (* Open file *)
      let graph = Gfile.from_file infile 
      in
      Printf.printf "\nCost: %s \n%!" (string_of_int  ( get_max_cost graph _source _sink)) ;

      let graph_weight= weight_of_residual graph (get_rgr_b graph _source _sink)
      in

      let () = export outfile graph_weight in 
      ()
    end 
  |"u"->
    begin
      (* Open file *)
      let graph = Usecasefile.from_file  _source infile (* _source= max_e *)
      in

      Printf.printf "\nCost: %s \n%!" (string_of_int  ( get_max_cost graph 0 (max_int-1))) ;

      let graph_weight= weight_of_residual graph (get_rgr_b graph 0 (max_int-1))
      in

      let () = Usecasefile.write_file outfile graph_weight in 
      ()
    end

  |_->assert false

;;

