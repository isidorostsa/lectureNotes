#include <iostream>
#include <vector>

#define DEB(x) if(DEBUG) {std::cout << x << std::endl;}

struct Coo_matrix
{
    size_t n;
    size_t nnz;
    std::vector<size_t> Ai;
    std::vector<size_t> Aj;
};

struct Sparse_matrix
{
    size_t n;
    size_t nnz;
    std::vector<size_t> ptr;
    std::vector<size_t> val;

    enum CSC_CSR {CSC, CSR};
    CSC_CSR type;
};

Coo_matrix loadFile(std::string filename);

void coo_tocsr(const Coo_matrix& coo, Sparse_matrix& csr);

void coo_tocsc(const Coo_matrix& coo, Sparse_matrix& csc);

void csr_tocsc(const size_t n, const std::vector<size_t>& Ap, const std::vector<size_t>& Aj, 
	                std::vector<size_t>& Bp, std::vector<size_t>& Bi);

void csr_tocsc(const Sparse_matrix& csr, Sparse_matrix& csc);

// version 1: trim vertices in place once, you have both inb and onb, and also vleft
size_t trimVertices_inplace_normal(const Sparse_matrix& inb, const Sparse_matrix& onb, const std::vector<bool>& vleft,
                                    std::vector<size_t>& SCC_id, size_t SCC_count);

// version 2: trim vertices in place once, you do not have out neigbors, and you have vleft
size_t trimVertices_inplace_normal_no_onb(const Sparse_matrix& inb, const std::vector<bool>& vleft,
                                    std::vector<size_t>& SCC_id, size_t SCC_count);

void color_propagation_recursive(const Sparse_matrix& inb, const Sparse_matrix& onb, const size_t& source,
    const std::vector<size_t>& SCC_id, std::vector<size_t>& color, size_t& total_tries);

void color_propagation_inplace(const Sparse_matrix& inb, const Sparse_matrix& onb, const std::vector<size_t>& SCC_id,
    const std::vector<size_t>& vleft, std::vector<size_t>& colors, size_t& total_tries);

void bfs_sparse_colors_all_inplace(const Sparse_matrix& nb, const size_t source, std::vector<size_t>& SCC_id,
    const size_t SCC_count, const std::vector<size_t>& colors, const size_t color);

std::vector<size_t> colorSCC(Coo_matrix& M, bool DEBUG = true);

std::vector<size_t> colorSCC_no_conversion(const Sparse_matrix& inb, const Sparse_matrix& onb, bool DEBUG);