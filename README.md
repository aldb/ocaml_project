# ocaml-maxflow-project

Presentation :
--------------
This OCAML-coded project aims to implement the Ford-Fulkerson algorithm and implement busacker gowen and present an exemple of flow problem or a min cost flow problem with a use case.

Compilation: make 
----------------------------

Test the project:
----------------------------
To execute the Ford-Fulkerson algorithm: 
./ftest.native f infile.gfile source_id sink_id outfile.dot

To execute the Busacker Gowen algorithm: 
./ftest.native b infile.gfile source_id sink_id outfile.dot

To execute the Busacker Gowen algorithm to anwser a usecase problem: 
./ftest.native u infile.usecasefile max_match_per_project 0 outfile.txt 


Ford-Fulkerson Exemple
----------------------------
Execute the Ford-Fulkerson algorithm on graph10 from node 0 to 7, result are visible on graph10_flow_0_7.svg :expected result flow=31

./ftest.native f graphs/txt/graph10.txt 0 7 graphs/dot/graph10_flow_0_7.dot
dot -Tsvg graphs/dot/graph10_flow_0_7.dot > graphs/svg/graph10_flow_0_7.svg



Use-case Bipartite Matching:
----------------------------
Host matching : Bipartite Matching. 

>Every year the INSA's High Five is a sports competition but also cultural and festive event bringing together nearly 600 students coming from all the INSA. 

The organizing team provide hosting for all participants who travel to come to the event. There is students who sign up as hosts. To make the whole process go well, the organizing team need to match participants with host. 

This problem can be resolved with ford fukelrson to simplifie the project we use Gowen algorithm.

See at Busacker Gowen use case for exemple of exectution. 

usecase file format for bipartie matching 
--------------------------------------------------------
  Format of usecase bipartie matching:
   % This is a comment
   % Lucie=1 Sophie=2 ... Adeline=n, hotex= n+1....hotey=z
   % declarer un invite: e n°e de 1 à n
   % max invité par host 1
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


Busacker Gowen exemple
----------------------------
Execute the Busacker Gowen algorithm on the graph file graph_test_busacker from node 0 to 4, result are visible on graph_test_busacke.sgv: expected result  cost=500 (flow=45 )
 
./ftest.native b graphs/txt/graph_test_busacker.txt 0 4 graphs/dot/graph_test_busacker.dot

dot -Tsvg graphs/dot/graph_test_busacker.dot > graphs/svg/graph_test_busacker.svg

Busacker Gowen use case exemple
----------------------------
Execute the Busacker on a usecasefile and return an output file with the matching if possible: 

./ftest.native u graphs/txt/matchingproject.txt 6 0  graphs/txt/result_projectmatching.txt

usecasefile format exemple
--------------------------------------------------------
 Format of usecase projet tutoré files:
   % This is a comment
   % Lucie=1 Sophie=2 ... Adeline=n, Projetx= n+1....Projety=z
   % declarer un eleve: e n°e de 1 à n
    e 1
    e 2
    e 3
   %declarer les projet: p n°p de n à z
    p 4
    p 5
    p 6
   %declarer les voeux: v n°e n°p 1_n°v 
    v 0 1_1
    v 0 1_2



