.data
  scanfFormat: .asciz "%s"
  printfFormat: .asciz "%s\n"

  hexCode: .space 105
  assemblyCode: .space 505

  firstHalfOfNumber: .long 0

  idx: .long 0

.text

# Read the input (hexCode)
readInput:
  pushl $hexCode
  pushl $scanfFormat
  call scanf
  popl %ebx
  popl %ebx
  ret

# Load in memory hexCode and assemblyCode
initialize:
  movl $hexCode, %edi
  movl $assemblyCode, %esi
  xor %ecx, %ecx
  xor %edx, %edx
  ret

# Write the output (assemblyCode)
writeOutput:
  pushl $assemblyCode
  pushl $printfFormat
  call printf
  popl %ebx
  popl %ebx
  ret

# Convert the letter from hex to dec
convertLetter:
  sub $65, %eax
  add $10, %eax
  ret

# Convert the number from ascii to int
convertNumber:
  sub $48, %eax # '0' = 48
  ret

# Take the ascii value from %eax (representing a hex value) and replace it with the decimal representation
convert:
  cmp $65, %eax # 'A' = 65
  jge convertLetter
  jmp convertNumber

# Place in %eax the dec value
loadInstruction:
  xor %eax, %eax
  movb (%edi, %ecx, 1), %al
  inc %ecx
  call convert
  ret

# Puts the let operation in the output ('l' = 108, 'e' = 101, 't' = 116, ' ' = 32)
putLet:
  movb $108, (%esi, %edx, 1)
  inc %edx
  movb $101, (%esi, %edx, 1)
  inc %edx
  movb $116, (%esi, %edx, 1)
  inc %edx
  movb $32, (%esi, %edx, 1)
  inc %edx
  ret

# Puts the add operation in the output ('a' = 97, 'd' = 100, 'd' = 100, ' ' = 32)
putAdd:
  movb $97, (%esi, %edx, 1)
  inc %edx
  movb $100, (%esi, %edx, 1)
  inc %edx
  movb $100, (%esi, %edx, 1)
  inc %edx
  movb $32, (%esi, %edx, 1)
  inc %edx
  ret

# Puts the sub operation in the output ('s' = 115, 'u' = 117, 'b' = 98, ' ' = 32)
putSub:
  movb $115, (%esi, %edx, 1)
  inc %edx
  movb $117, (%esi, %edx, 1)
  inc %edx
  movb $98, (%esi, %edx, 1)
  inc %edx
  movb $32, (%esi, %edx, 1)
  inc %edx
  ret

# Puts the mul operation in the output ('m' = 109, 'u' = 117, 'l' = 108, ' ' = 32)
putMul:
  movb $109, (%esi, %edx, 1)
  inc %edx
  movb $117, (%esi, %edx, 1)
  inc %edx
  movb $108, (%esi, %edx, 1)
  inc %edx
  movb $32, (%esi, %edx, 1)
  inc %edx
  ret

# Puts the div operation in the output ('d' = 100, 'i' = 105, 'v' = 118, ' ' = 32)
putDiv:
  movb $100, (%esi, %edx, 1)
  inc %edx
  movb $105, (%esi, %edx, 1)
  inc %edx
  movb $118, (%esi, %edx, 1)
  inc %edx
  movb $32, (%esi, %edx, 1)
  inc %edx
  ret

# Reads the encoded operation and puts it in %eax
encodedOp:
  call loadInstruction
  sal $4, %eax
  mov %eax, firstHalfOfNumber
  call loadInstruction
  or firstHalfOfNumber, %eax
  ret

# Puts the required operation in the output
operation:
  call encodedOp
  cmp $0, %eax
  je putLet
  cmp $1, %eax
  je putAdd
  cmp $2, %eax
  je putSub
  cmp $3, %eax
  je putMul
  cmp $4, %eax
  je putDiv

# Takes the ascii value (found in %eax) of the variable and puts it in the ouput
variable:
  call encodedOp
  movb %al, (%esi, %edx, 1)
  inc %edx
  movb $32, (%esi, %edx, 1)
  inc %edx
  ret

# Puts the '-' (45 ascii) sign in the output then jumps to integer
negativeInteger:
  movb $45, (%esi, %edx, 1)
  inc %edx
  jmp integer

# Puts '0' (48 ascii) and a space (32 ascii) in the output
zero:
  movb $48, (%esi, %edx, 1)
  inc %edx
  movb $32, (%esi, %edx, 1)
  inc %edx
  ret

# Break the digits loop
exitDigits:
  ret

# Take the digits of the integer and pushes their ascii encoding on the stack
digits:
  cmp $0, %eax
  je exitDigits


# WIP
integer:
  call encodedOp
  cmp $0, %eax
  je zero
  jmp digits

# Establish the operation type
type:
  cmp $12, %eax
  je operation
  cmp $10, %eax
  je variable
  cmp $9, %eax
  je negativeInteger
  cmp $8, %eax
  je integer

# Break the solve loop
exitSolve:
  ret

# Loop to process every instruction
solve:
  call loadInstruction
  call type
  cmp $0, (%edi, %ecx, 1)
  je exitSolve
  jmp solve

.global main

main:
  call readInput
  call initialize
  call solve
  call writeOutput
  jmp exit

# System call to end the process
exit:
  movl $1, %eax
  xor %ebx, %ebx
  int $0x80
