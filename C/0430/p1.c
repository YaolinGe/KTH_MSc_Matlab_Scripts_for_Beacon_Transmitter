#include<stdio.h>

int max_index_array_int32_t(int32_t *p, int N)
{
    int index = 0;
    int32_t temp = 0;
    int i;
    for (i = 0;i<N;i++)
        if (temp<p[i])
        {
            temp = p[i];
            printf("temp is %d\n", temp);
            index = i;
        }
    return index;
}

void print_array(int32_t *p, int N)
{
    int i; 
    for(i = 0;i<N;i++)
    printf("%d position value is %d\n", i, p[i]);
}

int main()
{
    int32_t a[10];
    int i;
    for(i = 0;i<10;i++)
    a[i] = i;
    a[4] = 100;
    print_array(a, 10);
    int index = max_index_array_int32_t(a, 10);
    printf("the amximum valeu in array is %d and index is %d\n", a[index], index);
}