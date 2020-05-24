#include<stdio.h>
#include<stdlib.h>
#include<math.h>

float lea_sq(float a, float b, float c)
{
	float d1 = a - b;
	float d2 = b - c;
	float d3 = a - c;
	return min(d1, d2);
}

int main()
{
	printf("%f\n", lea_sq(12,2435, 543));
	return 0;
}