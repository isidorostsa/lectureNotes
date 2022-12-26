#pragma once

#include <iostream>
#include <vector>

struct Coo_matrix {
    size_t n;
    size_t nnz;
    std::vector<size_t> Ai;
    std::vector<size_t> Aj;
};

struct Sparse_matrix {
    size_t n;
    size_t nnz;
    std::vector<size_t> ptr;
    std::vector<size_t> val;

    enum CSC_CSR {CSC, CSR};
    CSC_CSR type;
};

Coo_matrix loadFileToCoo(const std::string filename);

Sparse_matrix loadFileToCSC(const std::string filename);

void coo_tocsr(const Coo_matrix& coo, Sparse_matrix& csr);

void coo_tocsc(const Coo_matrix& coo, Sparse_matrix& csc);

void csr_tocsc(const size_t n, const std::vector<size_t>& Ap, const std::vector<size_t>& Aj, 
	                std::vector<size_t>& Bp, std::vector<size_t>& Bi);

void csc_tocsr(const Sparse_matrix& csc, Sparse_matrix& csr);
void csr_tocsc(const Sparse_matrix& csr, Sparse_matrix& csc);