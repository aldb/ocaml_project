open Graph

val get_weight_graph: string graph-> (int*int) graph 
val residual_of_weight: (int*int) graph -> (int*int) graph
(*Recherche d'un chemin de cout minimal*)
val belman_ford: (int*int) graph -> id-> id -> (id list*int) option
(*calculer delta flow d*)
val delta_flow: (int*int) graph -> id list-> int
(*mettre a jour le graphe de flow *)
val update_flow: (int*int) graph -> int -> id list-> (int*int) graph
val busacker_gowen: string graph-> id-> id-> ((int*int) graph) * int *int
val weight_of_residual: string graph-> (int*int) graph-> string graph