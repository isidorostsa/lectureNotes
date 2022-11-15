using MatrixMarket;
using SparseArrays;
using Graphs;
using Compose;
using GraphPlot;

# Load the matrix
graphMatrix = mmread("matrices/celegansneural/celegansneural.mtx");

# convert graphMatrix to a sparse matrix object
graphMatrix = sparse(graphMatrix);

# convert graphMatrix to a directed graph object
graph = DiGraph(graphMatrix);

# plot the graph
gplot(graph, nodelabel=1:nv(graph), nodefillc=:"lightblue", nodesize=0.1)

# set of the neighboors of node 1
neighbors(graph, 261)

# empty array of graphs
graphs = Array{Graph, 1}();

# populate it's first entry with the connected components of node 1
graphs[1] = neighboors(graph, 1);

# plot the first graph

gplot(graphs[1], nodelabel=1:nv(graphs[1]), nodefillc=:"lightblue", nodesize=0.1)