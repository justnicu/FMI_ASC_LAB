.data
  scanfFormat: .asciz "%[^\n]"
  printfFormat: .asciz "%d\n"

  printString: .asciz "%s\n"

  chDelim: .asciz " "

  instructionSet: .space 505
  currInstruction: .space 10

  returnMemoryAddress: .long 0

  dig: .long 0
  zece: .long 10

.text

# Read the input (instructionSet)
readInput:
  pushl $instructionSet
  pushl $scanfFormat
  call scanf
  popl %ebx
  popl %ebx
  ret

# WIP
let:
  pushl returnMemoryAddress
  ret

# Takes the first 2 numbers in the stack, computes their sum and pushes it onto the stack
add:
  popl %ebx
  popl %eax
  add %ebx, %eax
  pushl %eax
  pushl returnMemoryAddress
  ret

# Takes the first 2 numbers in the stack, computes their sub and pushes it onto the stack
sub:
  popl %ebx
  popl %eax
  sub %ebx, %eax
  pushl %eax
  pushl returnMemoryAddress
  ret

# Takes the first 2 numbers in the stack, computes their mul and pushes it onto the stack
mul:
  popl %ebx
  popl %eax
  xor %edx, %edx
  mul %ebx
  pushl %eax
  pushl returnMemoryAddress
  ret

# Takes the first 2 numbers in the stack, computes their div and pushes it onto the stack
div:
  popl %ebx
  popl %eax
  xor %edx, %edx
  div %ebx
  pushl %eax
  pushl returnMemoryAddress
  ret

# Pushes the integer onto the stack
endInteger:
  pushl %eax
  pushl returnMemoryAddress
  ret

# Goes through the digits and pushes them onto the stack
nextDigit:
  movb (%edi, %ecx, 1), %bl
  cmp $0, %ebx
  je endInteger
  sub $48, %ebx # '0' = 48
  xor %edx, %edx
  mull zece
  add %ebx, %eax
  inc %ecx
  jmp nextDigit

# Converts the string to an integer
integer:
  xor %ecx, %ecx
  xor %ebx, %ebx
  xor %eax, %eax
  mov currInstruction, %edi
  jmp nextDigit

# Converts the instruction to a decimal value
instructionToDec:
  xor %ebx, %ebx
  movb (%eax, %ebx, 1), %bl
  movl %ebx, %eax
  ret

# Jumps to the appropriate process for the current instruction
execute:
  popl returnMemoryAddress
  movl currInstruction, %eax
  call instructionToDec
  cmp $108, %eax # 'l' = 108
  je let
  cmp $97, %eax # 'a' = 97
  je add
  cmp $115, %eax # 's' = 115
  je sub
  cmp $109, %eax # 'm' = 109
  je mul
  cmp $100, %eax # 'd' = 100
  je div
  jmp integer

# Takes the next instruction and puts it into currInstruction
nextInstruction:
  pushl $chDelim
  pushl $0
  call strtok
  popl %ebx
  popl %ebx
  mov %eax, currInstruction
  ret

# Breaks the solve loop
exitSolve:
  jmp writeOutput

# Loop to process every instruction
solve:
  cmp $0, currInstruction
  je exitSolve
  call execute
  call nextInstruction
  jmp solve

# Takes the first instruction and saves it into currInstruction
startSolve:
  pushl $chDelim
  pushl $instructionSet
  call strtok
  popl %ebx
  popl %ebx
  mov %eax, currInstruction
  jmp solve

# Writes the output (first element in stack)
writeOutput:
  pushl $printfFormat
  call printf
  popl %ebx
  popl %ebx
  jmp exit

.global main

main:
  call readInput
  jmp startSolve

# System call to end the process
exit:
  movl $1, %eax
  xor %ebx, %ebx
  int $0x80
