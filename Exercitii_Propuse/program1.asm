.data
	x: .long 5
	y: .long 9
	z: .long 14
.text
.globl _start

_start:
_a::// paritatea if zero flag
	mov x, %eax
	and $1, %eax

_b::// zero flag mereu
	mov x, %eax
	xor %eax, %eax

_c:// valoarea din EAX nu se schimba indiferent de EBX
	mov x, %eax
	mov y, %ebx
	xor %eax, %ebx
	xor %ebx, %eax

_d::// indepartam LSB-ul (least significant bit)
	mov x, %eax
	mov %eax, %ebx
	sub $1, %ebx
	xor %ebx, %eax

_e:// ????
	mov x, %eax
	mov %eax, %ecx
	mov y, %ebx
	not %ebx
	and %ebx, %eax
	not %ecx
	not %ebx
	and %ecx, %ebx
	or %ebx, %eax

_f::// zero flag mereu????
	mov x, %eax
	mov %eax, %ecx
	not %ecx
	and %ecx, %eax
	mov y, %ebx
	mov %ebx, %ecx
	not %ecx
	and %ecx, %ebx
	or %ebx, %eax
_g:://????
_h::// reprezentarea in binar este plina de 1	
	mov x, %eax
	mov %eax, %ecx
	not %ecx
	or %ecx, %eax
	mov y, %ebx
	mov %ebx, %ecx
	not %ecx
	or %ecx, %ebx
	and %ebx, %eax

_i:
_j:
_k::// simpla adunare si scadere
	mov x, %eax
	mov y, %ebx
	mov z, %ecx
	add %eax, %ebx
	sub %ebx, %ecx

_l::// operatii aritmetice
	mov x, %eax
	mov y, %ebx
	mov z, %ecx
	sal $1, %eax
	add %eax, %ebx
	sal $1, %ebx
	add %ecx, %ebx
	sar $1, %ebx

_m::// operatii aritmetice
	mov x, %eax
	mov y, %ebx
	mov z, %ecx
	add %ecx, %ebx
	add %ebx, %eax
	sal $4, %eax

_n:// operatii matematice
	mov x, %eax
	sar $4, %eax
	mov y, %ebx
	sal $4, %ebx
	mov $0, %ecx
	add %eax, %ecx
	add %ebx, %ecx

_o:
_p:
_q:
_r:
_s:
