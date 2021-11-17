.data
	x: .long -1
	y: .long 1
	shr_res: .space 4
	shl_res: .space 4
	sar_res: .space 4
	sal_res: .space 4

.text
.globl _start

_start:
	mov x, %eax
	shr $1, %eax
	mov %eax, shr_res

	mov x, %eax
	shl $1, %eax
	mov %eax, shl_res

	mov x, %eax
	sar $1, %eax
	mov %eax, sar_res

	mov x, %eax
	sal $1, %eax
	mov %eax, sal_res

	mov $1, %eax
	mov $0, %ebx
	int $0x80
