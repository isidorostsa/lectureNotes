using MatrixMarket;
using SparseArrays;
using Graphs;
using Compose;
using GraphPlot;
using SparseMatricesCSR;

# example graph 
g = DiGraph(6)
add_edge!(g, 1, 2)
add_edge!(g, 4, 2)
add_edge!(g, 4, 1)
add_edge!(g, 3, 4)
add_edge!(g, 5, 3)
add_edge!(g, 3, 1)
add_edge!(g, 5, 6)


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
                colors[node] = 2^63-1
            end
        end


        # color all the nodes 
        made_change = true
        while made_change 
            made_change = false
            for node in vertices_left

                potential_color = min([colors[neighboring_node] for neighboring_node in inneighbors(graph, node)]...)
                if potential_color < colors[node]
                    colors[node] = potential_color
                    made_change = true
                end
                #for neighbor in inneighbors(graph, node)
                #    if colors[neighbor] < colors[node] && colors[neighbor] != 0
                #        colors[neighbor] = colors[node]
                #        made_change = true
                #    end
                #end
            end
        end

        for color in unique(colors)
            if color == 2^63-1
                continue
            end

            Vc = [vertices_left[i] for i in findall(node -> colors[node] == color, vertices_left)]

            subgraph_with_same_color, map_to_og = induced_subgraph(graph, Vc)
            
            # find node that gave the color
            source = findfirst(node_in_og -> node_in_og == color, map_to_og)

            println("source: ", source)
            connected_component_vertices_in_subgraph = bfs((reverse(subgraph_with_same_color)), source)

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

function bfs_sparse(inb, inb_ptr, onb, onb_ptr, source, allowed_vertices)
    source = Vector{Bool}(source)
    current = copy(source)
    while true
        # select the cols of am with indeces in current
        current = Vector{Bool}(zeros(length(source)))
        for i in 1:length(source)
            if source[i]
                current[inb[inb_ptr[i]:inb_ptr[i+1]-1]] .= true
                current[onb[onb_ptr[i]:onb_ptr[i+1]-1]] .= true
            end
        end

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

function trimedVertices_vecs(in_nb, out_nb)
    trimedVertices = []
    made_change = true
    while made_change
        made_change = false
        for i in 1:length(in_nb)
            if i in trimedVertices
                continue
            end
            if count(x -> x ∉ trimedVertices, in_nb[i]) == 0 || count(x -> x ∉ trimedVertices, out_nb[i]) == 0
                made_change = true
                push!(trimedVertices, i)
            end
        end
    end
    return trimedVertices
end

function trimedVertices_sparse(inb, inb_ptr, onb, onb_ptr)
    trimedVertices = []
    made_change = true
    while made_change
        made_change = false
        for i in 1:length(inb_ptr)-1
            if i in trimedVertices
                continue
            end
            if count(x -> x ∉ trimedVertices, inb[inb_ptr[i]:inb_ptr[i+1]-1]) == 0 ||\\
                count(x -> x ∉ trimedVertices, onb[onb_ptr[i]:onb_ptr[i+1]-1]) == 0
                made_change = true
                push!(trimedVertices, i)
            end
        end
    end
    return trimedVertices
end

# delete element 1, 1 in a sparce matrix a
function colorSCC_matrix(M, DEBUG = false)
    n = M.n

    SCC = []
    #bitmap of vetrices left:
    vleft = ones(Bool, M.n)

    colors = zeros(Int64, M.n)
    MAX_COLOR = 2^63-1

    inb = Vector{Int64}(undef, length(M.nzval))
    inb_ptr = Vector{Int64}(undef, M.n+1)
    inb_ptr[1] = 1

    onb = Vector{Int64}(undef, length(M.nzval))
    onb_ptr = Vector{Int64}(undef, M.n+1)
    onb_ptr[1] = 1
    
    if DEBUG
        println("finished initializations")
    end

    # colptr shows the element we start looking at in nzval for each column 
    for col in 1:M.n
        for el_id in M.colptr[col]:(M.colptr[col+1]-1)
            inb[el_id] = M.rowval[el_id]
        end
        inb_ptr[col+1] = M.colptr[col+1]
    end

    # convert csc to csr
    M_tr = SparseMatrixCSR(transpose(sparse(M')))
    for row in 1:M_tr.n
        for el_id in M_tr.rowptr[row]:(M_tr.rowptr[row+1]-1)
            onb[el_id] = M_tr.colval[el_id]
        end
        onb_ptr[row+1] = M_tr.rowptr[row+1]
    end

    if DEBUG
        println("finished calculating stuff in the begining")
    end

    # above are not needed cause we can just use M.rowval and M_tr.rowval

    for v in trimedVertices_sparse(inb, inb_ptr, onb, onb_ptr)
        vleft[v] = false
        push!(SCC, [v])
    end

    if DEBUG
        println("finished triming, new size = ", sum(vleft))
    end

    # to find outneighbors of i:
    # onb[onb_ptr[i]:(onb_ptr[i+1]-1)]

    iter = 1
    while reduce(|, vleft)
        for i in 1:n
            if vleft[i]
                colors[i] = i
            else
                colors[i] = MAX_COLOR 
            end
        end

        if DEBUG
            println("finished coloring start, iter = ", iter)
        end
        iter += 1

        made_change = true
        while made_change
            made_change = false
            for i in 1:n
                if vleft[i]
                    potential_color = min((colors[inc_nb] for inc_nb in inb[inb_ptr[i]:(inb_ptr[i+1]-1)])...)
                    if potential_color < colors[i]
                        colors[i] = potential_color
                        made_change = true
                    end
#=
                    for j in onb[onb_ptr[i]:(onb_ptr[i+1]-1)]
                        if vleft[j]
                            if colors[j] < colors[i]
                                colors[j] = colors[i]
                                made_change = true
                            end
                        end
                    end
=#
                end
            end
        end

        if DEBUG
            println("finished coloring all")
        end

        for color in unique(colors)
            if color == MAX_COLOR
                continue
            end

            if DEBUG
                println("color = ", color)
            end

            Vc = [colors[i] == color for i in 1:n]
            
            print(Vc)

            source = zeros(Bool, n)
            source[color] = true

            if DEBUG
                println("starting bfs")
            end

            vertices_in_rev_bfs = bfs_sparse(onb, onb_ptr, inb, inb_ptr, source, Vc)
            print(source)
            print(vertices_in_rev_bfs)
            #vertices_in_rev_bfs = bfs_matrix(M, source, Vc)

            push!(SCC, [i for i in 1:n if vertices_in_rev_bfs[i]])
            
            if DEBUG
                println("finished bfs")
            end
             
            if DEBUG
                println("SCC size = ", length(SCC))
            end

            vleft = vleft .& .!vertices_in_rev_bfs
        end
    end
    return SCC
end

colorSCC_matrix(A, true)
# Load the matrix
graphMatrix = mmread("matrices/foldoc/foldoc.mtx");

# convert graphMatrix to a sparse matrix object
graphMatrix = sparse(graphMatrix);

colorSCC_matrix(graphMatrix, true)
