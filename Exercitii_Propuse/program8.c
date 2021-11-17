#include <stdio.h>

int x, ans;

int main()
{
	scanf("%d", &x);

	__asm__
	(
		"pusha;"

                "mov x, %eax;"
                "mov $0, %ebx;" /// intializam oglinditul cu 0
                "mov $31, %ecx;" /// pozitia bitului oglindit

                "oglindit:;" /// onglindeste bitul actual in EBX
                "mov $1, %edx;" /// bitul actual
                "and %eax, %edx;"
                "shl %ecx, %edx;"
                "or %edx, %ebx;"
                "sub $1, %ecx;"
                "shr $1, %eax;"
                "jz verif_palindrom;"
                "jmp oglindit;"

                "verif_palindrom:;" /// verificam daca reprezentarea in binar e sub forma de pa>
                "mov x, %eax;"
                "cmp %eax, %ebx;"
                "je palindrom;"
                "jmp not_palindrom;"

                "palindrom:;"
                "mov $1, %eax;"
		"jmp exit;"

		"not_palindrom:;"
		"mov $0, %eax;"
		"jmp exit;"

		"exit:;"
		"mov %eax, ans;"

		"popa;"
	);

	printf("%d\n", ans);
	return 0;
}
