#include <iostream>

#include <fstream>
#include <algorithm>

int main()
{
    // Open the file
    std::ifstream fin("../matrices/foldoc/foldoc.mtx");

    int M, N, L;
    // M - number of rows
    // N - number of columns
    // L - number of non-zero elements

    // Read the first line
    while(fin.peek() == '%') fin.ignore(2048, '\n');

    // The first line contains the number of rows, columns and non-zero elements
    fin >> M >> N >> L;

    double* matrix;
    matrix = new double[M*N];

    std::fill(matrix, matrix + M*N, 0);

    for(int l = 0; l < L; l++)
    {
        int i, j;
        double value;

        fin >> i >> j >> value;

        std::cout << i << " " << j << " " << value << std::endl;
        std::cin >> value;

        matrix[(i-1)*N + (j-1)] = value;
    }
}