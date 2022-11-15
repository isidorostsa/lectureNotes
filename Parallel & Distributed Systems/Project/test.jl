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
neighbors(graph, 1)

# undirected graph containing the same edges as graph
