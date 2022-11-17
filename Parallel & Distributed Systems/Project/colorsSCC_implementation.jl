using MatrixMarket;
using SparseArrays;
using Graphs;
using Compose;
using GraphPlot;

# example graph 
g = DiGraph(6)
add_edge!(g, 1, 2)
add_edge!(g, 2, 4)
add_edge!(g, 2, 3)
add_edge!(g, 3, 1)
add_edge!(g, 4, 5)
add_edge!(g, 6, 5)
add_edge!(g, 5, 6)
add_edge!(g, 3, 5)
add_edge!(g, 6, 4)

# and its plot
gplot(g, nodelabel=1:nv(g), nodefillc=:"lightblue", nodesize=0.1)

# returns the nodes reachable from the given node
function bfs(graph, source)
    # int64 vector of visited nodesSCV_c
    visited = zeros(Int64, 0)

    if nv(graph) <= 1
        source
    end

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

function trimedVertices(graph)
    trimed = []
    made_change = true
    while made_change
        made_change = false
        for i in 1:nv(graph)
            if i in trimed
                continue
            end
            if count(neighboring_node -> neighboring_node ∉ trimed, inneighbors(graph, i)) == 0 ||
                count(neighboring_node -> neighboring_node ∉ trimed, outneighbors(graph, i)) == 0
                push!(trimed, i)
                made_change = true
            end
        end
    end
    return trimed
end 

# returns a vector of vectors containing the nodes in each SCC
function colorSCC(graph)
    SCC = []

    n = nv(graph)
    colors = zeros(Int64, n)
    
    gplot(graph, nodelabel=1:nv(graph), nodefillc=:"lightblue", nodesize=0.1)

    vertices_left = [vertices(graph)...]

    for node_to_trim in trimedVertices(graph)
        push!(SCC, [node_to_trim])
        deleteat!(vertices_left, searchsortedfirst(vertices_left, node_to_trim))
    end

    while length(vertices_left) > 0
        for node in vertices(graph)
            colors[node] = node
            if node ∉ vertices_left
                colors[node] = 0
            end
        end


        # color all the nodes 
        made_change = true
        while made_change 
            made_change = false
            for node in vertices_left
                for neighbor in neighbors(graph, node)
                    if colors[neighbor] < colors[node] && colors[neighbor] != 0
                        colors[neighbor] = colors[node]
                        made_change = true
                    end
                end
            end
        end

        for color in unique(colors)
            if color == 0
                continue
            end

            Vc = [vertices_left[i] for i in findall(node -> colors[node] == color, vertices_left)]


            print("hello")

            subgraph_with_same_color, map_to_og = induced_subgraph(graph, Vc)
            
            # find node that gave the color
            source = findfirst(node_in_og -> node_in_og == color, map_to_og)

            connected_component_vertices_in_subgraph = bfs(reverse(subgraph_with_same_color), source)

            push!(SCC, [map_to_og[node_in_subgraph] for node_in_subgraph in connected_component_vertices_in_subgraph])

            for node in connected_component_vertices_in_subgraph
                node_in_og = map_to_og[node]
                deleteat!(vertices_left, findfirst(node -> node == node_in_og, vertices_left))
            end
        end

    end
    return SCC
end

scc = colorSCC(g)

am = adjacency_matrix(g)

# bfs as sparse matrix multiplication with a vector
function bfs_matrix(adjecency_matrix, source)

    current = source

    while true
        current = adjecency_matrix' * current
        current = min.((source.|current), 1)

        if current == source
            break
        end

        source = current
    end
    return current
end

function trimGraph_matrix!(adjacency_matrix)
    made_change = true
    while made_change
        made_change = false
        for i in 1:size(adjacency_matrix, 1)
            if sum(adjacency_matrix[i, :]) == 0 || sum(adjacency_matrix[:, i]) == 0
                adjacency_matrix[i, :] = 0
                adjacency_matrix[:, i] = 0
                made_change = true
            end
        end
    end
end

function colorSCC_matrix(adjecency_matrix)
    am = copy(adjecency_matrix)

    trimGraph_matrix!(am)

    n = am.n

    vleft = [1:n...]

    colors = zeros(Int64, size(am, 1))

    while length(vleft) > 0



end