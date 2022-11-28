#include <iostream>
#include <vector>
#include <pthread.h>

#define DEB(x) if(DEBUG) {std::cout << x << std::endl;}

#define NUM_THREADS 4

#define UNCOMPLETED_SCC_ID 18446744073709551615
#define MAX_COLOR 18446744073709551615

struct Sparse_matrix
{
    size_t n;
    size_t nnz;
    std::vector<size_t> ptr;
    std::vector<size_t> val;

    enum CSC_CSR {CSC, CSR};
    CSC_CSR type;
};

/*
PROBLEM: Need to split a for loop into multiple threads

args_struct A;

for(i = start...end) {
    f(A, i)
}

API: for_loop_split(size_t start, size_t end, (void*)f(void*), void* A)

example:
int a[100]
for(size_t i = 0; i < 100; i++) {
    a[i] = i;
}

struct args_struct A {
    int* a;
    size_t i;
}

func(void* A) {
    A = (struct args_struct*) A;
    A->a[A->i] = A->i;
}

for_loop_split(0, 100, func, A)
*/

struct generic_loop_function_struct
{
    void* args;
    size_t iter;
    void* f(void*);
};

struct for_loop_generic_args {
    generic_loop_function_struct* func_struct;
    size_t start;
    size_t end;
    size_t grain_size;
};

void* for_loop_split(for_loop_generic_args* args){

    size_t start = args->start;
    size_t end = args->end;
    size_t grain_size = args->grain_size;


    size_t threads_to_use = ((end-start)/grain_size <= 1) ? 1 : 
                            ((end-start)/grain_size > NUM_THREADS) ? NUM_THREADS : 1;

    for(size_t i = args->start; i < args->end; i++) {
        args->func_struct->iter = i;
        args->func_struct->f(args_->func_struct->args);
    }

    return NULL;
}


struct generic_work_part{
    void* args;
    void* (*f) (void*);
    size_t thread_id;
};


struct generic_work{
    void* args;
    void* (*f) (void*);
};

void* threadDispatcher(generic_work* args, size_t threads_to_use) {

    std::vector<pthread_t> threads(threads_to_use);

    for(size_t i = 0; i < threads_to_use; i++) {
        generic_work_part* work_part = new generic_work_part;
        work_part->args = args->args;
        work_part->f = args->f;
        work_part->thread_id = i;
        pthread_create(&threads[i], NULL, args->f, work_part);
    }

}

void* for_loop_execute(void* work_part) { 

}

std::vector<size_t> colorSCC(const Sparse_matrix& inb, const Sparse_matrix& onb, bool DEBUG) {
    generic_work for_loop_color = {
        .args = &inb,
        .f = bfs_partitions_runner
    };


}