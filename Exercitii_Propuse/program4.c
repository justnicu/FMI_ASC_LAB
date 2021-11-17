#include <stdio.h>

int x, ans;

int main()
{
	scanf("%d", &x);

	__asm__
	(
		"pusha;"

		"mov x, %eax;"
		"mov $1, %ebx;"
		"mov $0, %ecx;"

		"loop_begin:;"
		"cmp %eax, %ecx;"
		"je exit;"
		"sal $1, %ebx;"
		"sar $1, %eax;"
		"jmp loop_begin;"

		"exit:;"
		"mov %ebx, ans;"

		"popa;"
	);

	printf("%d\n", ans);
	return 0;
}
