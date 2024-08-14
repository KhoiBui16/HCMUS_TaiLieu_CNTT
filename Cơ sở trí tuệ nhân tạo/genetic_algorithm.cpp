#include<bits/stdc++.h>

#define DNA_LENGTH 8
#define MAX_N 255

#define MAX_LOOP 11
#define MIX_TIMES n * 2
using namespace std;
typedef pair<int, int> ii;

int n, a, b, c;

// math functions
int factor(int x){
    // equation: ax^2 + bx + c = 0
    return abs(a * x * x + b * x + c);
}
string intToBinary(int x){
    string s;
    if(x == 0) return "0";
    while(x){
        s.push_back(x % 2 + '0');
        x /= 2;
    }
    // length standardization
    for(int i = s.size() + 1; i <= DNA_LENGTH; ++i)
        s = "0" + s;
    return s;
}
int binaryToInt(string s){
    int res = 0;
    for(int i = 0; i < s.size(); ++i)
        res = res * 2 + s[i] - '0';
    return res;
}

// Generate and combine funtions
vector<ii> generatePopulation(int n){
    vector<ii> p;
    srand(time(NULL));
    for(int i = 0; i < n; ++i){
        int value = rand() % MAX_N;
        int dist = factor(value);
        p.push_back({dist, value});
    }
    return p;
}


void select(vector<ii>& p, int n){
    // sort the candidates
    // remove the bad candidates and keep only n best candidates
    sort(p.begin(), p.end());
    while(p.size() > n)
        p.pop_back();
}

void reproduct(vector<ii>& p, int idx1, int idx2){
    // find 2 DNA chains of the parents
    string s1 = intToBinary(p[idx1].second);
    string s2 = intToBinary(p[idx2].second);

    // create 2 children
    string b1, b2;
    for(int i = 0; i < DNA_LENGTH / 2; ++i){
        b1.push_back(s1[i]);
        b2.push_back(s2[i]);
    }
    for(int i = DNA_LENGTH / 2; i < DNA_LENGTH; ++i){
        b1.push_back(s2[i]);
        b2.push_back(s1[i]);
    }
    // add children to the population
    int v1 = binaryToInt(b1);
    int v2 = binaryToInt(b2);
    p.push_back({factor(v1), v1});
    p.push_back({factor(v2), v2});
}

void crossOver(vector<ii>& p){
    // add a half from other
    for(int i = 1; i <= p.size() / 2; ++i){
        int value = rand() % MAX_N;
        int dist = factor(value);
        p.push_back({dist, value});
    }
}

void mutate(vector<ii>& p){
    // The mutation occurs in 1/8 of the population
    for(int i = 0; i < p.size() / 8; ++i){
        int idx = 4 + rand() % 4;
        if(p[i].second == 0 || p[i].second == MAX_N) continue;

        // generate two mutations in the gene
        int v1 = p[i].second + 1;
        int v2 = p[i].second - 1;
        p.push_back({factor(v1), v1});
        p.push_back({factor(v2), v2});
    }
}

void mix(vector<ii>& p, int n){
    srand(time(NULL));
    for(int i = 0; i < MIX_TIMES; ++i){
        int u = rand() % n;
        int v = rand() % n;
        while(v == u) v = rand() % n;
        swap(p[u], p[v]);
    }
}

void print(vector<ii>& p, int n){
    cout << "Current Population: ";
    for(int i = 0; i < n; ++i)
        cout << p[i].second << " ";
    cout << "\n";
}


int main(){
    srand(time(NULL));
    cout << "The size of population: "; cin >> n;
    for(int tc = 1; tc <= 100; ++tc){
    cout << "input equation ax^2 + bx + c = 0\n";
    cout << "a, b, c = ";
    cin >> a >> b >> c;

    // generate population and mix
    vector<ii> population = generatePopulation(n);
    print(population, n);

    int theBest = population[0].second;
    int curEPS = population[0].first;
    int loop = 0;
    // combination
    do{
        // reproduct
        for(int i = 0; i + 1 < n; i += 2){
            reproduct(population, i, i + 1);
        }

        // keep n-best candidates
        select(population, n);

        // save the current answer
        theBest = population[0].second;
        curEPS = population[0].first;
        print(population, n);

        // gene mutation
        mutate(population);

        // migrate from other areas
        // crossOver(population);
        // mix the candidates to avoid self-combination
        mix(population, n);

        ++loop;
    }
    while(                                                                                      loop <= MAX_LOOP);
    cout << "The answer is: " << theBest << endl;
    }
    return 0;
}
