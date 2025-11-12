#include <iostream>
#include <queue>
#include <unordered_map>
#include <vector>
#include <string> // Added for getline

using namespace std;

// Node structure for Huffman Tree
struct Node {
    char ch;
    int freq;
    Node *left, *right;

    Node(char c, int f) : ch(c), freq(f), left(nullptr), right(nullptr) {}
};

// Comparator for priority queue (min-heap)
struct Compare {
    bool operator()(Node* l, Node* r) {
        // Primary sort: by frequency (min-heap)
        if (l->freq != r->freq) {
            return l->freq > r->freq;
        }
        
        // if frequencies are the same, forcing a consistent tree.
        return l->ch > r->ch;
    }
};

// Recursive function to generate Huffman Codes
void generateCodes(Node* root, string str, unordered_map<char, string>& huffmanCode) {
    if (!root)
        return;

    // Leaf node contains character
    if (!root->left && !root->right) {
        // Handle the edge case (e.g., input "aaaaa") by assigning "0".
        huffmanCode[root->ch] = (str.empty() ? "0" : str);
    }

    generateCodes(root->left, str + "0", huffmanCode);
    generateCodes(root->right, str + "1", huffmanCode);
}


int main() {
    string text;
    cout << "Enter the string to encode: ";
    getline(cin, text);

    // Handle empty input
    if (text.empty()) {
        cout << "Input string is empty. Nothing to encode." << endl;
        return 0;
    }

    // Count frequency of each character
    unordered_map<char, int> freq;
    for (char ch : text)
        freq[ch]++;

    // Create a priority queue (min-heap) of nodes
    priority_queue<Node*, vector<Node*>, Compare> pq;

    for (auto pair : freq) {
        pq.push(new Node(pair.first, pair.second));
    }

    // Build Huffman Tree
    while (pq.size() != 1) {
        Node* left = pq.top(); pq.pop();
        Node* right = pq.top(); pq.pop();

        // '\0' is used for internal nodes
        Node* sum = new Node('\0', left->freq + right->freq);
        sum->left = left;
        sum->right = right;
        pq.push(sum);
    }

    Node* root = pq.top();

    // Generate Huffman Codes
    unordered_map<char, string> huffmanCode;
    generateCodes(root, "", huffmanCode);

    // Print Huffman Codes
    cout << "\nHuffman Codes:\n";
    for (auto pair : huffmanCode) {
        // Don't print the code for the internal node character if it exists
        if (pair.first != '\0') { 
            cout << "'" << pair.first << "' : " << pair.second << "\n";
        }
    }

    // Encode the input string
    string encoded = "";
    for (char ch : text)
        encoded += huffmanCode[ch];

    cout << "\nEncoded string:\n" << encoded << endl;

    return 0;
}