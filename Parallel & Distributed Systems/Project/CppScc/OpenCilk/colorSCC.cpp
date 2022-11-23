#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <string>
#include <queue>
#include <set>
#include <chrono>

#include "colorSCC.hpp"
#include <cilk/cilk.h>

#define UNCOMPLETED_SCC_ID -1
#define DEB(x) if(DEBUG) {std::cout << x << std::endl;}

// working
Coo_matrix loadFile(std::string filename) {
    std::ifstream fin(filename);

    size_t n, nnz;
    while(fin.peek() == '%') fin.ignore(2048, '\n');

    fin >> n >> n >> nnz;

    std::vector<size_t> Ai(nnz);
    std::vector<size_t> Aj(nnz);

    size_t throwaway;
    // lines may be of the form: i j or i j throwaway
    for(size_t i = 0; i < nnz; ++i) {
        fin >> Ai[i] >> Aj[i];
        Ai[i]--;
        Aj[i]--;
        if(fin.peek() != '\n') fin >> throwaway;
    }

    return Coo_matrix{n, nnz, Ai, Aj};
}

// working
void coo_tocsr(const Coo_matrix& coo, Sparse_matrix& csr) {
    csr.n = coo.n;
    csr.nnz = coo.nnz;
    csr.ptr.resize(coo.n + 1);
    csr.val.resize(coo.nnz);
    csr.type = Sparse_matrix::CSR;

    std::fill(csr.ptr.begin(), csr.ptr.end(), 0);

    for(size_t n = 0; n < coo.nnz; n++) {
        csr.ptr[coo.Ai[n]]++;
    }

    for(size_t i = 0, cumsum = 0; i < coo.n; i++) {
        size_t temp = csr.ptr[i];
        csr.ptr[i] = cumsum;
        cumsum += temp;
    }
    csr.ptr[coo.n] = coo.nnz;

    for(size_t n = 0; n < coo.nnz; n++) {
        size_t row = coo.Ai[n];
        size_t dest = csr.ptr[row];

        csr.val[dest] = coo.Aj[n];
        csr.ptr[row]++;
    }

    for(size_t i = 0, last = 0; i <= coo.n; i++) {
        size_t temp = csr.ptr[i];
        csr.ptr[i] = last;
        last = temp;
    }
}

// working
void coo_tocsc(const Coo_matrix& coo, Sparse_matrix& csc) {
    csc.n = coo.n;
    csc.nnz = coo.nnz;
    csc.ptr.resize(coo.n + 1);
    csc.val.resize(coo.nnz);
    csc.type = Sparse_matrix::CSC;

    std::fill(csc.ptr.begin(), csc.ptr.end(), 0);

    for(size_t n = 0; n < coo.nnz; n++) {
        csc.ptr[coo.Aj[n]]++;
    }

    for(size_t i = 0, cumsum = 0; i < coo.n; i++) {
        size_t temp = csc.ptr[i];
        csc.ptr[i] = cumsum;
        cumsum += temp;
    }
    csc.ptr[coo.n] = coo.nnz;

    for(size_t n = 0; n < coo.nnz; n++) {
        size_t col = coo.Aj[n];
        size_t dest = csc.ptr[col];

        csc.val[dest] = coo.Ai[n];
        csc.ptr[col]++;
    }

    for(size_t i = 0, last = 0; i <= coo.n; i++) {
        size_t temp = csc.ptr[i];
        csc.ptr[i] = last;
        last = temp;
    }
}

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

/*
void color_propagation_inplace(
    const Sparse_matrix& inb,
    const Sparse_matrix& onb,
    const std::vector<size_t>& SCC_id,
    std::vector<size_t>& colors)
{
    size_t n = inb.n;

    trimVertices_sparse(inb, onb, vleft, newSCC_id, SCC_count);

    for(size_t i = 0; i < n; i++) {
        if(!vleft[i]) continue;

        std::vector<size_t> stack;
        stack.push_back(i);

        while(!stack.empty()) {
            size_t v = stack.back();
            stack.pop_back();

            if(!vleft[v]) continue;
            vleft[v] = false;

            newSCC_id[v] = ++SCC_count;

            for(size_t j = inb.ptr[v]; j < inb.ptr[v + 1]; j++) {
                size_t u = inb.val[j];
                if(vleft[u]) stack.push_back(u);
            }
        }
    }

    std::swap(SCC_id, newSCC_id);
} 
*/

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

        std::vector<size_t> new_colors(n);


        DEB("Starting to color")
        bool made_change = true;
        while(made_change) {
            made_change = false;

            cilk_for(size_t u = 0; u < n; u++) {
                total_tries++;
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

        std::sort(unique_colors.begin(), unique_colors.end());

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