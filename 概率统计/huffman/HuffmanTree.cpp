#ifndef HUFFMAN_TREE_CPP
#define HUFFMAN_TREE_CPP

#include "macro.hpp"
#include <cstring>
#include <vector>
#include <queue>
#include <unordered_map>
#include <string>
#include <set>


class HuffmanTree{
private:

    typedef long long WeightType;

    //tree_node
    struct htnode{
        int symbol;//character
        WeightType weight;//how many
        htnode *left;
        htnode *right;
        htnode(int s = '0', WeightType w = 0, htnode *l = nullptr, htnode *r = nullptr): symbol(s), weight(w), left(l), right(r){}
        bool operator <(const htnode &other){ return this->weight > other.weight;}//each time get the node with smallest weight
    };

    static htnode *make_htnode(int symbol, WeightType weight){
        return new htnode(symbol, weight);
    }

    struct cmp{//comparator for priority_queue
        bool operator()(htnode *&a, htnode *&b){
            return *a < *b;
        }
    };


    static htnode* root;
    static std::set<int> check;
    static std::unordered_map<int, std::string> treemap;


    DISABLE_ALL(HuffmanTree);

    static void InitTree(){
        root = nullptr;
        check.clear();
        treemap.clear();
    }

    static void BuildTree(int *record, int sz){
        std::priority_queue<htnode*, std::vector<htnode*>, cmp> q;

        for(int i = 0; i < sz; ++i){
            if(record[i]){
                check.insert(i);
                q.push(make_htnode(i, record[i]));
            }
        }

        while(q.size() != 1){
            auto node1 = q.top();   q.pop();
            auto node2 = q.top();   q.pop();//choose the smallest two nodes
            auto new_node = make_htnode(-1, node1->weight + node2->weight);//merge
            new_node->left = node1;
            new_node->right = node2;
            q.push(new_node);
        }

        root = q.top();
    }

    static void DestroyTree(htnode *&root){
        if(root){
            DestroyTree(root->left);
            DestroyTree(root->right);
            delete root;
            root = nullptr;
        }
    }

    static void Helper(htnode* root, std::string huffmancode){//set treemp[symbol] = huffmancode
        if(!root)     return;//nullptr, return

        if(check.find(root->symbol) != check.end()){//record
            treemap[root->symbol] = huffmancode;
            return;
        }

        Helper(root->left, huffmancode + "0");
        Helper(root->right, huffmancode + "1");
    }

public:
    static std::unordered_map<int, std::string> GetMap(int *record, int sz){
        InitTree();
        BuildTree(record, sz);
        std::string initcode = "";//initial with empty code
        Helper(root, initcode);
        DestroyTree(root);
        return treemap;
    }
};

HuffmanTree::htnode* HuffmanTree::root = nullptr;
std::set<int> HuffmanTree::check;
std::unordered_map<int, std::string> HuffmanTree::treemap;

#endif