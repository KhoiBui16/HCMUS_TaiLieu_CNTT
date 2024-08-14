#include <bits/stdc++.h>
#define RAND_MAX 32767
using namespace std;

double myRand(){
    return 1.0 * rand() / RAND_MAX;
}

double estimatePIBySubSquares(int n){
    // divide into n * n subsquares
    double subArea = 1.0 / (1LL * n * n);
    double sumArea = 0;

    for(int i = 1; i <= n; ++i){
        for(int j = 1; j <= n; ++j){
            // I(0.5, 0.5)
            double x = 1.0 / n * i - 0.5 / n;
            double y = 1.0 / n * j - 0.5 / n;
            double distSqr = (x - 0.5) * (x - 0.5) + (y - 0.5) * (y - 0.5);
            if(distSqr <= 0.5 * 0.5)
                sumArea += subArea;
        }
    }
    // S circle / S square = pi / 4;
    return sumArea * 4.0 / 1.0;
}

double estimatePIByRand(int n){
    int cnt = 0;
    for(int i = 1; i <= n; ++i){
        double x = myRand();
        double y = myRand();
        if((x - 0.5) * (x - 0.5) + (y - 0.5) * (y - 0.5) <= 0.5 * 0.5)
            ++cnt;
    }
    return 4.0 * cnt / n;
}



int main(){
    srand(time(NULL));
    int a[] = {10, 100, 1000, 10000};
    for(int n : a){
        cout << "PI estimated by subsquares:\t " << estimatePIBySubSquares(n) << endl;
        cout << "PI estimated using random:\t " << estimatePIByRand(n) << endl;
    }
    return 0;
}
