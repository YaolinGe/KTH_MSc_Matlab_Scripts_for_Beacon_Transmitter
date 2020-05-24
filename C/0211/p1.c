#include<stdio.h>
#include<string.h>

int main()
{
	char s[] = "yaolin ahahah";
	char a[] = "is okay";
	printf("%s and %s is both blu\n", s, a);
	strcpy(s,a);
	printf("%s\n",s );
	printf("%s\n",a );
	printf("\n");

	return 0;
}