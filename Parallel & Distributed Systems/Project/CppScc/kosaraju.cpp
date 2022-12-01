#include "sparse_util.cpp"
#include <vector>
#include <deque>
#include <chrono>
#include <unordered_set>
#include <iostream>
#include <algorithm>
#include <stack>
#include <queue>

#define DEB(x) if(DEBUG) std::cout << x << std::endl;
#define UNASSIGNED -1

std::vector<size_t> kosaraju(const Sparse_matrix& inb, const Sparse_matrix& onb, bool DEBUG);
void visit(size_t i, const Sparse_matrix& onb, std::vector<bool>& visited, std::deque<size_t>& L);
void assign(size_t u, size_t root, const Sparse_matrix& inb, std::vector<size_t>& scc_id);

std::vector<size_t> kosaraju(const Sparse_matrix& inb, const Sparse_matrix& onb, bool DEBUG) {
    const size_t n = inb.n;
    std::vector<bool> visited(n, false);
    std::vector<size_t> scc_id(n, UNASSIGNED);

    std::deque<size_t> L;

    for (size_t root = 0; root < n; root++) {
        auto stack = std::stack<size_t>();
        stack.push(root);

        std::queue<size_t> q;

        while(!stack.empty()) {

            size_t u = stack.top();
            stack.pop();

            if (visited[u]) continue;
            visited[u] = true;

            for(size_t i = onb.ptr[u]; i < onb.ptr[u+1]; i++) {
                size_t v = onb.val[i];
                stack.push(v);
            }

            q.push(u);

        }

    }
    
    L.clear();

    for(const size_t& root: L) {
        auto stack = std::stack<size_t>();
        stack.push(root);

        while(!stack.empty()) {
            auto u = stack.top();
            stack.pop();

            if (scc_id[u] != UNASSIGNED) continue;
            scc_id[u] = root;

            for(size_t i = inb.ptr[u]; i < inb.ptr[u+1]; i++) {
                size_t v = inb.val[i];
                stack.push(v);
            }
        }

    }

    return scc_id;
}

void assign(size_t u, size_t root, const Sparse_matrix& inb, std::vector<size_t>& scc_id) {
    if(scc_id[u] == UNASSIGNED) {
        scc_id[u] = root;
        for (size_t i = inb.ptr[u]; i < inb.ptr[u + 1]; i++) {
            assign(inb.val[i], root, inb, scc_id);
        }
    }
}

void visit(size_t i, const Sparse_matrix& onb, std::vector<bool>& visited, std::deque<size_t>& L) {
    visited[i] = true;
    for (size_t j = onb.ptr[i]; j < onb.ptr[i + 1]; j++) {
        size_t k = onb.val[j];
        if (!visited[k]) {
            visit(k, onb, visited, L);
        }
    }
    L.push_front(i);
}

int main(int argc, char** argv) {
    std::string filename(argc > 1 ? argv[1] : "../matrices/celegansneural/celegansneural.mtx");

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
        # pragma omp parallel sections
        {
            # pragma omp section
            {
                coo_tocsr(coo, csr);
            }
            # pragma omp section
            {
                coo_tocsc(coo, csc);
            }
        }
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> elapsed = end - now;

        std::cout << "coo -> csr, csc took " << elapsed.count() << "s" << std::endl;
    }

    std::cout << "Running " << times << " times\n";

    std::vector<size_t> SCC_id;
    auto start = std::chrono::high_resolution_clock::now();
    for(size_t i = 0; i < times; i++) {
        SCC_id = kosaraju(csc, csr, DEBUG);
    }
    auto end = std::chrono::high_resolution_clock::now();

    std::cout << "Time w/o conversion: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/times << "ms" << std::endl;
    std::cout << "SCC count: " << *std::max_element(SCC_id.begin(), SCC_id.end()) << std::endl;

    std::cout << "REAL SCC count: " << std::unordered_set(SCC_id.begin(), SCC_id.end()).size() << std::endl;

    return 0;
}