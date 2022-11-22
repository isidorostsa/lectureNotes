#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <string>


struct Coo_matrix
{
    size_t n;
    size_t nnz;
    std::vector<size_t> Ai;
    std::vector<size_t> Aj;
};

struct Csr_matrix
{
    size_t n;
    size_t nnz;
    std::vector<size_t> rowptr;
    std::vector<size_t> colval;
};

struct Csc_matrix
{
    size_t n;
    size_t nnz;
    std::vector<size_t> colptr;
    std::vector<size_t> rowval;
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
void coo_tocsr(const Coo_matrix& coo, Csr_matrix& csr) {
    csr.n = coo.n;
    csr.nnz = coo.nnz;
    csr.rowptr.resize(coo.n + 1);
    csr.colval.resize(coo.nnz);

    std::fill(csr.rowptr.begin(), csr.rowptr.end(), 0);

    for(int n = 0; n < coo.nnz; n++) {
        csr.rowptr[coo.Ai[n]]++;
    }

    for(int i = 0, cumsum = 0; i < coo.n; i++) {
        int temp = csr.rowptr[i];
        csr.rowptr[i] = cumsum;
        cumsum += temp;
    }
    csr.rowptr[coo.n] = coo.nnz;

    for(int n = 0; n < coo.nnz; n++) {
        int row = coo.Ai[n];
        int dest = csr.rowptr[row];

        csr.colval[dest] = coo.Aj[n];
        csr.rowptr[row]++;
    }

    for(int i = 0, last = 0; i <= coo.n; i++) {
        int temp = csr.rowptr[i];
        csr.rowptr[i] = last;
        last = temp;
    }
}

// working
void coo_tocsc(const Coo_matrix& coo, Csc_matrix& csc) {
    csc.n = coo.n;
    csc.nnz = coo.nnz;
    csc.colptr.resize(coo.n + 1);
    csc.rowval.resize(coo.nnz);

    std::fill(csc.colptr.begin(), csc.colptr.end(), 0);

    for(int n = 0; n < coo.nnz; n++) {
        csc.colptr[coo.Aj[n]]++;
    }

    for(int i = 0, cumsum = 0; i < coo.n; i++) {
        int temp = csc.colptr[i];
        csc.colptr[i] = cumsum;
        cumsum += temp;
    }
    csc.colptr[coo.n] = coo.nnz;

    for(int n = 0; n < coo.nnz; n++) {
        int col = coo.Aj[n];
        int dest = csc.colptr[col];

        csc.rowval[dest] = coo.Ai[n];
        csc.colptr[col]++;
    }

    for(int i = 0, last = 0; i <= coo.n; i++) {
        int temp = csc.colptr[i];
        csc.colptr[i] = last;
        last = temp;
    }
}


int main() {
    Coo_matrix coo = loadFile("../matrices/foldoc/foldoc.mtx");

    // print the contents of coo
    // the five first elements
    for(int i = 0; i < 5; i++) {
        std::cout << coo.Ai[i] << " " << coo.Aj[i] << std::endl;
    }
}