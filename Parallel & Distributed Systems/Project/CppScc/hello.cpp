#include <iostream>
#include <fstream>
#include <algorithm>
#include <array>

/*
THIS FUNCTION IS TAKEN DIRECTLY FROM THE SCIPY CPP IMPLEMENTATION
*/
void coo_tocsr(const size_t n_row,
               const size_t nnz,
               const size_t Ai[],
               const size_t Aj[],
                     size_t Bp[],
                     size_t Bj[]
                )
{
    //compute number of non-zero entries per row of A 
    std::fill(Bp, Bp + n_row, 0);

    for (int n = 0; n < nnz; n++){            
        Bp[Ai[n]]++;
    }

    //cumsum the nnz per row to get Bp[]
    for(int i = 0, cumsum = 0; i < n_row; i++){     
        int temp = Bp[i];
        Bp[i] = cumsum;
        cumsum += temp;
    }
    Bp[n_row] = nnz; 

    //write Aj,Ax into Bj,Bx
    for(int n = 0; n < nnz; n++){
        int row  = Ai[n];
        int dest = Bp[row];

        Bj[dest] = Aj[n];
        Bp[row]++;
    }

    for(int i = 0, last = 0; i <= n_row; i++){
        int temp = Bp[i];
        Bp[i]  = last;
        last   = temp;
    }

    //now Bp,Bj,Bx form a CSR representation (with possible duplicates)
}

void coo_tocsc(const size_t n_col,
               const size_t nnz,
               const size_t Ai[],
               const size_t Aj[],
                     size_t Bp[],
                     size_t Bi[]
                )
{coo_tocsr(n_col, nnz, Aj, Ai, Bp, Bi);}

bool* trimedVertices_sparce(const size_t* inb, const size_t* inb_ptr, const size_t* onb, const size_t* onb_ptr, size_t n)
{
    bool* trimedVertices = new bool[n];
    std::fill(trimedVertices, trimedVertices+n, 0);

    bool made_change = true;
    while(made_change) {
        made_change = false;

        for(int i = 0; i < n; i++) {
            if(trimedVertices[i]) continue;

            bool hasIncoming = false;
            for(int n_id = 0; n_id < inb_ptr[i+1] - inb_ptr[i]; n_id++){
                int j = inb[inb_ptr[i] + n_id];
                if(!trimedVertices[j]) {
                    hasIncoming = true;
                    break;
                }
            }

            if(!hasIncoming) {
                trimedVertices[i] = true;
                made_change = true;
                continue;
            }

            bool hasOutgoing = false;
            for(int n_id = 0; n_id < onb_ptr[i+1] - onb_ptr[i]; n_id++){
                int j = onb[onb_ptr[i] + n_id];
                if(!trimedVertices[j]) {
                    hasOutgoing = true;
                    break;
                }
            }

            if(!hasOutgoing) {
                trimedVertices[i] = true;
                made_change = true;
                continue;
            }
        }
    }
    return trimedVertices;
}

size_t* colorSCC(const size_t* Ai, const size_t* Aj, size_t n, size_t nnz) {

    size_t* SCC_id = new size_t[n];
    std::fill(SCC_id, SCC_id+n, 0);
    size_t SCCs_found = 0;

    bool* vleft = new bool[n];
    std::fill(vleft, vleft+n, 1);

    size_t* colors = new size_t[n];
    size_t MAX_COLOR = -1;

    // i can probably use only SCC_id here

    size_t* inb = new size_t[nnz];
    size_t* inb_ptr = new size_t[n+1];
    coo_tocsc(n, nnz, Ai, Aj, inb_ptr, inb);

    size_t* onb;
    size_t* onb_ptr;
    coo_tocsr(n, nnz, Ai, Aj, onb_ptr, onb);
    return nullptr;
};


int main()
{
    // Open the file
    std::ifstream fin("../matrices/foldoc/foldoc.mtx");

    int n, nnz;
    // M - number of rows
    // N - number of columns
    // N == M - cause square matrix
    // nnz - number of non-zero elements

    // Read the first line
    while(fin.peek() == '%') fin.ignore(2048, '\n');

    // The first line contains the number of rows, columns and non-zero elements
    // throw away the second number
    fin >> n >> n >> nnz;
    
    // load the coo values (we throw away the value cause we are dealing with binary matrix)
    size_t* Ai = new size_t[nnz];
    size_t* Aj = new size_t[nnz];

    int throwAway;
    for(int i = 0; i < nnz; i++) {
        fin >> Ai[i] >> Aj[i] >> throwAway;
        Ai[i]--; Aj[i]--;
    }

    std::cout << Ai[0] << " " << Aj[0] << std::endl;


    // get the CSR representation
    size_t* row_ptr = new size_t[n+1]{0}; 
    size_t* col_val = new size_t[nnz]; 

    coo_tocsr(n, nnz, Ai, Aj, row_ptr, col_val);

    // get the CSC representation
    size_t* col_ptr = new size_t[n+1]{0};
    size_t* row_val = new size_t[nnz];

    coo_tocsc(n, nnz, Ai, Aj, col_ptr, row_val);

    // get the trimed vertices
    bool* trimedVertices = trimedVertices_sparce(row_val, col_ptr, col_val, row_ptr, n);

    size_t s = 0;
    for(size_t i = 0; i < n; i++) {
        if(trimedVertices[i]) s++;
    }

    std::cout << n << " " << s << std::endl;

    return 0;
}
