open Graph
open Tools

(*Cette fonction prend un string graphe et retourne un int graphe *)
let get_capacity_graph gr= gmap gr int_of_string ;;




(*Met le graph de capacité sous forme de grahe de residuel*)
let residual_of_capacity gr =
  e_fold gr (fun graphe id1 id2 (capacity)-> new_arc (new_arc graphe id1 id2 capacity) id2 id1 0) (clone_nodes gr);;

(*Parcours en profondeur: prend un graphe residuel en entrée *)
let dfs gr id_source id_destination = 
  let rec explore gr id_source id_destination noeuds_marques =function
    |[]-> None
    |(id2,(flow))::rest->
      (*Si le flow est égale à zero on ignore cette arc est on regarde un autre*)
      (*Si le noeud est déja marqué on continue à regarder les autres noeuds fils*)
      if (List.exists (fun x-> x=id2) noeuds_marques || flow=0 ) 
      then explore gr id_source id_destination noeuds_marques rest
      (*Si le noeud fils est le noeud destination alors on a trouvé notre chemin*) 
      else if id2=id_destination then Some (id_source::[id_destination])
      (*Sinon ce noeud fait partie du chemin on continue l'exploration*)
      else 
        match (explore gr id2 id_destination (id2::noeuds_marques) (out_arcs gr id2)) with
        |None -> explore gr id_source id_destination noeuds_marques  rest 
        |Some p -> Some (id_source::p)
  in explore gr id_source id_destination [id_source]  (out_arcs gr id_source);;


let min a b  = match a < b with 
  |true-> a
  |false-> b;;

(*Donne le flow max pouvant circuler sur un chemin donné par le graphe residuel*)
let delta_flow gr path = delta_flow_general gr path (fun x-> x)  ;;

(*Met à jour le graph residuel grace au delta_flow trouvé*)
let rec update_flow rgr maxi path = update_flow_general rgr maxi add_arc path  ;;

(*L'algorithme de ford fulkerson implémenté*)

let ff_algo gr id_source id_destination= 
  let rgr = residual_of_capacity (get_capacity_graph gr)
  in 
  let rec loop gr rgr id_source id_destination max_flow=
    match dfs rgr id_source id_destination with 
    (*Il n'y a plus de chemin qui permette d'aumenter le flow: on retourne la solution*)
    |None-> (rgr,max_flow)
    (*On cheche un chemin sur le graph residuel mis à jour*)
    |Some path-> begin 
        let flow= (delta_flow rgr path) in 
        loop gr (update_flow rgr flow path) id_source id_destination  (max_flow+flow) end 

  in loop gr rgr id_source id_destination 0;;    


(*Cette fonction prend le gr d'origine et donne le graph de flow apres application de ff*)
let flow_of_residual gr rgr=   

  e_fold gr 
    (fun graphe id1 id2 capacity-> match find_arc rgr id2 id1 with 
       |None-> assert false  
       |Some flow -> new_arc graphe id1 id2 (string_of_int(flow)^"/"^capacity)) 
    (clone_nodes gr);;
