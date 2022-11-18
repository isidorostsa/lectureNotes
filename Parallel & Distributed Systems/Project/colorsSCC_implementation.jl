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

# adjacency matrix
A = adjacency_matrix(g)


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
function bfs_matrix2(adjecency_matrix, source, allowed_vertices)

    source = Vector{Bool}(source)
    current = copy(source)

    while true
        # select the cols of am with indeces in current
        cols = adjecency_matrix'[:, Vector{Bool}(current)]

        current = source
        for i=1:size(cols, 2)
            current = (current .| (cols[:, i] .& allowed_vertices))
        end

        if current == source
            break
        end

        source = current
    end

    return Vector{Bool}(current)
end

function bfs_matrix(adjecency_matrix, source, allowed_vertices)

    source = Vector{Bool}(source)
    current = copy(source)
    while true
        # select the cols of am with indeces in current
        current = (adjecency_matrix' * source) .| current

        current = Vector{Bool}(min.(current, 1))

        current = .&(current, allowed_vertices)

        if current == source
            break
        end

        source = current
    end

    return Vector{Bool}(current)
end

bfs_matrix(A, [1, 0, 0, 0, 0, 0], [1, 1, 1, 1, 1, 0])

function trimedVertices_matrix(am)

    adjacency_matrix = copy(am)

    trimedVertices = []
    made_change = true
    while made_change
        made_change = false
        for i in 1:size(adjacency_matrix, 1)
            if i in trimedVertices
                continue
            end
            if sum(adjacency_matrix[i, :]) == 0 || sum(adjacency_matrix[:, i]) == 0
                adjacency_matrix[i, :] .= 0
                adjacency_matrix[:, i] .= 0
                made_change = true
                push!(trimedVertices, i)
            end
        end
    end
    return trimedVertices
end

function colorSCC_matrix(adjecency_matrix)
    M = copy(adjecency_matrix)

    n = M.n

    SCC = []
    #bitmap of vetrices left:
    vleft = ones(Bool, n)

    for v in trimedVertices_matrix(M)
        vleft[v] = false
        push!(SCC, [v])
    end

    colors = zeros(Int64, size(M, 1))

    in_nei_vec = []
    for i_m in 1:M.m
        push!(in_nei_vec, findall(x -> x != 0, M[:, i_m]))
    end

    out_nei_vec = []
    for i_m in 1:M.m
        push!(out_nei_vec, findall(x -> x != 0, M[i_m, :]))
    end


    # to find outneighbors of i:
    # out_nei_vec[i]  in_nei_vec[i]

    while reduce(|, vleft)
        for i in 1:n
            if vleft[i]
                colors[i] = i
            else
                colors[i] = 0
            end
        end

        made_change = true
        while made_change
            made_change = false
            for i in 1:n
                if vleft[i]
                    for j in out_nei_vec[i]
                        if vleft[j]
                            if colors[j] < colors[i]
                                colors[j] = colors[i]
                                made_change = true
                            end
                        end
                    end
                end
            end
        end

        for color in unique(colors)
            if color == 0
                continue
            end

            Vc = [colors[i] == color for i in 1:n]

            source = zeros(Bool, n)
            source[color] = true

            vertices_in_rev_bfs = bfs_matrix(M', source, Vc)

            push!(SCC, [i for i in 1:n if vertices_in_rev_bfs[i]])

            vleft = vleft .& .!vertices_in_rev_bfs
        end
    end
    return SCC
end

colorSCC_matrix(A)
# Load the matrix
graphMatrix = mmread("matrices/foldoc/foldoc.mtx");

# convert graphMatrix to a sparse matrix object
graphMatrix = sparse(graphMatrix);

colorSCC_matrix(graphMatrix)

# DO TRIM AFTER NEIGHBORS ARE FOUND 