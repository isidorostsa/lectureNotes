#pragma once

#include <iostream>
#include <vector>

#define UNASSIGNED -1
#define NO_COLOR -1

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

class Graph {
public:
    Graph(const Sparse_matrix& inb_arg, const Sparse_matrix& onb_arg) : 
        inb(inb_arg),
        onb(onb_arg),
        n(inb_arg.n),
        nnz(inb_arg.nnz),
        scc_id(inb_arg.n, UNASSIGNED),
        colors(inb_arg.n, NO_COLOR) 
    {}

    const size_t n;
    const size_t nnz;

    const Sparse_matrix& inb;
    const Sparse_matrix& onb;

    size_t get_n() const { return n; }
    size_t get_nnz() const { return nnz; }

    std::vector<size_t> scc_id;
    size_t scc_count;

    std::vector<size_t> colors;
};


Coo_matrix loadFile(std::string filename);

void coo_tocsr(const Coo_matrix& coo, Sparse_matrix& csr);

void coo_tocsc(const Coo_matrix& coo, Sparse_matrix& csc);

void csr_tocsc(const size_t n, const std::vector<size_t>& Ap, const std::vector<size_t>& Aj, 
	                std::vector<size_t>& Bp, std::vector<size_t>& Bi);

void csr_tocsc(const Sparse_matrix& csr, Sparse_matrix& csc);

