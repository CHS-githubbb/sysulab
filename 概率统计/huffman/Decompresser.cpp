#include "macro.hpp"
#include "FileFunc.cpp"
#include <fstream>
#include <string>
#include <unordered_map>
#include <iostream>
#include <cstring>
#include <ctype.h>
#include <limits.h>


const int ASCII_SZ = 256;

class Decompresser{
private:

    DISABLE_ALL(Decompresser);

    static int record[ASCII_SZ];//record the number of each character
    static std::unordered_map<std::string, int> translate_map;

    static void Init(){
        memset(record, 0, sizeof(record));
        translate_map.clear();
    }

    static std::string GetDstName(std::string &filename){
        int pos = 0;
        std::string dst;//dst = filename_unzip

        if((pos = filename.find_last_of("zip")) != std::string::npos){
            dst = filename.substr(0, pos - 2) + "unzip" + filename.substr(pos + 1);
        }
        else if((pos = filename.find_last_of('.')) != std::string::npos){
            dst = filename.substr(0, pos) + "_unzip" + filename.substr(pos);
        }
        else{
            dst = filename + "_unzip";
        }

        return dst;
    }

    static void Decode(std::ifstream &fin, std::ofstream &fout){
        Reset(fin);

        int num_alp = 0;
        fin >> num_alp;
        for(int i = 0; i < num_alp; ++i){
            int symbol;
            std::string code;
            fin >> symbol >> code;
            translate_map[code] = symbol;           
        }
        fin.get();//extra space

        unsigned char temp;//read a character
        std::string cat_code = "";
        const int buff_size = CHAR_BIT;//totals bit we can read
        char mask = 1 << (CHAR_BIT - 1);//0X80
        
        while(fin >> std::noskipws >> temp){
            int cnt = 0;
            while(cnt < buff_size){
                char highbit = temp & mask;
                temp <<= 1;
                
                cat_code.push_back(highbit == 0 ? '0' : '1');
                
                if(translate_map.count(cat_code) != 0){
                    fout << static_cast<char>(translate_map[cat_code]);
                    cat_code = "";
                }
                ++cnt;
            }
        }
    }  

public:

    static void Unzip(std::string &src){
        std::string dst = GetDstName(src);
        Unzip(src, dst);
    }

    static void Unzip(std::string &src, std::string &dst){
        Init();
        //open file
        std::ifstream fin;
        std::ofstream fout;
        OpenFile(fin, src);
        OpenFile(fout, dst);

        //unzip
        Decode(fin, fout);

        //save file
        CloseFile(fin);
        CloseFile(fout);
    }

};

int Decompresser::record[ASCII_SZ];
std::unordered_map<std::string, int> Decompresser::translate_map;



int main(int argc, char **argv){
    if(argc <= 1){
        fprintf(stderr, "no file specified\n");
    }
    else if(argc == 2){
        std::string src = argv[1];
        Decompresser::Unzip(src);
        fprintf(stdout, "done\n");
    }
    else if(argc == 3){
        std::string src = argv[1],
                    dst = argv[2];
        Decompresser::Unzip(src, dst);
        fprintf(stdout, "done\n");
    }
    else{
        fprintf(stderr, "too many arguments\n");
    }
}