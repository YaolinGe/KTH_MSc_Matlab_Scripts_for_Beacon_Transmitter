#include<stdio.h>
#include<string.h>
#include<stdlib.h>

// extern int a=1;
int main()
{
	int a = (1<<9);
	int b = (1<<10);
	int c = (1<<0);
	int d = (1<<11);
	printf("the vaue of a is %d\n", a);
	printf("the vaue of a is %d\n", b);
	printf("the vaue of a is %d\n", c);
	printf("the vaue of a is %d\n", d);


	int LEN = 10;
	int e[LEN];
	memset(e, 0, LEN*sizeof(size_t));
	for (int i = 0; i<LEN;i++)
	{
		printf("%d\n",e[i] );
	}
	printf("\n");

	char str[] = "beautiful earth";
	printf("%s", str);
	memset(str, '*', 6);
	printf("%s", str);
	return 0;
}