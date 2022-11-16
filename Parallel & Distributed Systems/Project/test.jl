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

# create the following directed graph:
# 1 -> 2 -> 3 -> 1 and 4 -> 5 -> 6 -> 4 and 1 -> 4
g = DiGraph(6)
add_edge!(g, 1, 2)
add_edge!(g, 2, 3)
add_edge!(g, 3, 1)
add_edge!(g, 4, 5)
add_edge!(g, 5, 6)
add_edge!(g, 6, 4)
add_edge!(g, 1, 4)

gplot(g, nodelabel=1:nv(g), nodefillc=:"lightblue", nodesize=0.1)

function trimGraphOnce!(digraph)
    # iterate over nodes
    madeChange = false
    # array of nodes to be removed
    nodesToRemove = []
    for node in vertices(digraph)
        # if the node has no incoming edges
        if indegree(digraph, node) == 0 || outdegree(digraph, node) == 0
            # add the node to the array of nodes to be removed
            push!(nodesToRemove, node)
            madeChange = true
        end
    end
    # remove the nodes
    for node in nodesToRemove
        rem_vertex!(digraph, node)
    end
    return madeChange
end

trimGraphOnce!(g)

while trimGraphOnce!(g)
end

# plot g
gplot(g, nodelabel=1:nv(g), nodefillc=:"lightblue", nodesize=0.1)
