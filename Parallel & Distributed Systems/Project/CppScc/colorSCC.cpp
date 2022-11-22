#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <string>
#include <queue>
#include <set>
#include <chrono>


#define DEB(x) if(DEBUG) {std::cout << x << std::endl;}

struct Coo_matrix
{
    size_t n;
    size_t nnz;
    std::vector<size_t> Ai;
    std::vector<size_t> Aj;
};

struct Sparse_matrix
{
    size_t n;
    size_t nnz;
    std::vector<size_t> ptr;
    std::vector<size_t> val;

    enum CSC_CSR {CSC, CSR};
    CSC_CSR type;
};

// working
Coo_matrix loadFile(std::string filename) {
    std::ifstream fin(filename);

    size_t n, nnz;
    while(fin.peek() == '%') fin.ignore(2048, '\n');

    fin >> n >> n >> nnz;

    std::vector<size_t> Ai(nnz);
    std::vector<size_t> Aj(nnz);

    size_t throwaway;
    for(int i = 0; i < nnz; i++) {
        fin >> Ai[i] >> Aj[i] >> throwaway;
        Ai[i]--;
        Aj[i]--;
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

    for(int n = 0; n < coo.nnz; n++) {
        csr.ptr[coo.Ai[n]]++;
    }

    for(int i = 0, cumsum = 0; i < coo.n; i++) {
        int temp = csr.ptr[i];
        csr.ptr[i] = cumsum;
        cumsum += temp;
    }
    csr.ptr[coo.n] = coo.nnz;

    for(int n = 0; n < coo.nnz; n++) {
        int row = coo.Ai[n];
        int dest = csr.ptr[row];

        csr.val[dest] = coo.Aj[n];
        csr.ptr[row]++;
    }

    for(int i = 0, last = 0; i <= coo.n; i++) {
        int temp = csr.ptr[i];
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

    for(int n = 0; n < coo.nnz; n++) {
        csc.ptr[coo.Aj[n]]++;
    }

    for(int i = 0, cumsum = 0; i < coo.n; i++) {
        int temp = csc.ptr[i];
        csc.ptr[i] = cumsum;
        cumsum += temp;
    }
    csc.ptr[coo.n] = coo.nnz;

    for(int n = 0; n < coo.nnz; n++) {
        int col = coo.Aj[n];
        int dest = csc.ptr[col];

        csc.val[dest] = coo.Ai[n];
        csc.ptr[col]++;
    }

    for(int i = 0, last = 0; i <= coo.n; i++) {
        int temp = csc.ptr[i];
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
            } if(!hasIncoming) {
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
            } if(!hasOutgoing) {
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

std::vector<size_t> colorSCC(const Coo_matrix& M, bool DEBUG = true) {
    size_t n = M.n;
    size_t nnz = M.nnz;

    Sparse_matrix inb;
    Sparse_matrix onb;

    DEB("Starting conversion");
    
    coo_tocsc(M, inb);
    coo_tocsr(M, onb);

    DEB("Finished conversion");

    std::vector<bool> vleft(n, true);

    std::vector<size_t> SCC_id(n);
    size_t SCC_count = 0;

    DEB("Starting trim")

    trimVertices_sparse(inb, onb, vleft, SCC_id, SCC_count);

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

        for(auto& color: std::set(colors.begin(), colors.end())) {
            if(color == MAX_COLOR) continue;

            DEB("Starting BFS for color " << color)
            bfs_sparse_colors_all_inplace(inb, color, SCC_id, SCC_count, colors, color, vleft);
            SCC_count++;

            DEB("Vleft size: " << std::count(vleft.begin(), vleft.end(), true))

            DEB("Finished BFS")
        }

        //for(size_t color: std::unique(colors.begin(), colors.end())) {
        //}
    }

    return SCC_id;
}

int main() {
    Coo_matrix coo = loadFile("../matrices/language/language.mtx");

    auto start = std::chrono::high_resolution_clock::now();
    auto SCC_id = colorSCC(coo, false);
    auto end = std::chrono::high_resolution_clock::now();

    std::cout << "Time: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() << "ms" << std::endl;

    return 0;
}