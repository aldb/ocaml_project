open Graph
open Tools
open String



(*Cette fonction prend un string graphe et retourne un (int*int) graphe *)
let get_weight_graph string_gr= 
  gmap string_gr 
    (fun str-> match (split_on_char '_' str) with 
       |str1::str2::rest->((int_of_string str1),(int_of_string str2 ))
       |_::[]|[]-> assert false )
;;

(*cette fonction prend un (int*int) graphe est le met sous sa forme residuel *)

let residual_of_weight gr = 
  e_fold gr (fun graphe id1 id2 (capacity, weight)-> new_arc (new_arc graphe id1 id2 (capacity,weight)) id2 id1 (0,-weight)) (clone_nodes gr);;
(*cette fonction, recherche d'un chemin de cout minimal et de flow non null on supposera que le graphe ne contient pas de cycle negatif*)

let belman_ford rg id_src id_dest=
  (*On initialise tout les coup des noeud du graphe à max_int et on donne le noeud max_int par default sauf le sommet dont le coup est 0 et pere lui meme*)
  let hashtbl = Hashtbl.create 50 in
  n_iter rg (fun n-> Hashtbl.add hashtbl n (max_int,max_int));
  Hashtbl.replace hashtbl id_src (0,id_src);

  (*explore permet de mettre à jour la table hachage *)
  let rec explore id_src visite =function
    |[]-> ()
    |(id,(flow,weight))::rest->
      (*Si le flow est égale à zero on ignore cette arc est on regarde un autre*)
      if flow=0 then
        explore id_src visite rest
      else
        let (father_cost,_)= Hashtbl.find hashtbl id_src in
        let update =
          begin
            let (cost,father)=Hashtbl.find hashtbl id in 
            if cost > father_cost+weight then
              (*le cout du noeud et sont predécesseur sont mis à jour*)
              let _ =Hashtbl.replace hashtbl id ((father_cost+weight),id_src) in
              true
            else false 
          end
        in  
        (*Si le noeud n'est pas visité ou si il a été modifier on doit continuer avec ce noeud et on continue avec le reste*)
        if (not (List.exists (fun x-> x=id) visite) )|| update then 
          let _= explore id (id::visite) (out_arcs rg id) in
          explore id_src (id::visite) rest 
        else 
          explore id_src (id::visite) rest
  in 

  (*On met à jour la table de hachage*)
  let _ =explore id_src  [] (out_arcs rg id_src) in
  (*à partir de la table on trouve le chemin de cout minimum avec un flow non nul entre le noeud source et destination*)
  let rec new_path path id_start id_src= 
    if id_start=id_src then
      (* on a trouver le chemin on l'ajoute au chemin*)
      (id_src::path)
    else
      let (c, father) = Hashtbl.find hashtbl id_start in
      if father=max_int then
        [] 
      else 
        new_path (id_start::path) father id_src 
  in 

  (*La table contient le cout minimum pour aller à la destination*)
  let (z,_) = Hashtbl.find hashtbl id_dest in
  (*Si aucun chemin: None sinon Some(chemin,cout)*)
  match new_path [] id_dest id_src with
  |[]->None
  |path-> Some (path,z)   ;;

(*Donne le flow max pouvant circuler sur un chemin donné par le graphe residuel*)
let delta_flow gr path = delta_flow_general gr path (fun (x,y)-> x)  ;;



(*Met à jour le graph residuel grace au delta_flow trouvé*)
let rec update_flow rgr maxi path = 
  let add g id1 id2 n= match (find_arc g id1 id2) with
    |Some (lab,c) -> new_arc g id1 id2 (n+lab,c)
    |None->assert false
  in
  update_flow_general rgr maxi add path;;


(*Algorithme principalev Busacker Gowen*)
let busacker_gowen string_graph id_src id_dest= 
  let gr= get_weight_graph string_graph in
  let rg= residual_of_weight gr in
  let rec loop rg id_src id_dest max_flow max_cost=
    match belman_ford rg id_src id_dest with 
    (*Il n'y a plus de chemin qui permette d'aumenter le flow: on retourne la solution*)
    |None-> (rg, max_flow , max_cost)
    (*On cheche un chemin sur le graph residuel mis à jour*)
    |Some (path,cost)-> begin 
        let flow= (delta_flow rg path) in 
        loop  (update_flow rg flow path) id_src id_dest  (max_flow+flow) (max_cost+cost*flow) end 

  in loop rg id_src id_dest 0 0;;    

(*Cette fonction permet de passer d'un graph résiduel de cout à un graph de cout*)
let weight_of_residual gr rgr=   
  e_fold gr 
    (fun graphe id1 id2 capacity-> 
       match find_arc rgr id2 id1 with 
       |Some (flow,cost) -> new_arc graphe id1 id2 (string_of_int(flow)^"/"^capacity)
       |None->assert false) 
    (clone_nodes gr);;


