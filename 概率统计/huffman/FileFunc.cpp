#include <fstream>
#include <string>
#include <exception>


void OpenFile(std::ofstream &fout, std::string &filename){
    try{
        fout.open(filename, std::ofstream::binary);
    }
    catch(const std::exception &){
        fprintf(stderr, "can not open file: %s\n", filename.c_str());
        exit(1);
    }
}

void CloseFile(std::ofstream &fout){
    try{
        fout.close();
    }
    catch(const std::exception &){
        fprintf(stderr, "can not close file\n");
        exit(1);
    }
}

void OpenFile(std::ifstream &fin, std::string &filename){
    try{
        fin.open(filename, std::ofstream::binary);
    }
    catch(const std::exception &){
        fprintf(stderr, "can not open file: %s\n", filename.c_str());
        exit(1);
    }
}

void CloseFile(std::ifstream &fin){
    try{
        fin.close();
    }
    catch(const std::exception &){
        fprintf(stderr, "can not close file\n");
        exit(1);
    }
}

//set pointer to the begin of the file
void Reset(std::ifstream &fin){
    try{
        fin.clear();//clear prev flag
        fin.seekg(0);
    }
    catch(const std::exception &){
        fprintf(stderr, "can not reset file\n");
        exit(1);
    }
}