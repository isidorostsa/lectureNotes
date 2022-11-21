#include <iostream>
#include <fstream>
#include <algorithm>

/*
THIS FUNCTION IS TAKEN DIRECTLY FROM THE SCIPY CPP IMPLEMENTATION
*/
void coo_tocsr(const int n_row,
               const int nnz,
               const int Ai[],
               const int Aj[],
                     int Bp[],
                     int Bj[]
                )
{
    //compute number of non-zero entries per row of A 
    //std::fill(Bp, Bp + n_row, 0);
    for(int i = 0; i < n_row; i++) {
        Bp[i] = 0;
    }


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

void coo_tocsc(const int n_col,
               const int nnz,
               const int Ai[],
               const int Aj[],
                     int Bp[],
                     int Bi[]
                )
{coo_tocsr(n_col, nnz, Aj, Ai, Bp, Bi);}

bool* trimedVertices_sparce(const int* inb, const int* inb_ptr, const int* onb, const int* onb_ptr, size_t n)
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
    int* Ai = new int[nnz];
    int* Aj = new int[nnz];

    int throwAway;
    for(int i = 0; i < nnz; i++) {
        fin >> Ai[i] >> Aj[i] >> throwAway;
        Ai[i]--; Aj[i]--;
    }


    // get the CSR representation
    int* row_ptr = new int[n+1]{0}; 
    int* col_val = new int[nnz]; 

    coo_tocsr(n, nnz, Ai, Aj, row_ptr, col_val);

    // get the CSC representation
    int* col_ptr = new int[n+1]{0};
    int* row_val = new int[nnz];

    coo_tocsc(n, nnz, Ai, Aj, col_ptr, row_val);

    std::cout << (row_val[10000]) << std::endl;

    // get the trimed vertices
    bool* trimedVertices = trimedVertices_sparce(row_val, row_ptr, col_val, col_ptr, n);

    int s = 0;
    for(int i = 0; i < n; i++) {
        if(trimedVertices[i]) s++;
    }

    std::cout << s << std::endl;

    return 0;
}
