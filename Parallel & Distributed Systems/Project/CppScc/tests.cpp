#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <array>
#include <string>
#include <queue>
#include <set>

#define DEB(x) if(DEBUG) {std::cout << x << std::endl;}


int main() {
    Coo_matrix coo = loadFile("../matrices/foldoc/foldoc.mtx");

    Sparse_matrix csr;
    coo_tocsr(coo, csr);

    Sparse_matrix csc;
    coo_tocsc(coo, csc);

    // print five first elemetns of each
    for(int i = 0; i < 5; i++) {
        std::cout << csr.ptr[i] << " ";
    }
    std::cout << std::endl;

    for(int i = 0; i < 5; i++) {
        std::cout << csr.val[i] << " ";
    }
    std::cout << std::endl;

    for(int i = 0; i < 5; i++) {
        std::cout << csc.ptr[i] << " ";
    }
    std::cout << std::endl;

    for(int i = 0; i < 5; i++) {
        std::cout << csc.val[i] << " ";
    }
    std::cout << std::endl;

    std::vector<bool> vleft(coo.n, true);

    trimVertices_sparse(coo.n, csc, csr, vleft);

    // print the ammount of removed vertices
    int removed = 0;
    for(int i = 0; i < coo.n; i++) {
        if(!vleft[i]) removed++;
    }
    std::cout << "Removed " << removed << " vertices" << std::endl;

    // print the scc ids of coo

    std::vector<size_t> SCC_id = colorSCC(coo);

    std::cout << "SCC count: " << *std::max_element(SCC_id.begin(), SCC_id.end()) << std::endl;

    // print the scc ids
    for(int i = 0; i < 100; i++) {
        std::cout << SCC_id[i] << " ";
    }

    for(auto& sccid: std::set(SCC_id.begin(), SCC_id.end())) {
        std::cout << sccid << " ";
    }
}
