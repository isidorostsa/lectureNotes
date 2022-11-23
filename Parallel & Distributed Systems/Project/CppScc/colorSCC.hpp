#include <iostream>
#include <vector>

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

void trimVertices_sparse(const Sparse_matrix& inb, const Sparse_matrix& onb, std::vector<bool>& vleft,
    std::vector<size_t>& SCC_id, size_t& SCC_count);

void bfs_sparse_colors_all_inplace(const Sparse_matrix& nb, const size_t source, std::vector<size_t>& SCC_id,
    const size_t& SCC_count, const std::vector<size_t>& colors, const size_t color, std::vector<bool>& vleft);

std::vector<size_t> colorSCC(const Coo_matrix& M, bool DEBUG = true);

