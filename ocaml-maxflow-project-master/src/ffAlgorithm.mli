open Graph

val dfs: int graph -> id-> id -> id list option;;
val delta_flow: int graph -> id list-> int
val update_flow: int graph -> int -> id list-> int graph
val residual_of_capacity: int graph ->int graph
val get_capacity_graph: string graph-> int graph ;;
val ff_algo: string graph-> id-> id-> (int graph* int)
val flow_of_residual: string graph-> int graph-> string graph