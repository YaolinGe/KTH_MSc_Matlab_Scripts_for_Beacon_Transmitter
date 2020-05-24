#include<stdio.h>


int cnt = 1;
void test(void)
{
    if (cnt++>100)
    {
        printf("time is out!\n"); 
    }
    else
    {
        printf("here!\n");
        test();
    }
}

int main()
{
    test();
}