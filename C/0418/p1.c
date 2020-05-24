#include<stdio.h>
#include<math.h>
#include<limits.h>
#include<string.h>
#include<stdlib.h>
// #include<ctime>

#define A 10
#define FCY 126000000
#define FALSE 0
#define TRUE 1

struct complex
{
    int32_t re;
    int32_t im;
};

int foo(int a)
{
    if (a>0)
    {
        printf("hello world!");
        return 1;
    }
    return 0;
}

typedef struct complex Complex;

int main()
{
printf("false + false is %d\n", FALSE + FALSE);
printf("true + true is %d\n", TRUE + TRUE);
printf("false + true is %d\n", FALSE + TRUE);


    // int a = 10;
    // int b[a];
    // int i;
    // for(i = 0;i<10;i++)
    // printf("the value of index  %d is %d\n", i, b[i]);

// int N = 2048;
// int Fs = 160000;
// int32_t div = (int32_t) N * (FCY/Fs);
// // int32_t quo = ((int32_t)N * (FCY%Fs)) / Fs;
// int32_t quo = 0;
// int32_t a = div + quo;
// printf("the value is %d \n", a);
// printf("N is %d \n", N);
// printf("FCY is %d \n", FCY);
// printf("INT_MAX is %d \n", INT_MAX);
// printf("N * FCY is %d \n", 2048 * 126000000);

// printf("N * FCY is %d \n", N * FCY);
// printf("N / Fs is %d \n", N / Fs);
// printf("FCY / Fs is %d \n", FCY/Fs);
// printf("the value is %d \n",( N * FCY )/ Fs);




// int a = 10;
// printf("the value of this is %d \n", (int)(126000000 % 160000));
    // printf("the value returned from function fofo is %d\n", foo(10));
    // printf("the value returned from function fofo is %d\n", foo(-10));

// int i;
// int a = 0;
// for(i = 0;i<10;i++)
//     a+=foo();
    

// printf(" a is %d \n", a);
//     // int i;
    // for(i = 0;i<10;i++)
    // if(i>3)
    // printf("the value of index %d is %d\n", i, 10*i);
    // int a[10];
    // int i;

    // for(i = 0;i<10;i++)
    // {
    //     printf("the index %d is value %d \n", i, a[i]);
    // }

// int val; int num; // equal to some values
// int op=val/num;
// is there a risk that op gets zeroed?
// double op=1.2;
// int op=val/num; // = 1
// int op=val%num; // Is the remainder, in the sense that .2=remainder/num
// if val/num==0 and  val%num!=0 -> you have accidentally zeroed by integer division
// int op=val/num + (int)(val%num!=0); // Rounds up I think
// int a = 34;
// int dc_factor = 32;
// int b = a / dc_factor + (int)(a%dc_factor!=0);
// printf("a is %d and b is %d and dc_factor is %d\n", a, b, dc_factor);
// // int a = 11;
// printf("a\% modulo is not equal to zero %d\n", (a%5==0));
// printf("the value of a is %d and a is ot equal zero %d?\n", a, a!=0);

// int a[10];
// int i;
// for(i = 0;i<10;i++)
// {
//     if (i<3)
//     a[i] = 0;
//     else if (i>=3&&i<8)
//     a[i] = i;
//     else
//         a[i] = 0;
//     printf("the following list prints out the array!\n");
    
// }
// for(i = 0;i<=10;i++)
// printf("the value of a[%d] is %d \n", i,a[i]);



}