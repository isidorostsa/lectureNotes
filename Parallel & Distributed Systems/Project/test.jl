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
# 1 -> 2 -> 3 -> 1 and 4 -> 5 -> 6 -> 4 and 1 -> SCV_c4
g = DiGraph(6)
add_edge!(g, 1, 2)
add_edge!(g, 2, 3)
add_edge!(g, 3, 1)
add_edge!(g, 4, 5)
add_edge!(g, 5, 6)
add_edge!(g, 6, 5)
add_edge!(g, 1, 4)
add_edge!(g, 6, 4)

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

# get adjecency matrix of g
adjMatrix = adjacency_matrix(g)

# plot g
gplot(g, nodelabel=1:nv(g), nodefillc=:"lightblue", nodesize=0.1)

function ColorSCC(graph)

    vertices_left = [1:nv(graph)]

    SCC = []

    gplot(graph, nodelabel=1:nv(graph), nodefillc=:"lightblue", nodesize=0.1)

    while length(vertices_left) > 0

        while trimGraphOnce!(graph)
        end

        # color array for each node
        colorArray = zeros(Int64, nv(graph))

        for node in vertices(graph)
            colorArray[node] = node
            if node ∉ vertices_left
                colorArray[node] = 0
            end
        end

        madeChange = true
        while madeChange
            madeChange = false
            for node in vertices(graph)
                if node in vertices_left
                    for neighbor in neighbors(graph, node)
                        if colorArray[neighbor] < colorArray[node] && colorArray[neighbor] != 0
                            colorArray[neighbor] = colorArray[node]
                            madeChange = true
                        end
                    end
                end
            end
        end

        for c in unique(colorArray)
            if c == 0
                continue
            end

            V_c = findall(x -> x == c, colorArray)

            # for c = 6:
            # V_c =[4, 5, 6]

            # create a subgraph of the nodes in V_c
            # the map is 1: 4, 2: 5, 3: 6
            subgraph, subgraph_vertices_map = induced_subgraph(graph, V_c)

            # this is now 4 -> 5 -> 6 -> 4
            # find it's reverse
            subgraph = reverse(subgraph)

            # find the maximal connected component of this starting with the node that gave the color
            # so we want the vertex in the subgraph that corresponds to the node in the original graph with value 6
            # so we look for the index of 6 in the map
            node_with_c = findfirst(x -> x == c, subgraph_vertices_map)

            # now we find the maximal connected component of the subgraph starting at node_with_c
            # this is the maximal connected component of the original graph
            # that has the color c
            max_connected_component_vertices = bfs(subgraph, node_with_c)

            # now we find the nodes in the original graph that correspond to the nodes left in the subgraph
            for node_of_subgraph in max_connected_component_vertices
                # find the node in the original graph that corresponds to the node in the subgraph
                node_of_original_graph = subgraph_vertices_map[node_of_subgraph]
                # remove the node from the vertices_left by finding it's index and deleting it using binary search
                deleteat!(vertices_left, searchsortedfirst(vertices_left, node_of_original_graph))
            end

            # add the nodes to the SCC array
            push!(SCC, [subgraph_vertices_map[node_of_subgraph] for node_of_subgraph in max_connected_component_vertices])

        end
    end
end

function bfs(graph, source)
    # int64 vector of visited nodesSCV_c
    visited = zeros(Int64, 0)

    queue = [source]
    while length(queue) > 0
        node = popfirst!(queue)
        if node ∉ visited
            push!(visited, node)
            for neighbor in neighbors(graph, node)
                push!(queue, neighbor)
            end
        end
    end
    return [x for x in visited]
end


ColorSCC(g)


g
gplot(g, nodelabel=1:nv(g), nodefillc=:"lightblue", nodesize=0.1)

# induced subgraph with nodes in bfs of 4 
gi, vert_map = induced_subgraph(g, [4, 6, 5])

# convert Array{Any} to Array{Int64}
gi, vm = induced_subgraph(g, bfs(g, 4))

gi
gi = reverse(gi)

# plot gi
gplot(gi, nodelabel=1:nv(gi), nodefillc=:"lightblue", nodesize=0.1)
