.data
	n: .long 5
	s: .space 4
.text

.globl _start

_start:
	sub $1, n
	mov n, %ecx

etloop:
	add %ecx, s
	loop etloop
	jmp etexit

etexit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
