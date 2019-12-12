open Graph

let clone_nodes gr =  n_fold gr  new_node empty_graph   ;;

let gmap gr f= e_fold gr (fun graphe id1 id2 lab-> new_arc graphe id1 id2 (f lab)) (clone_nodes gr)  ;;

let add_arc g id1 id2 n= match (find_arc g id1 id2) with
  |None-> new_arc g id1 id2 n 
  |Some lab -> new_arc g id1 id2 (n+lab);;

let rec update_flow_general rgr maxi ajouter = function
  |[]-> rgr
  |[id]-> rgr
  |id1::id2::rest->  update_flow_general (ajouter (ajouter rgr id1 id2 (-maxi)) id2 id1 maxi) maxi ajouter (id2::rest) ;;

let delta_flow_general gr path f = 
  let rec auxi gr path maxi= 
    match path with  
    |[]-> maxi
    |[id]-> maxi
    |id1::id2::rest-> begin match (find_arc gr id1 id2 ) with 
        |Some lab -> auxi gr (id2::rest) (min maxi (f lab)) 
        |None-> assert false end   
  in auxi gr path max_int;;