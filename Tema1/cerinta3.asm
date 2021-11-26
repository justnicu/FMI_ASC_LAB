.data
  scanfFormat: .asciz "%[^\n]"
  printfFormat: .asciz "%d\n"

  printString: .asciz "%s\n"

  chDelim: .asciz " "

  instructionSet: .space 505
  currInstruction: .space 10

  returnMemoryAddress: .long 0

  var: .long 0
  zece: .long 10

  varArr: .long 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF

.text

# Read the input (instructionSet)
readInput:
  pushl $instructionSet
  pushl $scanfFormat
  call scanf
  popl %ebx
  popl %ebx
  ret

# Pops the number then the variable from the top of the stack and assigns to the variable the value
let:
  popl %ebx
  popl %ecx
  lea varArr, %eax
  movl %ebx, (%eax, %ecx, 4)

  pushl returnMemoryAddress
  ret

# Computes the number of the letter and puts it in var
varToInt:
  mov currInstruction, %edi
  xor %ecx, %ecx
  xor %ebx, %ebx
  movb (%edi, %ecx, 1), %bl
  sub $97, %ebx # 'a' = 97
  movl %ebx, var
  ret

# Pushes the letter value on the stack
pushLetter:
  pushl var
  pushl returnMemoryAddress
  ret

# Check if a variable is already defined and puts its value on the stack
variable:
  call varToInt
  movl var, %ecx
  lea varArr, %eax
  cmp $0xFFFFFFFF, (%eax, %ecx, 4)
  je pushLetter
  pushl (%eax, %ecx, 4)
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

# Converts the %ebx th character of the the instruction to a decimal value
instructionToDec:
  movb (%eax, %ebx, 1), %bl
  movl %ebx, %eax
  ret

# Jumps to the appropriate process for the current instruction
execute:
  popl returnMemoryAddress
  movl currInstruction, %eax
  xor %ebx, %ebx
  call instructionToDec
  cmp $97, %eax # if less than 'a' = 97 than it is an integer
  jl integer
  movl currInstruction, %eax
  xor %ebx, %ebx
  inc %ebx
  call instructionToDec
  cmp $0, %eax # only one letter means it is a variable
  je variable
  movl currInstruction, %eax
  xor %ebx, %ebx
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
