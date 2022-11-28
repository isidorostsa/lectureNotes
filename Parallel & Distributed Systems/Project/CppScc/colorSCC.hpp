#include <iostream>
#include <vector>

#include "sparse_util.hpp"

void trimVertices_sparse(const Sparse_matrix& inb, const Sparse_matrix& onb, std::vector<bool>& vleft,
    std::vector<size_t>& SCC_id, size_t& SCC_count);

void bfs_sparse_colors_all_inplace(const Sparse_matrix& nb, const size_t source, std::vector<size_t>& SCC_id,
    const size_t& SCC_count, const std::vector<size_t>& colors, const size_t color, std::vector<bool>& vleft);

std::vector<size_t> colorSCC(const Coo_matrix& M, bool DEBUG = true);

