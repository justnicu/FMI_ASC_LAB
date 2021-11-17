#include <stdio.h>

int x, y;

int main()
{
	scanf("%d%d", &x, &y);

	__asm__
	(
		"pusha;"

		"mov x, %eax;"
		"mov y, %ebx;"
		"xor %ebx, %eax;"
		"xor %eax, %ebx;"
		"xor %ebx, %eax;"

		"mov %eax, x;"
		"mov %ebx, y;"

		"popa;"
	);

	printf("%d %d\n", x, y);
	return 0;
}
