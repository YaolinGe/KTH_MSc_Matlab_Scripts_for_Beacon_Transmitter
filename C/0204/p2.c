#include<stdio.h>

#include<stdlib.h>
#include<string.h>

int main()
{
	char a[10];
	int b[10];

	printf("the size of char array is %lu\n",sizeof(a) );
	printf("the size of int array is %lu\n", sizeof(b));
 
 	memset(a, 0, 10);
 	for (int i = 0;i<10;i++)
 		printf("a[%d] is %d\n", i, a[i]);
	return 0;
}