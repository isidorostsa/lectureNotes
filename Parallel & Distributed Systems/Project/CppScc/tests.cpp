#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <string>

int main() {
    int n;
    int* M = new int[n]{0};

    for(int i = 0; i < 10; i++) {
        std::cout << M[i] << std::endl;
    }
    size_t a = 3;

    std::cout << sizeof(a) << sizeof(int) << std::endl;

}