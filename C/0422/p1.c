#include<stdio.h>


int main()
{
    // int a;
    // int *p = &a;
    // int **q = &p;
    // int ***r = &q;
    // printf("the value of a is %d and its addresss is %lu\n", a, &a);
    // printf("the value of p is %d and its addresss is %lu and dereference is %d\n", p, &p, *p);
    // printf("the value of q is %d and its addresss is %lu and dereference is %d\n", q, &q, *q);
    // printf("the value of r is %d and its addresss is %lu and dereference is %d\n", r, &r, *r);
    // printf("*r is %d **r is %d and ***r is %d ****r is error\n", *r, **r, ***r);

    // int e;
    // int *p = &e;
    // printf("the value of *&p is %p and &*p is %p and their locations are %d and %d\n", *&p, &*p, *&p, &*p);

    // // const int x = 3; // x cannot be changed
    // const int *p = &x; // *p cannot be changed
    // int const *q = &x; // same as above
    // int * const r = &x; // p cannot be changed to point to other addresses, 
    //                     //p=&y is illegal, but *p can be changed
    // const int * const t = &x; // both p and x cannot be changed

// int x = 3;
// const int *p = &x;
// x = 4;
// printf("x is %d and *p is %d\n", x, *p);

// const int y = 4;
// int *q = &y;
// *q = 5;
// printf("*q is %d and y is %d \n", *q, y);


float f = 3.14;
int *p = (int *)&f;
int x = (int) f;
printf("%d\n", *p);
printf("%d\n", x);

int *q ;
int a =  10;
q =  &a;
printf("q is %d\n", *q);
q++;
printf("q is %d\n", *q);
}