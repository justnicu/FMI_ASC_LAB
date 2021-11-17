.data
	x: .long 4109
	positive_text: .asciz "Numar pozitiv\n"
	negative_text: .asciz "Numar negativ\n"
	zero_text: .asciz "Numarul zero!\n"
.text
.globl _start

_start:
	mov x, %eax
	cmp $0, %eax
	jg positive
	je zero
	jmp negative

positive:
	mov $4, %eax
	mov $1, %ebx
	mov $positive_text, %ecx
	mov $15, %edx
	int $0x80
	jmp exit

zero:
	mov $4, %eax
	mov $1, %ebx
	mov $zero_text, %ecx
	mov $15, %edx
	int $0x80
	jmp exit

negative:
	mov $4, %eax
	mov $1, %ebx
	mov $negative_text, %ecx
	mov $15, %edx
	int $0x80
	jmp exit

exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
