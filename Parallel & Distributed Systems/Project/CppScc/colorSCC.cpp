#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <string>
#include <queue>
#include <set>
#include <chrono>

#include "colorSCC.hpp"

#define DEB(x) if(DEBUG) {std::cout << x << std::endl;}

// working
void trimVertices_sparse(
    const Sparse_matrix& inb,
    const Sparse_matrix& onb, 
    std::vector<bool>& vleft,
    std::vector<size_t>& SCC_id,
    size_t& SCC_count)
{
    size_t n = inb.n;

    bool madeChange = true;
    while(madeChange) {
        madeChange = false;

        for(size_t i = 0; i < n; i++) {
            if(!vleft[i]) continue;

            bool hasIncoming = false;
            for(size_t j = inb.ptr[i]; j < inb.ptr[i + 1]; j++) {
                if(vleft[inb.val[j]]) {
                    hasIncoming = true;
                    break;
                }
            }   

            if(!hasIncoming) {
                vleft[i] = false;
                SCC_id[i] = ++SCC_count;

                madeChange = true;
                break;
            }

            bool hasOutgoing = false;
            for(size_t j = onb.ptr[i]; j < onb.ptr[i + 1]; j++) {
                if(vleft[onb.val[j]]) {
                    hasOutgoing = true;
                    break;
                }
            }
            
            if(!hasOutgoing) {
                vleft[i] = false;
                SCC_id[i] = ++SCC_count;

                madeChange = true;
                break;
            }

        }
    }
}

// working
void bfs_sparse_colors_all_inplace(
    const Sparse_matrix& nb,
    const size_t source,
    std::vector<size_t>& SCC_id,
    const size_t& SCC_count,
    const std::vector<size_t>& colors, 
    const size_t color,
    std::vector<bool>& vleft)
{
        size_t _SCC_count = SCC_count + 1;
        size_t MAX_COLOR = -1;

        vleft[source] = false;
        SCC_id[source] = _SCC_count;

        std::queue<size_t> q;
        q.push(source);

        while(!q.empty()) {
            size_t v = q.front();
            q.pop();

            for(size_t i = nb.ptr[v]; i < nb.ptr[v + 1]; i++) {
                size_t u = nb.val[i];

                if(colors[u] == color && vleft[u]) {
                    SCC_id[u] = _SCC_count;
                    vleft[u] = false;
                    q.push(u);
                }
            }
        }
}

// working
std::vector<size_t> colorSCC(const Coo_matrix& M, bool DEBUG) {
    size_t n = M.n;
    size_t nnz = M.nnz;

    Sparse_matrix inb;
    Sparse_matrix onb;

    DEB("Starting conversion");
    
    coo_tocsr(M, onb);
    coo_tocsc(M, inb);

    DEB("Finished conversion");

    std::vector<bool> vleft(n, true);

    std::vector<size_t> SCC_id(n);
    size_t SCC_count = 0;

    DEB("Starting trim")

    //trimVertices_sparse(inb, onb, vleft, SCC_id, SCC_count);

    DEB("Finished trim")
    DEB("Size difference: " << SCC_count)

    std::vector<size_t> colors(n);
    size_t MAX_COLOR = -1;

    size_t iter = 0;
    while(!std::none_of(vleft.begin(), vleft.end(), [](bool v) { return v; })) {
        iter++;

        DEB("Starting while loop iteration " << iter)

        for(size_t i = 0; i < n; i++) {
            if(vleft[i]) {
                colors[i] = i;
            } else {
                colors[i] = MAX_COLOR;
            }
        }

        DEB("Starting to color")
        bool made_change = true;
        while(made_change) {
            made_change = false;

            for(size_t u = 0; u < n; u++) {
                if(colors[u] == MAX_COLOR) continue;

                for(size_t i = inb.ptr[u]; i < inb.ptr[u + 1]; i++) {
                    size_t v = inb.val[i];
                    //if(colors[v] == MAX_COLOR) continue;

                    if(colors[u] > colors[v]) {
                        colors[u] = colors[v];
                        made_change = true;
                    }
                }

            }
        }
        DEB("Finished coloring")
        DEB("Found unique colors")

        for(const size_t& color: std::set(colors.begin(), colors.end())) {
            if(color == MAX_COLOR) continue;

            //DEB("Starting BFS for color " << color)
            bfs_sparse_colors_all_inplace(inb, color, SCC_id, SCC_count, colors, color, vleft);
            SCC_count++;

            DEB("Vleft size: " << std::count(vleft.begin(), vleft.end(), true))

            //DEB("Finished BFS")
        }

        //for(size_t color: std::unique(colors.begin(), colors.end())) {
        //}
    }

    return SCC_id;
}

int _main(int argc, char** argv) {
    std::string filename(argc > 1 ? argv[1] : "../matrices/language/language.mtx");

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
    std::cout << "SCC count: " << *std::max_element(SCC_id.begin(), SCC_id.end()) << std::endl;

    return 0;
}