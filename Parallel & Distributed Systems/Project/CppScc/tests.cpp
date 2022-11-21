#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <string>

int main() {
    int n = 10;
    bool* M = new bool[n];

    std::fill(M, M + n, 1);

    for(int i = 0; i < 10; i++) {
        std::cout << M[i] << std::endl;
    }

    size_t s = 0;
    for(size_t i = 0; i < n; i++){
        s += M[i];
    }
    

    std::cout << s << std::endl;

}