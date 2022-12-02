#include <iostream>
#include <string>
#include <fstream>

#define UNASSIGNED -1
#define NO_COLOR -1

#include "sparse_util.hpp"

Coo_matrix loadFileToCoo(const std::string filename) {
    std::ifstream fin(filename);

    size_t n, nnz;
    while(fin.peek() == '%') fin.ignore(2048, '\n');

    fin >> n >> n >> nnz;

    std::vector<size_t> Ai(nnz);
    std::vector<size_t> Aj(nnz);

    size_t throwaway;
    // lines may be of the form: i j or i j throwaway
    for(size_t i = 0; i < nnz; ++i) {
        fin >> Ai[i] >> Aj[i];
        Ai[i]--;
        Aj[i]--;
        if(fin.peek() != '\n') fin >> throwaway;
    }

    // automatically moves the vectors, no copying is done here
    return Coo_matrix{n, nnz, Ai, Aj};
}

Sparse_matrix loadFileToCSC(const std::string filename) {
    std::cout << "loadFileToCSC file: " << filename << std::endl;
    

    std::ifstream fin(filename);

    size_t n = -1, nnz;
    while(fin.peek() == '%') fin.ignore(2048, '\n');

    fin >> n >> n >> nnz;

    std::vector<size_t> ptr(n+1, 0);
    std::vector<size_t> val(nnz);

    size_t i, j, throwaway;
    // lines may be of the form: i j or i j throwaway
    for(size_t ind = 0; ind < nnz; ++ind) {
        fin >> i >> j;
        --i; --j;

        val[ind] = i;
        ptr[j+1]++;

        if(fin.peek() != '\n') fin >> throwaway;
    }
    for(size_t i = 0; i < n; ++i) {
        ptr[i+1] += ptr[i];
    }

    // automatically moves the vectors, no copying is done here
    return Sparse_matrix{n, nnz, ptr, val, Sparse_matrix::CSC};
}

void csr_tocsc(const Sparse_matrix& csr, Sparse_matrix& csc) {
    csc.n = csr.n;
    csc.nnz = csr.nnz;
    csc.ptr.resize(csr.n + 1);
    csc.val.resize(csr.nnz);
    csc.type = Sparse_matrix::CSC;

    csr_tocsc(csr.n, csr.ptr, csr.val, csc.ptr, csc.val);
}

void csc_tocsr(const Sparse_matrix& csc, Sparse_matrix& csr) {
    csr_tocsc(csc, csr);
}

void csr_tocsc(const size_t n, const std::vector<size_t>& Ap, const std::vector<size_t>& Aj, 
	                std::vector<size_t>& Bp, std::vector<size_t>& Bi) {  
    const size_t nnz = Ap[n];

    //compute number of non-zero entries per column of A 
    std::fill(Bp.begin(), Bp.end(), 0);

    for (size_t n = 0; n < nnz; n++){            
        Bp[Aj[n]]++;
    }

    //cumsum the nnz per column to get Bp[]
    for(size_t col = 0, cumsum = 0; col < n; col++){     
        size_t temp  = Bp[col];
        Bp[col] = cumsum;
        cumsum += temp;
    }
    Bp[n] = nnz; 

    for(size_t row = 0; row < n; row++){
        for(size_t jj = Ap[row]; jj < Ap[row+1]; jj++){
            size_t col  = Aj[jj];
            size_t dest = Bp[col];

            Bi[dest] = row;
            Bp[col]++;
        }
    }

    for(size_t col = 0, last = 0; col <= n; col++){
        size_t temp  = Bp[col];
        Bp[col] = last;
        last    = temp;
    }
}

void coo_tocsr(const Coo_matrix& coo, Sparse_matrix& csr) {
    csr.n = coo.n;
    csr.nnz = coo.nnz;
    csr.ptr.resize(coo.n + 1);
    csr.val.resize(coo.nnz);
    csr.type = Sparse_matrix::CSR;

    std::fill(csr.ptr.begin(), csr.ptr.end(), 0);

    for(size_t n = 0; n < coo.nnz; n++) {
        csr.ptr[coo.Ai[n]]++;
    }

    for(size_t i = 0, cumsum = 0; i < coo.n; i++) {
        size_t temp = csr.ptr[i];
        csr.ptr[i] = cumsum;
        cumsum += temp;
    }
    csr.ptr[coo.n] = coo.nnz;

    for(size_t n = 0; n < coo.nnz; n++) {
        size_t row = coo.Ai[n];
        size_t dest = csr.ptr[row];

        csr.val[dest] = coo.Aj[n];
        csr.ptr[row]++;
    }

    for(size_t i = 0, last = 0; i <= coo.n; i++) {
        size_t temp = csr.ptr[i];
        csr.ptr[i] = last;
        last = temp;
    }
}

void coo_tocsc(const Coo_matrix& coo, Sparse_matrix& csc) {
    csc.n = coo.n;
    csc.nnz = coo.nnz;
    csc.ptr.resize(coo.n + 1);
    csc.val.resize(coo.nnz);
    csc.type = Sparse_matrix::CSC;

    std::fill(csc.ptr.begin(), csc.ptr.end(), 0);

    for(size_t n = 0; n < coo.nnz; n++) {
        csc.ptr[coo.Aj[n]]++;
    }

    for(size_t i = 0, cumsum = 0; i < coo.n; i++) {
        size_t temp = csc.ptr[i];
        csc.ptr[i] = cumsum;
        cumsum += temp;
    }
    csc.ptr[coo.n] = coo.nnz;

    for(size_t n = 0; n < coo.nnz; n++) {
        size_t col = coo.Aj[n];
        size_t dest = csc.ptr[col];

        csc.val[dest] = coo.Ai[n];
        csc.ptr[col]++;
    }

    for(size_t i = 0, last = 0; i <= coo.n; i++) {
        size_t temp = csc.ptr[i];
        csc.ptr[i] = last;
        last = temp;
    }
}