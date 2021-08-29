#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <assert.h>
#include <stdarg.h>
#include <sys/time.h>
#include <pthread.h>

// #ifdef _WIN32
//     #define COMPUTE_TYPE double
// #else
//     #define COMPUTE_TYPE long double
// #endif

#define COMPUTE_TYPE double

#define GET_TIME(now) { \
   struct timeval t; \
   gettimeofday(&t, NULL); \
   now = t.tv_sec + t.tv_usec/1000000.0; \
}

typedef struct Body {
    COMPUTE_TYPE m;//mass
    COMPUTE_TYPE xpos, ypos, zpos;//position
    COMPUTE_TYPE vx, vy, vz;//velocity
} Body;


#define NUM_BODY 1024
#define dT 0.005//delta time
#define G 1// universal gravitational constant
#define NUM_ITERATION 20
#define NUM_DIMENTION 3
#define NUM_THREAD 8


pthread_t threadHandle[NUM_THREAD];//thread pool
int barrier_thread_cnt;//how many threads are blocking
pthread_mutex_t barrier_cnt_mut;//mutex
pthread_mutex_t barrier_cond_var;//conditional variable

enum axis{
    X, Y, Z//0, 1, 2
};

Body nbody[NUM_BODY];
COMPUTE_TYPE force[NUM_BODY][NUM_DIMENTION];
COMPUTE_TYPE loc_force[NUM_THREAD*NUM_BODY][NUM_DIMENTION];


void BarrierInit();
void Barrier();
void BarrierDestroy();
void InitNBody(const char * const filename);
void ComputeForce(COMPUTE_TYPE force[][NUM_DIMENTION], int q);
void UpdateVelocityAndPosition(int q);
void Schedule(int my_rank, int * my_first, int * my_last, int * my_incr);
void * UpdateState(void * rank);
void Check();


int main() {
    const char * filename = "nbody_init.txt";
    InitNBody(filename);

    double start, stop;

    GET_TIME(start);//start timer

    BarrierInit();
    //create all threads
    for(int thread = 0; thread < NUM_THREAD; ++thread)
        pthread_create(&threadHandle[thread], NULL, UpdateState, (void*)thread);

    for(int thread = 0; thread < NUM_THREAD; ++thread)
        pthread_join(threadHandle[thread], NULL);

    BarrierDestroy();

    GET_TIME(stop);//stop timmer

    printf("run time: %e\n", stop-start); 

    #ifdef DEBUG
    Check();
    #endif

    return 0;
}

//initial mutex and conditiaonal variable
void BarrierInit() {
    barrier_thread_cnt = 0;
    pthread_mutex_init(&barrier_cnt_mut, NULL);
    pthread_cond_init(&barrier_cond_var, NULL);
}

//synchronize al; threads
void Barrier() {
    pthread_mutex_lock(&barrier_cnt_mut);
    //begin critical area
    ++barrier_thread_cnt;
    if(barrier_thread_cnt == NUM_THREAD) {//last thread
        barrier_thread_cnt = 0;
        pthread_cond_broadcast(&barrier_cond_var);//release all
    }
    else {
        while(pthread_cond_wait(&barrier_cond_var, &barrier_cnt_mut) != 0)
            /* do nothing */;
    }
    //end critical area
    pthread_mutex_unlock(&barrier_cnt_mut);
}

//destory mutex and conditional variable
void BarrierDestroy() {
    pthread_mutex_destroy(&barrier_cnt_mut);
    pthread_cond_destroy(&barrier_cond_var);
}

//read one of nobody data from fp
void ReadNBody(FILE ** fp, Body * bi) {
    fscanf(*fp, "%Lf", &bi->m);
    fscanf(*fp, "%Lf", &bi->xpos);
    fscanf(*fp, "%Lf", &bi->ypos);
    fscanf(*fp, "%Lf", &bi->zpos);
    fscanf(*fp, "%Lf", &bi->vx);
    fscanf(*fp, "%Lf", &bi->vy);
    fscanf(*fp, "%Lf", &bi->vz);
}

//initial nbody[] with init_file
void InitNBody(const char * const filename) {
    FILE *fp = fopen(filename, "r");
    if(fp == NULL) {
        fprintf(stderr, "can not open file: %s\n", filename);
        exit(1);
    }    
    //load all
    for(int i = 0; i < NUM_BODY; ++i) {
        ReadNBody(&fp, &nbody[i]);
    }

    fclose(fp);
}

//compute for for particle q using reduced method
void ComputeForce(COMPUTE_TYPE force[][NUM_DIMENTION], int q) {
    for(int k = q + 1; k < NUM_BODY; ++k) {
        Body * bq = &nbody[q], * bk = &nbody[k];

        COMPUTE_TYPE x_diff = bq->xpos - bk->xpos,
                        y_diff = bq->ypos - bk->ypos,
                        z_diff = bq->zpos - bk->zpos;
        
        COMPUTE_TYPE dist = sqrt(x_diff*x_diff + y_diff*y_diff + z_diff*z_diff);
        COMPUTE_TYPE dist_cubed = dist * dist * dist;
        COMPUTE_TYPE gmm_dist3 = -G*(bq->m)*(bk->m) / dist_cubed;

        COMPUTE_TYPE force_qk[NUM_DIMENTION];
        force_qk[X] = gmm_dist3 * x_diff,
        force_qk[Y] = gmm_dist3 * y_diff,
        force_qk[Z] = gmm_dist3 * z_diff;

        force[q][X] += force_qk[X];
        force[q][Y] += force_qk[Y];
        force[q][Z] += force_qk[Z];
        force[k][X] -= force_qk[X];
        force[k][Y] -= force_qk[Y];
        force[k][Z] -= force_qk[Z];
    }

}

////update all velocity and position of particle q
void UpdateVelocityAndPosition(int q) {
    Body * bi = &nbody[q];
    //update velocity
    bi->vx += force[q][X] / bi->m * dT;
    bi->vy += force[q][Y] / bi->m * dT;
    bi->vz += force[q][Z] / bi->m * dT;
    //update position
    bi->xpos += bi->vx * dT;
    bi->ypos += bi->vy * dT;
    bi->zpos += bi->vz * dT;
}

//cyclic schedule
void Schedule(int my_rank, int * my_first, int * my_last, int * my_incr) {
    *my_first = my_rank;
    *my_last = NUM_BODY;
    *my_incr = NUM_THREAD;//i += thread_num
}

//update velocity and position in current thread
void * UpdateState(void * rank) {
    long my_rank = (long) rank;
    int my_first, my_last, my_incr;
    //schedule current thread's work
    Schedule(my_rank, &my_first, &my_last, &my_incr);

    for(int i = 0; i < NUM_ITERATION; ++i) {
        //initial loc_force with 0
        memset(loc_force + my_rank*NUM_BODY, 0, NUM_BODY * sizeof(COMPUTE_TYPE[NUM_DIMENTION]));

        for(int q = my_first; q < my_last; q += my_incr) {
            ComputeForce(loc_force + my_rank*NUM_BODY, q);
        }

        Barrier();//necessary
        //reduce loc_force to force
        for(int q = my_first; q < my_last; q += my_incr) {
            force[q][X] = force[q][Y] = force[q][Z] = 0.0;
            for(int thread = 0; thread < NUM_THREAD; ++thread) {
                force[q][X] += loc_force[thread*NUM_BODY + q][X];
                force[q][Y] += loc_force[thread*NUM_BODY + q][Y];
                force[q][Z] += loc_force[thread*NUM_BODY + q][Z];
            }
        }

        Barrier();//finish computing all force
        //update velocity and position in current thread
        for(int q = my_first; q < my_last; q += my_incr) {
            UpdateVelocityAndPosition(q);
        }

        Barrier();//update all, start next iteration
    }
}

//using max difference to judge
void MaxOfAll(COMPUTE_TYPE * max, int n, ...) {
    va_list argptr;
    va_start(argptr, n);
    for (int i = 0; i < n; ++i) {
        COMPUTE_TYPE tmp = va_arg(argptr, COMPUTE_TYPE);
        *max = *max > tmp ? *max : tmp;
    }
    va_end(argptr);
}

COMPUTE_TYPE GetRelativeError(COMPUTE_TYPE myAns, COMPUTE_TYPE standardAns) {
    return fabs((myAns - standardAns) / standardAns);
}

//compare with nbody_last.txt to check correctness
void Check() {
    const char * filename = "nbody_last.txt";
    FILE *fp = fopen(filename, "r");
    if(fp == NULL) {
        fprintf(stderr, "can not open file: %s\n", filename);
        exit(1);
    } 

    COMPUTE_TYPE relative_max = 0;

    for(int i = 0; i < NUM_BODY; ++i) {
        Body refdata;
        ReadNBody(&fp, &refdata);

        MaxOfAll(&relative_max, 6, 
            GetRelativeError(nbody[i].xpos, refdata.xpos),
            GetRelativeError(nbody[i].ypos, refdata.ypos),
            GetRelativeError(nbody[i].zpos, refdata.zpos),
            GetRelativeError(nbody[i].vx, refdata.vx),
            GetRelativeError(nbody[i].vy, refdata.vy),
            GetRelativeError(nbody[i].vz, refdata.vz)
        );
    }

    printf("max relative error = %.15Lf\n", relative_max);
    fclose(fp);
}