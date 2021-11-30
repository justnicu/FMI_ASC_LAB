.data
  scanfFormat: .asciz "%[^\n]"
  printfFormat: .asciz "alo %d\n"

  chDelim: .asciz " "

  instructionSet: .space 505
  currInstruction: .space 10

  matrix: .space 405
  nrLines: .long 0
  nrColumns: .long 0
  nrRotations: .long 0
  nrElements: .long 0

  sign: .long 1

  zece: .long 10

  aux: .long 0

  returnMemoryAddress: .long 0

.text

# Increments the number of rotations
rot90d:
  movl nrRotations, %eax
  inc %eax
  movl %eax, nrRotations
  pushl returnMemoryAddress
  ret

# Divide the matrix by the value on stack
divLoop:
  cmp $0, %ecx
  je exitOpLoop
  dec %ecx
  popl %ebx
  xor %edx, %edx
  movl (%edi, %ecx, 4), %eax
  idiv %ebx
  movl %eax, (%edi, %ecx, 4)
  pushl %ebx

# Multiply the matrix by the value on stack
mulLoop:
  cmp $0, %ecx
  je exitOpLoop
  dec %ecx
  popl %ebx
  xor %edx, %edx
  movl (%edi, %ecx, 4), %eax
  imull %ebx
  movl %eax, (%edi, %ecx, 4)
  pushl %ebx

# Subtract from the matrix the value on stack
subLoop:
  cmp $0, %ecx
  je exitOpLoop
  dec %ecx
  popl %ebx
  subl %ebx, (%edi, %ecx, 4)
  pushl %ebx

# Add to the matrix the value on stack
addLoop:
  cmp $0, %ecx
  je exitOpLoop
  dec %ecx
  popl %ebx
  addl %ebx, (%edi, %ecx, 4)
  pushl %ebx

# Takes the integers from the stack and puts them in the matrix
letLoop:
  cmp $0, %ecx
  je exitOpLoop
  popl %ebx
  dec %ecx
  movl %ebx, (%edi, %ecx, 4)
  jmp letLoop

# Push a value on stack so we can pop something when we exit
let:
  pushl $0
  jmp letLoop

# Exits from the operation loop
exitOpLoop:
  popl %ebx
  pushl returnMemoryAddress
  ret

# Loads the matrix in %edi and puts in %ecx the number of elements
operationInit:
  movl nrLines, %eax
  xor %edx, %edx
  mull nrColumns
  movl %eax, %ecx
  lea matrix, %edi
  ret

# If it is a variable we shouldn't do anything in the case of the matrix
variable:
  pushl returnMemoryAddress
  ret

# Pushes the integer onto the stack
endInteger:
  xor %edx, %edx
  imull sign
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
  movl $1, %eax
  movl %eax, sign
  xor %ecx, %ecx
  xor %ebx, %ebx
  xor %eax, %eax
  mov currInstruction, %edi
  jmp nextDigit

# Updates the sign in case of a negative integer and converts the string into an integer
negativeInt:
  movl $-1, %eax
  movl %eax, sign
  xor %ecx, %ecx
  xor %ebx, %ebx
  xor %eax, %eax
  mov currInstruction, %edi
  inc %ecx
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
  cmp $45, %eax # '-' = 45
  je negativeInt
  cmp $97, %eax # if less than 'a' = 97 than it is an integer
  jl integer
  movl currInstruction, %eax
  xor %ebx, %ebx
  inc %ebx
  call instructionToDec
  cmp $0, %eax # only one letter means it is a variable
  je variable
  call operationInit
  movl currInstruction, %eax
  xor %ebx, %ebx
  call instructionToDec
  cmp $108, %eax # 'l' = 108
  je let
  cmp $97, %eax # 'a' = 97
  je addLoop
  cmp $115, %eax # 's' = 115
  je subLoop
  cmp $109, %eax # 'm' = 109
  je mulLoop
  cmp $100, %eax # 'd' = 100
  je divLoop
  cmp $114, %eax # 'r' = 114
  je rot90d

# Read the input (instructionSet)
readInput:
  pushl $instructionSet
  pushl $scanfFormat
  call scanf
  popl %ebx
  popl %ebx
  ret

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

# Reads the number of lines and pushes it onto the stack
readLines:
  popl returnMemoryAddress
  jmp integer

# Reads the number of columns and pushes it onto the stack
readColumns:
  popl returnMemoryAddress
  jmp integer

# Matrix specific initialization (reads the name of the matrix, the number of lines and the number of columns)
matrixInit:
  call nextInstruction
  call readLines
  call nextInstruction
  call readColumns
  popl nrColumns
  popl nrLines
  call nextInstruction
  ret

# Takes the first instruction and saves it into currInstruction
startSolve:
  pushl $chDelim
  pushl $instructionSet
  call strtok
  popl %ebx
  popl %ebx
  mov %eax, currInstruction
  call matrixInit
  jmp solve

# WIP
writeLoop:
  cmp $0, %ecx
  je exit
  dec %ecx

  movl nrElements, %eax
  dec %eax
  subl %ecx, %eax

  movl %ecx, aux

  pushl (%edi, %eax, 4)
  pushl $printfFormat
  call printf
  popl %ebx
  popl %ebx

  movl aux, %ecx

  jmp writeLoop

# Writes the matrix
writeOutput:
  call operationInit
  movl %ecx, nrElements
  jmp writeLoop

.global main

main:
  call readInput
  jmp startSolve

# System call to end the process
exit:
  movl $1, %eax
  xor %ebx, %ebx
  int $0x80
