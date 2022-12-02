#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <array>
#include <string>
#include <unordered_set>
#include <chrono>

#include "sparse_util.hpp"
#include "colorSCC.hpp"

int main(int argc, char** argv) {
    std::string filename(argc > 1 ? argv[1] : "../matrices/language/language.mtx");
    size_t times = 1;
    bool DEBUG = false;
    bool TOO_BIG = false;

    if(argc<2){
        std::cout << "Assumed " << filename <<  " as input" << std::endl;
    }

    std::cout << "Reading file '" << filename << "'\n";

    if(argc>2){
        times = std::stoi(argv[2]);
    }

    if(argc>3){
        DEBUG = std::stoi(argv[3]) == 1;
    }

    if(argc > 4){
        TOO_BIG = std::atoi(argv[4]) == 1;
    }

    // load file into csr and time it

    std::cout << "Loading file into CSR\n";
    auto start_load_csc = std::chrono::high_resolution_clock::now();
    Sparse_matrix csc = loadFileToCSC(filename);
    auto end_load_csc = std::chrono::high_resolution_clock::now();
    std::cout << "Loaded file into CSC, toook " << std::chrono::duration_cast<std::chrono::milliseconds>(end_load_csc - start_load_csc).count() << "ms\n";


    Sparse_matrix* csr_ptr = nullptr;
    Sparse_matrix csr;
    if (TOO_BIG) {
        std::cout << "File is too big, skipping CSR\n";
    } else {
        std::cout << "Making CSR Version\n";
        auto start_load_csr = std::chrono::high_resolution_clock::now();
        csc_tocsr(csc, csr);
        csr_ptr = &csr;
        auto end_load_csr = std::chrono::high_resolution_clock::now();
        std::cout << "Making CSR, toook " << std::chrono::duration_cast<std::chrono::milliseconds>(end_load_csr - start_load_csr).count() << "ms\n";
    }

    std::cout << "Running " << times << " times\n";

    std::vector<size_t> SCC_id;
    auto start = std::chrono::high_resolution_clock::now();
    for(size_t i = 0; i < times; i++) {
        // csr_ptr may be null, but that's fine, we pass csc twice 
        Sparse_matrix placeholder = Sparse_matrix();
        if(csr_ptr) {
            SCC_id = colorSCC_no_conversion(csc, *csr_ptr, true, DEBUG);
        } else {
            SCC_id = colorSCC_no_conversion(csc, placeholder, false, DEBUG);
        }
    }
    auto end = std::chrono::high_resolution_clock::now();

    std::cout << "Time w/o conversion: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()/times << "ms" << std::endl;
    std::cout << "SCC count: " << *std::max_element(SCC_id.begin(), SCC_id.end()) << std::endl;

    DEB("REAL SCC count: " << std::unordered_set(SCC_id.begin(), SCC_id.end()).size());

    return 0;
}