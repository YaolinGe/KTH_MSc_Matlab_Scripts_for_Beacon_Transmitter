#include<stdio.h>
void foo(void)
{
    int i=0;
    while(1)
    {
        if(0>1)
        {
            printf("it is true");
            return;
        }

printf("h!");
        if(i++>10)
        {
            printf("this is not true");
            break;
        }
    }
    printf("helo!");
}

int main()
{
    printf("hello sunday!\n");
    foo();
}




