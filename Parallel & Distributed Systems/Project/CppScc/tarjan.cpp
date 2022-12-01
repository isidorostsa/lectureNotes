#include "sparse_util.cpp"
#include <stack>
#include <algorithm>
#include <iostream>
#include <vector>
#include <set>
#include <chrono>
#include <unordered_set>
#include <queue>
#include <deque>

#define DEB(x) if(DEBUG) std::cout << x << std::endl;

size_t index = 0;
std::stack<size_t> S;

std::vector<size_t> lowlinkNASSIGNED);
std::vector<size_t> indices(g.n, UNASSIGNED);
std::vector<bool> onStack(g.n, false);

void strongconnect(Graph& g, size_t v, std::vector<size_t>& indices, 
                    std::vector<size_t>& lowlink, std::vector<bool>& onstack, 
                    std::stack<size_t>& S, size_t& index) {
    indices[v] = index;
    lowlink[v] = index;
    index++;
    S.push(v);
    onstack[v] = true;

    for (size_t i = g.onb.ptr[v] ; i < g.onb.ptr[v+1] ; i++) {
        size_t w = g.onb.val[i];

        if (indices[w] == -1) {
            strongconnect(g, w, indices, lowlink, onstack, S, index);
            lowlink[v] = std::min(lowlink[v], lowlink[w]);
        } else if (onstack[w]) {
            lowlink[v] = std::min(lowlink[v], indices[w]);
        }
    }

    if (lowlink[v] == indices[v]) {
        size_t w;
        do {
            w = S.top();
            S.pop();
            onstack[w] = false;

            g.scc_id[w] = v;
        } while (w != v);

    }
}

std::vector<std::vector<size_t>> tarjan(Graph& g) {
        for (size_t root = 0; root < g.n; root++) {
        if (indices[root] == UNASSIGNED) {
            strongconnect(root);
        }
    }

    return sccs;
}

int main() {

    Coo_matrix coo = loadFile("../matrices/eu-2005/eu-2005.mtx");

    Sparse_matrix onb;
    Sparse_matrix inb;

    coo_tocsc(coo, inb);
    coo_tocsr(coo, onb);

    Graph g(inb, onb);

    tarjan(g);

    size_t times = 1;

    std::cout << "Running " << times << " times\n";

    std::vector<std::vector<size_t>> sccs;
    auto start = std::chrono::high_resolution_clock::now();
    for(size_t i = 0; i < times; i++) {
        sccs = tarjan(g);
    }
    auto end = std::chrono::high_resolution_clock::now();

    std::cout << "Time w/o conversion: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/times << "ms" << std::endl;
    std::cout << "SCC count: " << sccs.size() << std::endl;
    std::cout << "in scc id: " << std::set(g.scc_id.begin(), g.scc_id.end()).size() << std::endl;

}