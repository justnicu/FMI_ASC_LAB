#include <stdio.h>

int x, ans;

int main()
{
	scanf("%d", &x);

	__asm__
	(
		"pusha;"

		"mov x, %eax;"
		"mov $0, %ebx;"
		"mov $0, %ecx;"

		"loop_begin:;"
		"cmp %ebx, %eax;"
		"je exit;"
		"sar %eax;"
		"add $1, %ecx;"
		"jmp loop_begin;"

		"exit:;"
		"mov %ecx, ans;"

		"popa;"
	);

	printf("%d\n", ans);
	return 0;
}
