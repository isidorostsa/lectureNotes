#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <array>
#include <string>
#include <chrono>

#include "colorSCC.hpp"

int main(int argc, char** argv) {

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