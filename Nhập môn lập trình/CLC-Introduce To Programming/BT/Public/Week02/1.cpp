#include <iostream>
using namespace std;

int main()
{
	long n;
	double s,i;
	cout<<"This program will calculate S(n)= 1/2+3/4+5/6+...+(2*n+1)/(2*n+1)"<<endl;
	cout<<"Please input n:"; cin>>n;
	s=0; i=1;
	while (i<=(2*n+1))
	{
		s=s+i/(i+1);
		i=i+2;
	}
	cout.precision(6);
	cout<<"S("<<n<<")="<<s;
	return 0;
}
