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

bool equal_vectors(const std::vector<size_t>& v1, const std::vector<size_t>& v2);

bool trimVertices_revursive(const Sparse_matrix& inb, const Sparse_matrix& onb, const size_t& source,
    std::vector<size_t>& SCC_id, size_t& SCC_count, size_t& trimed);

void trimVertices_inplace(const Sparse_matrix& inb, const Sparse_matrix& onb, std::vector<bool>& vleft,
    std::vector<size_t>& SCC_id, size_t& SCC_count);

void color_propagation_recursive(const Sparse_matrix& inb, const Sparse_matrix& onb, const size_t& source,
    const std::vector<size_t>& SCC_id, std::vector<size_t>& color, size_t& total_tries);

void color_propagation_inplace(const Sparse_matrix& inb, const Sparse_matrix& onb, const std::vector<size_t>& SCC_id,
    const std::vector<size_t>& vleft, std::vector<size_t>& colors, size_t& total_tries);

void bfs_sparse_colors_all_inplace(const Sparse_matrix& nb, const size_t& source, std::vector<size_t>& SCC_id,
    const size_t& SCC_count, const std::vector<size_t>& colors, const size_t& color);

std::vector<size_t> colorSCC(Coo_matrix& M, bool DEBUG = true);

std::vector<size_t> colorSCC_no_conversion(Sparse_matrix& inb, Sparse_matrix& onb, bool DEBUG);
