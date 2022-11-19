using SparseMatricesCSR
using SparseArrays
using Graphs
using GraphPlot
using Compose
using MatrixMarket


function trimedVertices_sparse(inb, inb_ptr, onb, onb_ptr)
    trimedVertices = []
    made_change = true
    while made_change
        made_change = false
        for i in 1:length(inb_ptr)-1
            if i in trimedVertices
                continue
            end
            if !any(x -> x ∉ trimedVertices, inb[inb_ptr[i]:inb_ptr[i+1]-1]) || !any(x -> x ∉ trimedVertices, onb[onb_ptr[i]:onb_ptr[i+1]-1])
                made_change = true
                push!(trimedVertices, i)
            end
        end
    end
    return trimedVertices
end

function bfs_sparse(nb, nb_ptr, source, allowed_vertices)
    visited = falses(length(nb_ptr)-1)
    visited[source] = true
    queue = [source]
    while !isempty(queue)
        v = popfirst!(queue)
        for i in nb[nb_ptr[v]:nb_ptr[v+1]-1]
            if allowed_vertices[i] & !visited[i]
                visited[i] = true
                push!(queue, i)
            end
        end
    end
    return visited
end

function bfs_matrix(adjecency_matrix, source, allowed_vertices)
    source = Vector{Bool}(source)
    current = copy(source)
    while true
        # select the cols of am with indeces in current
        temp = (adjecency_matrix' * source)
        current = temp .| current

        current = Vector{Bool}(min.(current, 1))

        current = .&(current, allowed_vertices)

        if current == source
            break
        end

        source = current
    end

    return Vector{Bool}(current)
end

# delete element 1, 1 in a sparce matrix a
function colorSCC_matrix(M, DEBUG = false)
    n = M.n

    SCC = []
    SCC_id = zeros(Int64, n)
    SCCs_found = 0
    #bitmap of vetrices left:
    vleft = ones(Bool, n)

    colors = zeros(Int64, size(M, 1))
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
        #vleft[v] = false
        #push!(SCC, [v])

        SCCs_found += 1
        SCC_id[v] = SCCs_found
    end

    if DEBUG
        println("finished triming, new size = ", sum(vleft))
    end

    # to find outneighbors of i:
    # onb[onb_ptr[i]:(onb_ptr[i+1]-1)]

    test = 0

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
#=
                    potential_color = min((colors[inc_nb] for inc_nb in inb[inb_ptr[i]:(inb_ptr[i+1]-1)])...)
                    if potential_color < colors[i]
                        colors[i] = potential_color
                        made_change = true
                    end
=#
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
                    for j in inb[inb_ptr[i]:(inb_ptr[i+1]-1)]
                        if vleft[j]
                            if colors[i] < colors[j]
                                colors[i] = colors[j]
                                made_change = true
                            end
                        end
                    end
                end
            end
        end

        if DEBUG
            println("finished coloring all")
        end

        test = test+length(unique(colors))
        for color in unique(colors)
            if color == MAX_COLOR
                continue
            end

            if DEBUG
                println("color = ", color)
            end

            Vc = [colors[i] == color for i in 1:n]

            source = zeros(Bool, n)
            source[color] = true

            if DEBUG
                println("starting bfs")
            end

            #vertices_in_rev_bfs = bfs_matrix(M', source, Vc)
            vertices_in_rev_bfs = bfs_sparse(inb, inb_ptr, color, Vc)

            SCCs_found += 1
            SCC_id[vertices_in_rev_bfs] .= SCCs_found

            #push!(SCC, [i for i in 1:n if vertices_in_rev_bfs[i]])
            
            if DEBUG
                println("finished bfs")
            end
             
            if DEBUG
                println("SCC size = ", length(SCC))
            end

            vleft = vleft .& .!vertices_in_rev_bfs
        end
    end
    return length(unique(SCC_id)), SCCs_found
end


@time colorSCC_matrix(fol, false)
@time colorSCC_matrix(fol, false)
@profview colorSCC_matrix(lang, false)

@profview colorSCC_matrix(eu, true)


lang = mmread("matrices/language/language.mtx")
cel = mmread("matrices/celegansneural/celegansneural.mtx")
fol = mmread("matrices/foldoc/foldoc.mtx")
eu = mmread("matrices/eu-2005/eu-2005.mtx")

function tenTimes(f, args...)
    times = []
    for i in 1:10
        push!(times, @elapsed f(args...))
    end
    return times
end

