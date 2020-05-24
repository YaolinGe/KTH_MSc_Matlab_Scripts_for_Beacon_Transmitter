#include<stdio.h>


int main()
{
	char x = 10;
	char y[x];
	int i;

	y[0] = 20;
	// y[2] = 2.34;
	y[9] = 's';
	for( i= 0; i<x;i++)
	{
		printf("the value in the %dth array is %d\n",i, y[i] );
	}
	printf("endl\n");
	i=i+1000;
	printf("the value in the %dth array is %d\n",i, y[i] );
	printf("the size of y is %lu\n",sizeof(y) );
	return 0;
}