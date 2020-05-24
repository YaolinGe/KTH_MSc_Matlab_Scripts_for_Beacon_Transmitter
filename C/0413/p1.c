#include<stdio.h>


int main()
{
	int N = 6;
	int c = N / 2;
	printf("c is %d\n", c);
	int d = (int) (((float)N)/2 + 0.5) - 1;
	printf("d is %d\n", d);
}