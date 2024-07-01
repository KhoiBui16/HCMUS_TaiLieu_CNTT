#include<iostream>
using namespace std;

int main()
{
	long c1,c2,c,n;
	cout<<"This program will print out the first n numbers in Fibonacy"<<endl;
	cout<<"Please input n:";
	cin>>n;
	c1=1;
	c2=1;
	if (n<0)
		cout<<"Input wrong";
	else
	{
		for (int i=1; i<=n; i++)
		{
			if (i==1 || i==2) cout<<"1 ";
			else
			{
				c=c1+c2;
				cout<<c<<" ";
				c2=c1;
				c1=c;
			}
		}
	}
	return 0;
}
