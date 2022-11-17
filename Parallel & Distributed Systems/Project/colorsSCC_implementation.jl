using MatrixMarket;
using SparseArrays;
using Graphs;
using Compose;
using GraphPlot;

# example graph 
g = DiGraph(6)
add_edge!(g, 1, 2)
add_edge!(g, 2, 3)
add_edge!(g, 3, 1)
add_edge!(g, 4, 5)
add_edge!(g, 5, 6)
add_edge!(g, 6, 5)
add_edge!(g, 3, 5)

# and its plot
gplot(g, nodelabel=1:nv(g), nodefillc=:"lightblue", nodesize=0.1)

# returns the nodes reachable from the given node
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

# returns a vector of vectors containing the nodes in each SCC
function colorSCC(graph)
    # the number of nodes in the graph
    n = nv(graph)
    
    # the number of colors
    k = 0
    
    # the colors of the nodes
    colors = zeros(Int64, n)
    
    # the nodes that have not been colored yet
    vertices_left = [vertices(graph)...]

    while length(vertices_left) > 0
        for node in vertices(graph)
            colors[node] = k
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
            Vc = findall(node -> colors(node) == color, vertices_left)
            



        end

    end
    
    # the SCCs
    SCC = []
    
    # while there are still nodes left to color
end