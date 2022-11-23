#include <iostream>
#include <>



Coo_matrix loadFile(std::string filename);

void coo_tocsr(const Coo_matrix& coo, Sparse_matrix& csr);

void coo_tocsc(const Coo_matrix& coo, Sparse_matrix& csc);

void trimVertices_sparse( const Sparse_matrix& inb, const Sparse_matrix& onb, std::vector<bool>& vleft,
                            std::vector<size_t>& SCC_id, size_t& SCC_count);