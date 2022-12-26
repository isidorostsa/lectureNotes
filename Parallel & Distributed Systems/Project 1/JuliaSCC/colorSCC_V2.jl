using SparseMatricesCSR
using SparseArrays
using MatrixMarket

function DEB(str, DEBUG)
    if DEBUG
        println(str)
    end
end

function csr_tocsc(Ap::Vector{Int}, Aj::Vector{Int})
    nnz = Ap[end] - 1
    n = length(Ap) - 1

    # Aj and Ap are 1-based
    # so are all arrays below

    # count the number of entries in each column

    w = zeros(Int, n)
    for j in Aj
        w[j] += 1
    end

    # compute column pointers
    Ap2 = zeros(Int, n+1)
    for j in 1:n
        Ap2[j+1] = Ap2[j] + w[j]
    end

    # copy Aj into Aj2
    Aj2 = copy(Aj)

    # row indices
    Ai = Aj

    # row pointers
    Ai2 = Ap

    # clear w
    fill!(w, 0)

    # copy A into C
    for j in 1:n
        for p in Ai2[j]:(Ai2[j+1]-1)
            i = Ai[p]
            q = Ap2[i] + w[i]
            Aj2[q+1] = j
            w[i] += 1
        end
    end

    Ap2 .+= 1

    return Ap2, Aj2
end


function csc_tocsr(Ap::Vector{Int}, Aj::Vector{Int})
    return csr_tocsc(Ap, Aj)
end

fol = mmread("../matrices/foldoc/foldoc.mtx")
row_ptr, col_vals = csc_tocsr(fol.colptr, fol.rowval)

function trimedVertices_sparse(inb, inb_ptr, onb, onb_ptr)
    activeVertices = ones(Bool, length(inb))
    made_change = true
    while made_change
        made_change = false
        for i in 1:length(inb_ptr)-1
            if !activeVertices[i]
                continue
            end
            if !any(x -> activeVertices[x], inb[inb_ptr[i]:inb_ptr[i+1]-1]) || 
                !any(x -> activeVertices[x], onb[onb_ptr[i]:onb_ptr[i+1]-1])
                made_change = true
                activeVertices[i] = false
            end
        end
    end
    return .!activeVertices
end

function trimedVertices_sparse_for_opt(inb, inb_ptr, onb, onb_ptr)
    activeVertices = ones(Bool, length(inb))
    made_change = true
    while made_change
        made_change = false

        for i in 1:length(inb_ptr)-1
            if !activeVertices[i]
                continue
            end
            
            hasIncoming = false
            for n_id = 1:(inb_ptr[i+1]-inb_ptr[i])
                j = inb[inb_ptr[i]+n_id-1]
                if activeVertices[j]
                    hasIncoming = true
                    break
                end
            end

            hasOutgoing = false
            for n_id = 1:(onb_ptr[i+1] - onb_ptr[i])
                j = onb[onb_ptr[i]+n_id-1]
                if activeVertices[j]
                    hasOutgoing = true
                    break
                end
            end

            if !hasIncoming || !hasOutgoing
                made_change = true
                activeVertices[i] = false
            end

        end
    end
    return .!activeVertices
end

function diagonal_helper(M)
    a = Vector{Bool}(undef, M.m)
    for i = 1:M.m
        a[i] = M[i,i] != 0
    end
    return a
end

function trimedVertices_sparse(M, M_tr)

    vleft = ones(Bool, M.n)

    madeChange = true
    while madeChange
        madeChange = false

        inc = diagonal_helper(M*M_tr)
        out = diagonal_helper(M_tr*M)

        tots = inc .& out

        if !all(tots .== vleft)
            madeChange = true
            vleft = vleft .& tots
        end

        # turn M, M_tr elements not in v left into 0
        for i = 1:M.n
            if !vleft[i]
                M[i,:] .= 0
                M[:,i] .= 0
                M_tr[i,:] .= 0
                M_tr[:,i] .= 0
            end
        end
    end

    return vleft
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

function bfs_sparse_colors!(nb, nb_ptr, source, colors, color)
    visited = falses(length(nb_ptr)-1)
    visited[source] = true
    queue = [source]
    while !isempty(queue)
        v = popfirst!(queue)
        for i in nb[nb_ptr[v]:nb_ptr[v+1]-1]
            if colors[i] == color && !visited[i]
                visited[i] = true
                push!(queue, i)
            end
        end
    end
    return visited
end

function bfs_sparse_colors_no_visited_all_in_place!(nb, nb_ptr, source, colors, color, SCC_id, SCCs_found, vleft)
#    visited = falses(length(nb_ptr)-1)
#    visited[source] = true
    MAX_COLOR = 2^63-1
    queue = [source]

    colors[source] = MAX_COLOR
    SCC_id[source] = SCCs_found
    vleft[source] = false

    while !isempty(queue)
        v = popfirst!(queue)
        for n_id = 1:(nb_ptr[v+1]-nb_ptr[v])
            i = nb[nb_ptr[v]+n_id-1]
            if colors[i] == color
                colors[i] = MAX_COLOR
                SCC_id[i] = SCCs_found
                vleft[i] = false
                push!(queue, i)
            end
        end
    end
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

    #SCC = []
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
    
    DEB("finished initializations", DEBUG)

    DEB("Starting coo -> csc, csr", DEBUG)

    # get the diagonal entries of M
    diag = Vector{Int64}(undef, n)
    for i in 1:n
        diag[i] = M[i, i]
    end

    # colptr shows the element we start looking at in nzval for each column 
    for col in 1:M.n
        for el_id in M.colptr[col]:(M.colptr[col+1]-1)
            inb[el_id] = M.rowval[el_id]
        end
        inb_ptr[col+1] = M.colptr[col+1]
    end

    # convert csc to csr
    M_tr = sparse(M')
    for row in 1:M_tr.n
        for el_id in M_tr.colptr[row]:(M_tr.colptr[row+1]-1)
            onb[el_id] = M_tr.rowval[el_id]
        end
        onb_ptr[row+1] = M_tr.colptr[row+1]
    end

    DEB("Finished", DEBUG)

    # above are not needed cause we can just use M.rowval and M_tr.rowval
    DEB("Starting trim, size before: "* string(length(inb)), DEBUG)

    if DEBUG
        startsize = sum(vleft)
    end

    # temporary with enum, can do better
    #for (vertex, isTrimed) in enumerate(trimedVertices_sparse(inb, inb_ptr, onb, onb_ptr))
    for (vertex, isTrimed) in enumerate(trimedVertices_sparse_for_opt(inb, inb_ptr, onb, onb_ptr))
    #for (vertex, isTrimed) in enumerate(trimedVertices_sparse(M, M_tr))
        #vleft[v] = false
        #push!(SCC, [v])

        if !isTrimed
            continue
        end

        SCCs_found += 1
        SCC_id[vertex] = SCCs_found

        vleft[vertex] = false
    end

    if DEBUG
        DEB("Finished trim, size change: "* string(sum(vleft) - startsize), DEBUG)
    end
    # to find outneighbors of i:
    # onb[onb_ptr[i]:(onb_ptr[i+1]-1)]

    iter = 0
    while reduce(|, vleft)
        iter += 1

        DEB("Starting while loop iteration: "* string(iter), DEBUG)

        for i in 1:n
            if vleft[i]
                colors[i] = i
            else
                colors[i] = MAX_COLOR 
            end
        end

        DEB("Starting to color", DEBUG)

        made_change = true
        while made_change
            made_change = false
    
            for i in 1:n
                if colors[i] != MAX_COLOR
                    #vleft[i]
#=
                    potential_color = min((colors[inc_nb] for inc_nb in inb[inb_ptr[i]:(inb_ptr[i+1]-1)])...)
                    if potential_color < colors[i]
                        colors[i] = potential_color
                        made_change = true
                    end
                    for j in onb[onb_ptr[i]:(onb_ptr[i+1]-1)]
                        if vleft[j]
                            if colors[j] < colors[i]
                                colors[j] = colors[i]
                                made_change = true
                            end
                        end
                    end
                    =#

#=                    for j in inb[inb_ptr[i]:(inb_ptr[i+1]-1)]
                        if vleft[j]
                            if colors[i] < colors[j]
                                colors[i] = colors[j]
                                made_change = true
                            end
                        end
                    end
=#
                    for n_id = 1:(inb_ptr[i+1]-inb_ptr[i])
                        j = inb[inb_ptr[i]+n_id-1]
                        if colors[j] != MAX_COLOR
                            #vleft[j]
                            if colors[i] > colors[j]
                                colors[i] = colors[j]
                                made_change = true
                            end
                        end
                    end
                end
            end
        end

        DEB("Finished coloring", DEBUG)

        DEB("Found " *string(length(unique(colors))) * " unique colors", DEBUG)

        for color in unique(colors)
            if color == MAX_COLOR
                continue
            end

            #Vc = [colors[i] == color for i in 1:n]

#            source = zeros(Bool, n)
#            source[color] = true


            DEB("Starting bfs for color "* string(color), DEBUG)

            #vertices_in_rev_bfs = bfs_matrix(M', source, Vc)
            #vertices_in_rev_bfs = bfs_sparse(inb, inb_ptr, color, Vc)

            SCCs_found += 1
            bfs_sparse_colors_no_visited_all_in_place!(inb, inb_ptr, color, colors, color, SCC_id, SCCs_found, vleft)
            
            #SCC_id[vertices_in_rev_bfs] .= SCCs_found

            #push!(SCC, [i for i in 1:n if vertices_in_rev_bfs[i]])

            DEB("Finished bfs.", DEBUG)
            #DEB("Vleft size: "* string(sum(vleft)), DEBUG)
             
#            vleft = vleft .& .!vertices_in_rev_bfs
        end
    end
    #println(SCC_id)
    return length(unique(SCC_id)), SCCs_found
end

fol = mmread("../matrices/foldoc/foldoc.mtx")

colorSCC_matrix(fol, true)

#@time colorSCC_matrix(cel, true)
@time colorSCC_matrix(cel, true)
@time colorSCC_matrix(lang, false)
@profview tenTimes(colorSCC_matrix, fol, false)

@profview colorSCC_matrix(so, false)

lang = mmread("../matrices/language/language.mtx")
cel = mmread("../matrices/celegansneural/celegansneural.mtx")
eu = mmread("../matrices/eu-2005/eu-2005.mtx")
wiki = mmread("../matrices/wiki-topcats/wiki-topcats.mtx")
so = mmread("../matrices/sx-stackoverflow/sx-stackoverflow.mtx")
ind = mmread("../matrices/indochina-2004/indochina-2004.mtx")

function tenTimes(f, args...)
    times = []
    for i in 1:10
        push!(times, @elapsed f(args...))
    end
end

