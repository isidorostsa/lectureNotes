#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <string>
#include <queue>
#include <unordered_set>
#include <chrono>
#include <iterator>
#include <list>
#include <optional>
#include <atomic>

#include "sparse_util.hpp"
#include "colorSCC.hpp"

#include <pthread.h>
#include <coz.h>

#define NUM_THREADS 24
#define BFS_GRAIN_SIZE 60
#define COLOR_GRAIN_SIZE 10000

#define UNCOMPLETED_SCC_ID 18446744073709551615
#define MAX_COLOR 18446744073709551615

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
            trimed++;
            SCC_id[source] = SCC_count + trimed;
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
            trimed++;
            SCC_id[source] = SCC_count + trimed;
        }
    }

    for(size_t source = 0; source < n; source++) {
        // check if it has already been trimmed in the prev step
        if (SCC_id[source] != UNCOMPLETED_SCC_ID) continue;

        // noone in vleft was pointed to by source, so source is surely trimable
        if(!hasOutgoing[source]) {
            trimed++;
            SCC_id[source] = SCC_count + trimed;
        }
    }
    return trimed;
}

void bfs_sparse_colors_all_inplace( const Sparse_matrix& nb, const size_t source, std::vector<size_t>& SCC_id,
                                const size_t SCC_count, const std::vector<size_t>& colors, const size_t color) {
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

struct bfs_partitions_runner_struct
{
    const Sparse_matrix* nb;
    std::vector<size_t>* SCC_id;
    size_t SCC_count;

    // source and color are found from those below
    std::vector<size_t>* colors;
    std::vector<size_t>* unique_colors;
    size_t start;
    size_t end;

    bool should_quit_after;
};

void bfs_partitions_runner(bfs_partitions_runner_struct* bfs_plus_info) {
    const size_t SCC_count = bfs_plus_info->SCC_count;
    const size_t start = bfs_plus_info->start;
    const size_t end = bfs_plus_info->end;
    const Sparse_matrix& nb = *bfs_plus_info->nb;
    std::vector<size_t>& SCC_id = *bfs_plus_info->SCC_id;
    std::vector<size_t>& colors = *bfs_plus_info->colors;
    std::vector<size_t>& unique_colors = *bfs_plus_info->unique_colors;

    for(size_t i = start; i < end; i++) {
        size_t color = unique_colors[i];
        size_t _SCC_count = SCC_count + i + 1;
        bfs_sparse_colors_all_inplace(nb, color, SCC_id, _SCC_count, colors, color);
    }

    if(bfs_plus_info->should_quit_after) pthread_exit(0);
    return;
}

struct coloring_partitions_runner_struct
{
    const Sparse_matrix* inb;
    std::vector<size_t>* colors;
    const std::vector<size_t>* vleft;
    size_t start;
    size_t end;
    bool* made_change;
    bool should_quit_after;
};

void coloring_partitions_runner(coloring_partitions_runner_struct* coloring_info) {
    const size_t start = coloring_info->start;
    const size_t end = coloring_info->end;

    const Sparse_matrix& inb = *coloring_info->inb;
    std::vector<size_t>& colors = *coloring_info->colors;
    const std::vector<size_t>& vleft = *coloring_info->vleft;

    bool& made_change = *coloring_info->made_change;

    for(size_t i = start; i < end; i++) {
        size_t u = vleft[i];

        for(size_t j = inb.ptr[u]; j < inb.ptr[u + 1]; j++) {
            size_t v = inb.val[j];

            size_t new_color = colors[v];
            if(new_color < colors[u]) {
                colors[u] = new_color;
                made_change = true;
            }
        }
    }
}

std::vector<size_t> colorSCC(Coo_matrix& M, bool DEBUG) {
    Sparse_matrix inb;
    Sparse_matrix onb;

    DEB("Starting conversion");
    
    COZ_BEGIN("convert");

    // probably should be done in parallel
    coo_tocsr(M, inb);
    coo_tocsc(M, onb);

    COZ_END("convert");
    // if we are poor on memory, we can free M
    M.Ai = std::vector<size_t>();
    M.Aj = std::vector<size_t>();
    DEB("Finished conversion");

    return colorSCC_no_conversion(inb, onb, DEBUG);
}

// working
std::vector<size_t> colorSCC_no_conversion(const Sparse_matrix& inb, const Sparse_matrix& onb, bool DEBUG) {
    size_t n = inb.n;
    //size_t nnz = M.nnz;
    std::vector<size_t> SCC_id(n);
    std::fill(SCC_id.begin(), SCC_id.end(), UNCOMPLETED_SCC_ID);
    std::atomic<size_t> SCC_count = 0;

    DEB("Starting trim")
    COZ_BEGIN("trim");

    std::vector<size_t> vleft(n);
    for (size_t i = 0; i < n; i++) {
        vleft[i] = i;
    }

    SCC_count += trimVertices_inplace_normal_first_time(inb, onb, SCC_id, SCC_count);
    std::erase_if(vleft, [&](size_t v) { return SCC_id[v] != UNCOMPLETED_SCC_ID; });

    COZ_END("trim");
    DEB("Finished trim")
    DEB("Size difference: " << SCC_count)
    //std::cout << "trimed: " << trimed << std::endl;

    std::vector<size_t> colors(n);

    size_t iter = 0;
    size_t total_tries = 0;
    while(!vleft.empty()) {
        iter++;
        DEB("Starting while loop iteration " << iter)

        //# pragma omp parallel for shared(colors)
        for(size_t i = 0; i < n; i++) {
            colors[i] = SCC_id[i] == UNCOMPLETED_SCC_ID ? i : MAX_COLOR;
        }

        COZ_BEGIN("coloring");
        DEB("Starting to color")
        bool made_change = true;
        while(made_change) {
            made_change = false;

            const size_t num_vertices = vleft.size();
            size_t threads_to_use = (num_vertices/COLOR_GRAIN_SIZE <= 1) ? 1 : 
                                    (num_vertices/COLOR_GRAIN_SIZE > NUM_THREADS) ? NUM_THREADS : 1;

            DEB("Using " << threads_to_use << " threads for coloring.")

            std::vector<pthread_t> threads(threads_to_use);
            std::vector<coloring_partitions_runner_struct> coloring_info(threads_to_use);

            for(size_t i = 0; i < threads_to_use; i++) {
                const size_t start = i * num_vertices / threads_to_use;
                const size_t end = (i == threads_to_use - 1) ? num_vertices : (i + 1) * num_vertices / threads_to_use;

                coloring_info[i] = {&inb, &colors, &vleft, start, end, &made_change, false};
                
                pthread_create(&threads[i], NULL, (void*(*)(void*))coloring_partitions_runner, &coloring_info[i]);
            }

            for(size_t i = 0; i < threads_to_use; i++) {
                pthread_join(threads[i], NULL);
            } 
        }

        DEB("Finished coloring")
        COZ_END("coloring");

        COZ_BEGIN("Set of colors part");
        DEB("Set of colors part");
        auto unique_colors_set = std::unordered_set<size_t> (colors.begin(), colors.end());
        unique_colors_set.erase(MAX_COLOR);
        DEB("Found " << unique_colors_set.size() << " unique colors")
        auto unique_colors = std::vector<size_t>(unique_colors_set.begin(), unique_colors_set.end());
        DEB("Set of colors part");
        COZ_END("Set of colors part");

        DEB("Starting bfs")
        COZ_BEGIN("BFS");

        const size_t num_colors = unique_colors.size();
        // each thread will get a different set of colors to work on

        size_t threads_to_use = (num_colors/BFS_GRAIN_SIZE <= 1) ? 1 : 
                                (num_colors/BFS_GRAIN_SIZE > NUM_THREADS) ? NUM_THREADS : 1;

        DEB("Using " << threads_to_use << " threads for BFS")

        if(threads_to_use == 1) {
            bfs_partitions_runner_struct bfs_plus_info = 
                        {&inb, &SCC_id, SCC_count, &colors, &unique_colors, 0, num_colors, false};

            bfs_partitions_runner(&bfs_plus_info);

        } else {

            std::vector<pthread_t> threads(threads_to_use);
            std::vector<bfs_partitions_runner_struct> bfs_plus_infos(threads_to_use);

            for(size_t i = 0; i < threads_to_use; i++) {
                size_t start = i * num_colors / threads_to_use;
                size_t end = (i == threads_to_use - 1) ? num_colors : (i + 1) * num_colors / threads_to_use;

                bfs_plus_infos[i] = {&inb, &SCC_id, SCC_count, &colors, &unique_colors, start, end, true};
                pthread_create(&threads[i], NULL, (void* (*)(void*))bfs_partitions_runner, &bfs_plus_infos[i]);
            }

            for(size_t i = 0; i < threads_to_use; i++) {
                pthread_join(threads[i], NULL);
            }
        }
        SCC_count += unique_colors.size();
        DEB("Finished BFS")
        COZ_END("BFS");

        // remove all vertices that are in some SCC
        std::erase_if(vleft, [&](size_t v) { return SCC_id[v] != UNCOMPLETED_SCC_ID; });
        SCC_count += trimVertices_inplace_normal(inb, onb, vleft, SCC_id, SCC_count);

        // clean up vleft after trim
        std::erase_if(vleft, [&](size_t v) { return SCC_id[v] != UNCOMPLETED_SCC_ID; });
    }
    std::cout << "Total tries: " << total_tries << std::endl;
    std::cout << "Total iterations: " << iter << std::endl;
    std::cout << "Total SCCs: " << SCC_count << std::endl;
    return SCC_id;
}

int _main(int argc, char** argv) {
    std::string filename(argc > 1 ? argv[1] : "../../matrices/sx-stackoverflow/sx-stackoverflow.mtx");

    if(argc<2){
        std::cout << "Assumed " << filename <<  " as input" << std::endl;
    }

    std::cout << "Reading file '" << filename << "'\n";

    size_t times = 1;

    if(argc>2){
        times = std::stoi(argv[2]);
    }

    bool DEBUG = false;
    if(argc>3){
        DEBUG = std::stoi(argv[3]) == 1;
    }

    bool TOO_BIG = false;
    if(argc > 4){
        TOO_BIG = std::atoi(argv[4]) == 1;
    }

    Coo_matrix coo = loadFile(filename);

    Sparse_matrix csr;
    Sparse_matrix csc;

    std::cout << "Loaded matrix" << std::endl;

    if(TOO_BIG){
        std::cout << "Too big matrix, will go coo -> csr, csr -> csc instead of coo -> csr, csc" << std::endl;

        auto start = std::chrono::high_resolution_clock::now();
        coo_tocsr(coo, csr);
        coo.Ai = std::vector<size_t>();
        coo.Aj = std::vector<size_t>();
        csr_tocsc(csr, csc);
        auto end = std::chrono::high_resolution_clock::now();

        std::cout << "Conversion took " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() << " ms" << std::endl;
    } else {
        DEB("Starting coo -> csr, csc");
        auto now = std::chrono::high_resolution_clock::now();

        coo_tocsr(coo, csr);
        coo_tocsc(coo, csc);

        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> elapsed = end - now;
        std::cout << "coo -> csr, csc took " << elapsed.count() << "s" << std::endl;
    }

    std::cout << "Running " << times << " times\n";

    std::vector<size_t> SCC_id;

    auto start = std::chrono::high_resolution_clock::now();
    for(size_t i = 0; i < times; i++) {
        SCC_id = colorSCC_no_conversion(csc, csr, DEBUG);
    }
    auto end = std::chrono::high_resolution_clock::now();

    std::cout << "Time w/o conversion: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/times << "ms" << std::endl;
    std::cout << "SCC count: " << *std::max_element(SCC_id.begin(), SCC_id.end()) << std::endl;

    return 0;
}