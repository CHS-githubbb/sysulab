#include <string>
#include <unordered_map>
#include <set>
#include <fstream>
#include <sstream>
#include <iostream>
#include <vector>

using std::string;
using std::unordered_map;
using std::set;
using std::ifstream;
using std::stringstream;
using std::cout;
using std::endl;
using std::vector;

//mips op maps to binary
unordered_map<string, string> um = {
    //r
    {"add", "100000"},
    {"sub", "100010"},
    {"and", "100100"},
    {"or", "100101"},
    {"sll", "000000"},
    {"slt", "101010"},
    //i
    {"addiu", "001001"},
    {"andi", "001100"},
    {"ori", "001101"},
    {"slti", "001010"},
    {"xori", "001110"},
    //b
    {"beq", "000100"},
    {"bne", "000101"},
    {"bltz", "000001"},//counter ex
    //l/s
    {"sw", "101011"},
    {"lw", "100011"},
    //j
    {"j", "000010"},
    {"jal", "000011"},
    {"jr", "001000"},//counter ex
    //halt
    {"halt", "111111"}
};

//classify, help coding
set<string> rIns = {"add","sub","and","or","sll","slt"};
set<string> iIns = {"addiu", "andi", "ori", "slti", "xori"};
set<string> bIns = {"beq", "bne", "bltz"};
set<string> lsIns = {"sw", "lw"};
set<string> jIns = {"j", "jal", "jr"};
set<string> haltIns = {"halt"};
set<string> counterExIns = {"sll", "bltz", "jr"};




void OpenFile(ifstream &fin, string filename){
    fin.open(filename);
    if(!fin.is_open()){
        fprintf(stderr, "Can not open file: %s\n", filename.c_str());
        exit(0);
    }
}


void CloseFile(ifstream &fin){
    fin.close();
}


//check which set the op is in
bool In(set<string> &ins_set, string& op){
    return ins_set.find(op) != ins_set.end();
}


//dec to 5'bXXXXX
void Dec2Bin(string& dec){
    stringstream ss(dec);
    int whichReg;
    ss >> whichReg;

    string tmp = "00000";
    int idx = 0;
    //mod 2
    while(whichReg){
        tmp[idx++] = (whichReg % 2) + '0';
        whichReg /= 2;
    }

    dec = "00000";
    int len = 5;
    for(int i = 0; i < len; ++i){//reverse
        dec[len - 1 - i] = tmp[i];
    }
}


//$reg to 5'bXXXXX
void CodeReg(string& reg, string &binary, int pos){
    reg = reg.substr(1);//skip '$'
    Dec2Bin(reg);
    binary.replace(pos, reg.length(), reg);
}


//sa to 5'bXXXXX
void CodeSA(string& reg, string &binary, int pos){
    //reg = reg.substr(1);
    Dec2Bin(reg);
    binary.replace(pos, reg.length(), reg);
}


//immediate to 16'bXXXXXXXXXXXXXXXX
void CodeImmediate(string& immediate, string &binary, int pos){
    stringstream ss(immediate);
    int im;
    ss >> im;
    bool neg = (im < 0);//negative
    im = im < 0 ? -im : im;

    string tmp = "0000000000000000";
    int idx = 0;
    //mod 2
    while(im){
        tmp[idx++] = (im % 2) + '0';
        im /= 2;
    }

    immediate = "0000000000000000";
    int tlen = 16;
    for(int i = 0; i < tlen; ++i){//reverse
        immediate[tlen - 1 - i] = tmp[i];
    }
    //complement code
    if(neg){
        int idx = tlen - 1;
        while(idx >= 0 && immediate[idx] != '1')
            --idx;//find last '1'

        for(int i = 0; i < idx; ++i){
            immediate[i] = (immediate[i] == '0' ? '1' : '0');//negate
        }
    }

    binary.replace(pos, immediate.length(), immediate);
}

//hex to 26'bX...XXX(right shift 2 bits)
void CodeAddr(string& addr, string &binary, int pos){
    int daddr;
    sscanf(addr.c_str(), "%x", &daddr);//hex
    daddr >>= 2;//right shift 2 bits
    string baddr(26, '0');
    
    int idx = 0;
    //mod 2
    while(daddr){
        baddr[idx++] = (daddr % 2) + '0';
        daddr /= 2;
    }

    addr = string(26, '0');
    int tlen = 26;
    for(int i = 0; i < tlen; ++i){//reverse
        addr[tlen - 1 - i] = baddr[i];
    }

    binary.replace(pos, addr.length(), addr);
}



void CodeRIns(string& op, string& binary, stringstream& ss, bool counter){
    string tmp;
    vector<string> oprands;
    while(getline(ss, tmp, ',')){//$x,$y,$z
        oprands.push_back(tmp);
    }

    binary.replace(26, 6, um[op]);//func field

    CodeReg(oprands[0], binary, 16);//rd field

    if(counter){//sll
        CodeReg(oprands[1], binary, 11);//rt field
        CodeSA(oprands[2], binary, 21);//sa field
    }
    else{
        CodeReg(oprands[1], binary, 6);//rs field
        CodeReg(oprands[2], binary, 11);//rt field
    }
}


void CodeIIns(string& op, string& binary, stringstream& ss, bool counter = false){
    string tmp;
    vector<string> oprands;
    while(getline(ss, tmp, ',')){//$x,$y,immediate
        oprands.push_back(tmp);
    }

    binary.replace(0, 6, um[op]);
    CodeReg(oprands[0], binary, 11);//rt field
    CodeReg(oprands[1], binary, 6);//rs field
    CodeImmediate(oprands[2], binary, 16);//immediate field
}


void CodeBIns(string& op, string& binary, stringstream& ss, bool counter = false){
    string tmp;
    vector<string> oprands;
    while(getline(ss, tmp, ',')){//$x,$y,immediate
        oprands.push_back(tmp);
    }

    binary.replace(0, 6, um[op]);
    CodeReg(oprands[0], binary, 6);//rs field

    if(counter){//bltz
        CodeImmediate(oprands[1], binary, 16);
    }
    else{
        CodeReg(oprands[1], binary, 11);//rt field
        CodeImmediate(oprands[2], binary, 16);//immediate field
    }
}


void CodeLSIns(string& op, string& binary, stringstream& ss, bool counter = false){
    string tmp;
    vector<string> oprands;
    while(getline(ss, tmp, ',')){//$x,offset($y)
        oprands.push_back(tmp);
    }

    binary.replace(0, 6, um[op]);
    CodeReg(oprands[0], binary, 11);//rt field

    int pos = oprands[1].find('(');//offset($rs)
    string immediate = oprands[1].substr(0, pos);
    string rs = oprands[1].substr(pos + 1);

    CodeReg(rs, binary, 6);//rs field
    CodeImmediate(immediate, binary, 16);//immediate field
}


void CodeJIns(string& op, string& binary, stringstream& ss, bool counter = false){
    string tmp;
    vector<string> oprands;
    while(getline(ss, tmp, ',')){//$x,offset($y)
        oprands.push_back(tmp);
    }

    if(counter){//jr
        binary.replace(26, 6, um[op]);
        CodeReg(oprands[0], binary, 6);//rs field
    }
    else{
        binary.replace(0, 6, um[op]);
        CodeAddr(oprands[0], binary, 6);
    }
}


void CodeHaltIns(string& op, string &binary, stringstream& ss){
    binary = "11111100000000000000000000000000";//simple case
}




int main(){
    string filename = "mips.txt";
    ifstream fin;
    OpenFile(fin, filename);

    while(!fin.eof()){
        string op;
        string binary_code(32, '0');//32 bits
        fin >> op;

        string oprand;
        fin >> oprand;//$x,$y,$z
        stringstream ss(oprand);

        //which operations
        if(In(rIns, op)){
            CodeRIns(op, binary_code, ss, In(counterExIns, op));            
        }
        else if(In(iIns, op)){
            CodeIIns(op, binary_code, ss);
        }
        else if(In(bIns, op)){
            CodeBIns(op, binary_code, ss, In(counterExIns, op));
        }
        else if(In(lsIns, op)){
            CodeLSIns(op, binary_code, ss);
        }
        else if(In(jIns, op)){
            CodeJIns(op, binary_code, ss, In(counterExIns, op));
        }
        else{//halt
            CodeHaltIns(op, binary_code, ss);
        }

        //output to screen
        fprintf(stdout, "%s\n", binary_code.c_str());        
    }

    CloseFile(fin);
}