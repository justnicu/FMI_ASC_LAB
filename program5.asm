.data
	x: .long 33
	y: .long 31
	adev: .byte 1
	not_res: .space 4
	and_res: .space 4
	test_res: .space 4
	or_res: .space 4
	xor_res: .space 4
.text
.globl _start

_start:
	mov adev, %eax
	not %eax
	mov %eax, not_res

	mov x, %eax
	and y, %eax
	mov %eax, and_res

	mov x, %eax
	test y, %eax
	mov %eax, test_res

	mov x, %eax
	or y, %eax
	mov %eax, or_res

	mov x, %eax
	xor y, %eax
	mov %eax, xor_res

	mov $1, %eax
	mov $0, %ebx
	int $0x80

#expected values:
#not_res = -2
#and_res = 1
#or_res = 63
#xor_res = 62
