#include <stdio.h>

int x, ans;

int main()
{
	scanf("%d", &x);

	__asm__
	(
		"pusha;"

		"mov x, %eax;"
		"mov $0, %ecx;"

		"loop_begin:;"
		"mov $1, %ebx;"
		"and %eax, %ebx;"
		"add %ebx, %ecx;"
		"mov $0, %ebx;"
		"cmp %ebx, %eax;"
		"je exit;"
		"sar $1, %eax;"
		"jmp loop_begin;"

		"exit:;"
		"mov %ecx, ans;"

		"popa;"
	);

	printf("%d\n", ans);
	return 0;
}
