#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <string>

int main() {
    int n;
    std::cin >> n;
    int* M = new int[n]{0};

    for(int i = 0; i < 10; i++) {
        std::cout << M[i] << std::endl;
    }
}