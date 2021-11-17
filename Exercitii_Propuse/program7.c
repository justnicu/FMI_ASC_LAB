#include <stdio.h>

int x, ans;

int main()
{
	scanf("%d", &x);

	__asm__
	(
		"pusha;"

		"mov x, %eax;" /// input
		"mov $0, %ebx;" /// cel mai lung sir de biti egal cu 1
		"mov $0, %ecx;" /// lungimea sirului curent

		"loop_begin:;" /// loop cat timp am biti in EAX
		"mov $1, %edx;" /// variabila auxiliara
		"and %eax, %edx;"
		"jz new_sequence;"
		"add $1, %ecx;"
		"jmp max;"

		"max:;" /// calculeaza maximul dintre EBX si ECX si il stocheaza in EBX
		"cmp %ebx, %ecx;"
		"jg change;"
		"jmp next;"

		"change:;" ///actualizeaza maximul
		"mov %ecx, %ebx;"
		"jmp next;"

		"next:;" /// trece la urmatoarea iteratie a loop-ului
		"sar $1, %eax;"
		"jnz loop_begin;"
		"jmp exit;"

		"new_sequence:;" /// reseteaza secventa actuala
		"mov $0, %ecx;"
		"jmp next;"

		"exit:;" /// se da valoare lui ans
		"mov %ebx, ans;"

		"popa;"
	);

	printf("%d\n", ans);
	return 0;
}
