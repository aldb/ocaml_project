open Graph
val gmap: 'a graph -> ('a -> 'b) -> 'b graph
val clone_nodes: 'a graph -> 'b graph
val add_arc: int graph -> id -> id -> int -> int graph
val update_flow_general: 'a graph-> int-> ('a graph -> id -> id -> int -> 'a graph)-> id list -> 'a graph
val delta_flow_general: 'a graph -> id list->('a->int)-> int