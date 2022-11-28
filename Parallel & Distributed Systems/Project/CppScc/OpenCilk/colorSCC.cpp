#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <string>
#include <queue>
#include <set>
#include <chrono>

#include "colorSCC.hpp"
#include "sparse_util.hpp"
#include <cilk/cilk.h>

#define UNCOMPLETED_SCC_ID -1
#define MAX_COLOR -1
#define DEB(x) if(DEBUG) {std::cout << x << std::endl;}

// For the first time only, where all SCC_ids are -1
size_t trimVertices_inplace_normal_first_time(const Sparse_matrix& inb, const Sparse_matrix& onb, std::vector<size_t>& SCC_id, const size_t SCC_count) { 
    size_t trimed = 0;

    for(size_t source = 0; source < inb.n; source++) {
        bool hasIncoming = inb.ptr[source] != inb.ptr[source + 1];

        bool hasOutgoing = onb.ptr[source] != onb.ptr[source + 1];

        if(!hasIncoming | !hasOutgoing) {
            SCC_id[source] = SCC_count + trimed++ + 1;
        }
    }
    //std::cout << "trimed: " << trimed << std::endl;

    return trimed;
}

// with onb
size_t trimVertices_inplace_normal(const Sparse_matrix& inb, const Sparse_matrix& onb, const std::vector<size_t>& vleft,
                                    std::vector<size_t>& SCC_id, const size_t SCC_count) { 
    size_t trimed = 0;

    for(size_t index = 0; index < vleft.size(); index++) {
        const size_t source = vleft[index];

        bool hasIncoming = false;
        for(size_t i = inb.ptr[source]; i < inb.ptr[source + 1]; i++) {
            if(SCC_id[inb.val[i]] == UNCOMPLETED_SCC_ID) {
                hasIncoming = true;
                break;
            }
        }

        bool hasOutgoing = false;
        for(size_t i = onb.ptr[source]; i < onb.ptr[source + 1]; i++) {
            if(SCC_id[onb.val[i]] == UNCOMPLETED_SCC_ID) {
                hasOutgoing = true;
                break;
            }
        }

        if(!hasIncoming | !hasOutgoing) {
            SCC_id[source] = SCC_count + trimed++ + 1;
        }
    }
    //std::cout << "trimed: " << trimed << std::endl;

    return trimed;
}

// without onb
size_t trimVertices_inplace_normal(const Sparse_matrix& inb, const std::vector<size_t>& vleft,
                                        std::vector<size_t>& SCC_id, size_t& SCC_count) { 

    size_t trimed = 0;
    const size_t vertices_left = vleft.size();
    const size_t n = inb.n;

    auto hasOutgoing = std::vector<bool>(n, false);

    for(size_t index = 0; index < vertices_left; index++) {
        size_t source = vleft[index];

        bool hasIncoming = false;
        for(size_t i = inb.ptr[source]; i < inb.ptr[source + 1]; i++) {
            size_t neighbor = inb.val[i];

            // if SCC_id[neighbor] == UNCOMPLETED_SCC_ID, then neighbor in vleft
            if(SCC_id[neighbor] == UNCOMPLETED_SCC_ID) {
                hasIncoming = true;
                // need index of neighbor
                hasOutgoing[neighbor] = true;
            }
        }

    // no inc neighbors then surely trim
        if(!hasIncoming) {
                SCC_id[source] = SCC_count + trimed++ + 1;
        }
    }

    for(size_t source = 0; source < n; source++) {
        // check if it has already been trimmed in the prev step
        if (SCC_id[source] != UNCOMPLETED_SCC_ID) continue;

        // noone in vleft was pointed to by source, so source is surely trimable
        if(!hasOutgoing[source]) {
            SCC_id[source] = SCC_count + ++trimed;
        }
    }
    return trimed;
}

// working
void bfs_sparse_colors_all_inplace(
    const Sparse_matrix& nb,
    const size_t source,
    std::vector<size_t>& SCC_id,
    const size_t& SCC_count,
    const std::vector<size_t>& colors, 
    const size_t color)
{
        SCC_id[source] = SCC_count;

        std::queue<size_t> q;
        q.push(source);

        while(!q.empty()) {
            size_t v = q.front();
            q.pop();

            for(size_t i = nb.ptr[v]; i < nb.ptr[v + 1]; i++) {
                size_t u = nb.val[i];

                if(colors[u] == color && SCC_id[u] != SCC_count) {
                    SCC_id[u] = SCC_count;
                    q.push(u);
                }
            }
        }
}

// working
std::vector<size_t> colorSCC(Coo_matrix& M, bool DEBUG) {
    size_t n = M.n;
    //size_t nnz = M.nnz;
    Sparse_matrix inb;
    Sparse_matrix onb;

    DEB("Starting conversion");
    
    cilk_spawn coo_tocsr(M, onb);
    coo_tocsc(M, inb);
    cilk_sync;


    //M.Ai = std::vector<size_t>();
    //M.Aj = std::vector<size_t>();

    DEB("Finished conversion");

    std::vector<size_t> SCC_id(n);
    std::fill(SCC_id.begin(), SCC_id.end(), UNCOMPLETED_SCC_ID);
    size_t SCC_count = 0;

    DEB("Starting trim")

    //trimVertices_sparse(inb, onb, vleft, SCC_id, SCC_count);

    DEB("Finished trim")
    DEB("Size difference: " << SCC_count)

    std::vector<size_t> colors(n);
    size_t MAX_COLOR = -1;

    size_t iter = 0;
    size_t total_tries = 0;
    while(!std::none_of(SCC_id.begin(), SCC_id.end(), [](size_t v) { return v == UNCOMPLETED_SCC_ID; })) {
        iter++;

        DEB("Starting while loop iteration " << iter)

        cilk_for(size_t i = 0; i < n; i++) {
            if(SCC_id[i] == UNCOMPLETED_SCC_ID) {
                colors[i] = i;
            } else {
                colors[i] = MAX_COLOR;
            }
        }

        DEB("Starting to color")
        bool made_change = true;
        while(made_change) {
            made_change = false;

            total_tries++;
            cilk_for(size_t u = n-1; u != -1; u--) {
                if(colors[u] == MAX_COLOR) continue;

                for(size_t i = inb.ptr[u]; i < inb.ptr[u + 1]; i++) {
                    size_t v = inb.val[i];
                    //if(colors[v] == MAX_COLOR) continue;
                    size_t new_color = colors[v];

                    if(new_color < colors[u]) {
                        colors[u] = new_color;
                        made_change = true;
                    }
                }
            }
        }
        DEB("Finished coloring")

        auto unique_colors_set = std::set<size_t> (colors.begin(), colors.end());

        DEB("Found " << unique_colors_set.size() << " unique colors")

        auto unique_colors = std::vector<size_t>(unique_colors_set.begin(), unique_colors_set.end());

        //std::sort(unique_colors.begin(), unique_colors.end());

        cilk_for(size_t i = 0; i < unique_colors.size(); i++) {
            size_t color = unique_colors[i];
            if(color == MAX_COLOR) continue;
            
            const size_t _SCC_count = SCC_count + i + 1;

            DEB(color)
            bfs_sparse_colors_all_inplace(inb, color, SCC_id, _SCC_count, colors, color);
            DEB("Finished BFS")
        }
        SCC_count += unique_colors.size()- (unique_colors_set.count(MAX_COLOR) ? 1 : 0);

    }

    std::cout << "Total tries: " << total_tries << std::endl;
    std::cout << "Total iterations: " << iter << std::endl;


    return SCC_id;
}

int _main(int argc, char** argv) {

    // variable filename = argv[1] or "../../matrices/languague/languague.mtx" by default
    std::string filename = (argc > 1) ? argv[1] : "../fsad.mdfdsatrdsfices/languague/languague.mtx";
    //intetional bug to remind you to change this 

    if(argc<2){
        std::cout << "Assumed " << filename <<  " as input" << std::endl;
    }

    std::cout << "Reading file '" << filename << "'\n";

    size_t times = 1;

    if(argc>2){
        times = std::stoi(argv[2]);
    }

    std::cout << "Running " << times << " times\n";

    Coo_matrix coo = loadFile(filename);

    std::cout << "Loaded matrix" << std::endl;

    std::vector<size_t> SCC_id;
    auto start = std::chrono::high_resolution_clock::now();
    for(size_t i = 0; i < times; i++) {
        SCC_id = colorSCC(coo, false);
    }
    auto end = std::chrono::high_resolution_clock::now();


    std::cout << "Time: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/times << "ms" << std::endl;
    std::cout << "SCC count: " << std::set<size_t>(SCC_id.begin(), SCC_id.end()).size() << std::endl;

    return 0;
}