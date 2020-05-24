#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main(int argc, char const *argv[])
{
	/* code */
	char s1[] = "hellow", s2[] = "orld";
	// char s2[10] = "hellow"
	strcat(s1, s2);
	printf("the updated s1 is %s\n", s1);
	return 0;
}