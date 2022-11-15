using MatrixMarket;
using SparseArrays;
using Graphs;
using GraphPlot;

# Load the matrix
A = mmread("matrices/celegansneural/celegansneural.mtx");

# The adjacency matrix is symmetric, so we need to convert it to a
# directed graph
G = DiGraph(A);


# plot and display the graph using GraphPlot
gplot(G, nodelabel=1:nv(G), nodefillc=:lightblue, nodesize=0.1)



