#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdarg.h>
#include <sys/time.h>

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
#define NUM_DIMENTION 3//{x, y, z}


enum axis{
    X, Y, Z//0, 1, 2
};


Body nbody[NUM_BODY];
COMPUTE_TYPE force[NUM_BODY][NUM_DIMENTION];


void InitNBody(const char * const filename);
void ComputeForce();
void UpdateVelocityAndPosition();
void Check();


int main() {
    const char * filename = "nbody_init.txt";//load initial data
    InitNBody(filename);

    double start, stop;

    GET_TIME(start);//start timer    
    for(int i = 0; i < NUM_ITERATION; ++i) {
        ComputeForce();
        UpdateVelocityAndPosition();
    }
    GET_TIME(stop);//stop timmer

    printf("run time: %e\n", stop-start); 

    #ifdef DEBUG
    Check();
    #endif

    return 0;
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

//compute all force using reduced method
void ComputeForce() {
    //set 0 each time
    memset(force, 0, sizeof(force));

    for(int q = 0; q < NUM_BODY; ++q) {
        for(int k = q + 1; k < NUM_BODY; ++k) {
            Body * bq = &nbody[q], * bk = &nbody[k];

            COMPUTE_TYPE x_diff = bq->xpos - bk->xpos,
                         y_diff = bq->ypos - bk->ypos,
                         z_diff = bq->zpos - bk->zpos;
            
            COMPUTE_TYPE dist = sqrt(x_diff*x_diff + y_diff*y_diff + z_diff*z_diff);
            COMPUTE_TYPE dist_cubed = dist * dist * dist;
            COMPUTE_TYPE gmm_dist3 = -G*(bq->m)*(bk->m) / dist_cubed;

            COMPUTE_TYPE force_qk_X = gmm_dist3 * x_diff,
                         force_qk_Y = gmm_dist3 * y_diff,
                         force_qk_Z = gmm_dist3 * z_diff;

            force[q][X] += force_qk_X;
            force[q][Y] += force_qk_Y;
            force[q][Z] += force_qk_Z;
            force[k][X] -= force_qk_X;
            force[k][Y] -= force_qk_Y;
            force[k][Z] -= force_qk_Z;
        }
    }
}

//update all velocity and position in nbody[]
void UpdateVelocityAndPosition() {
    for(int i = 0; i < NUM_BODY; ++i) {
        Body * bi = &nbody[i];
        //update velocity
        bi->vx += force[i][X] / bi->m * dT;
        bi->vy += force[i][Y] / bi->m * dT;
        bi->vz += force[i][Z] / bi->m * dT;
        //update position
        bi->xpos += bi->vx * dT;
        bi->ypos += bi->vy * dT;
        bi->zpos += bi->vz * dT;
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