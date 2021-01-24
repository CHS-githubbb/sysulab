#include "HuffmanTree.cpp"
#include "macro.hpp"
#include "FileFunc.cpp"
#include <fstream>
#include <string>
#include <ctype.h>
#include <limits.h>


const int ASCII_SZ = 256;

class Compresser{
    
private:

    DISABLE_ALL(Compresser);

    static int record[ASCII_SZ];//record the number of each character
    

    //record the number of each character
    static void MakeRecord(std::ifstream &fin, std::string &filename){
        memset(record, 0, sizeof(record));
        Reset(fin);

        unsigned char temp;
        while(fin >> std::noskipws >> temp){ 
            ++record[temp];
        }        
    }   

    static std::string GetDstName(std::string &filename){
        int pos = 0;
        std::string dst;//dst = filename_zip

        if((pos = filename.find_last_of('.')) != std::string::npos){
            dst = filename.substr(0, pos) + "_zip" + filename.substr(pos);
        }
        else{
            dst = filename + "_zip";
        }

        return dst;
    }

    //replace character with corresponding code
    static void Code(std::unordered_map<int, std::string> &tm, std::ifstream &fin, std::ofstream &fout){
        Reset(fin);

        fout << tm.size() << " ";//message to unzip
        for(auto itr = tm.begin(); itr != tm.end(); ++itr)
            fout << itr->first << " " << itr->second << " ";//remind this extra space!!!
        

        unsigned char temp;//read a character
        unsigned char buff = 0;//we can only write byte to file, not bit
        int cnt = 0;//how many bits have been read
        const int buff_size = CHAR_BIT;//total bits we can read
        std::queue<char> q;

        while(fin >> std::noskipws >> temp){//do not skip whitespaces
            auto code = tm[temp];
            for(auto x: code)
                q.push(x);

            while(!q.empty()){
                buff <<= 1;
                auto &f = q.front();
                buff |= (f - '0');
                q.pop();
                ++cnt;

                if(cnt >= buff_size){
                    fout << buff;
                    buff = 0;
                    cnt = 0;
                }
            }
        }
        //total bits may not be buff_size times
        if(buff != 0){
            fout << buff;
        }
    }

public:

    static void Zip(std::string &src){
        std::string dst = GetDstName(src);
        Zip(src, dst);
    }

    static void Zip(std::string &src, std::string &dst){
        //open file
        std::ifstream fin;
        std::ofstream fout;
        OpenFile(fin, src);
        OpenFile(fout, dst);

        //zip
        MakeRecord(fin, src);  
        auto tm = HuffmanTree::GetMap(record, ASCII_SZ);
        Code(tm, fin, fout);

        //save file
        CloseFile(fin);
        CloseFile(fout);
    }
};

int Compresser::record[ASCII_SZ];



int main(int argc, char **argv){
    if(argc <= 1){
        fprintf(stderr, "no file specified\n");
    }
    else if(argc == 2){
        std::string src = argv[1];
        Compresser::Zip(src);
        fprintf(stdout, "done\n");
    }
    else if(argc == 3){
        std::string src = argv[1],
                    dst = argv[2];
        Compresser::Zip(src, dst);
        fprintf(stdout, "done\n");
    }
    else{
        fprintf(stderr, "too many arguments\n");
    }
}