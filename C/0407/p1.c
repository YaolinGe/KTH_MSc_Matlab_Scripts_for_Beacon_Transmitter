#include<stdio.h>
#include<string.h>

// int a[10]={1,2,3,3,2,2,3,4};

int a[10];

int * re(void)
{
	return a;
}

void ini(int *p, int len)
{
	int i;
	for(i=0;i<len;i++)
		p[i] = 1;
}

int main()
{
	int i;
	int *p = re();
	int b[10];
	int *q = b;
	ini(q, 10);
	for(i = 0;i<10;i++)
	{
		printf("the value of index %d is %d \n", i, a[i]);
		printf("the value of index %d is %d \n", i, p[i]);
		printf("the value of index %d is %d  and its size of is %lu\n", i, q[i], sizeof(b));
	}

	int c[10];
	printf("the size of c is %lu", sizeof(c));

	memset(c, 2, sizeof(c));
	for(i=0;i<10;i++)
		printf("here is %d\n", c[i]);


}

