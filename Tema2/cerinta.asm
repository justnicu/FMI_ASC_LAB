.data
  scanfFormat: .asciz "%d"
  printfFormat: .asciz "%d "
  printfFailure: .asciz "-1\n"
  endlChar: .asciz "\n"
  endlPrintfFormat: .asciz "%s"

  n: .long 0
  m: .long 0
  array: .space 364

  nTimes3: .long 0
  nnTimes3: .long 0
  aux: .long 0
  x: .long 0

  nextPos: .space 11164
  lastPos: .space 128
  freq: .space 128
  mask: .space 364

  pos: .long 0
  val: .long 0

  step: .long 0

.text

# Reads the next number from stdin and puts it in the memory address situated in top of the stack
readNum:
  pushl %ebp
  mov %esp, %ebp

  movl %ecx, aux

  pushl 8(%ebp)
  pushl $scanfFormat
  call scanf
  popl %eax
  popl %eax

  movl aux, %ecx

  popl %ebp
  ret

# Prints the number from the top of the stack to stdout
printNum:
  pushl %ebp
  mov %esp, %ebp

  movl %ecx, aux

  pushl 8(%ebp)
  pushl $printfFormat
  call printf
  popl %eax
  popl %eax

  movl aux, %ecx

  popl %ebp
  ret

# Exits the readArray procedure
exitReadArray:
  popl %ebp
  ret

# Reads the array from stdin
readArray:
  pushl %ebp
  mov %esp, %ebp

  cmp nTimes3, %ecx
  je exitReadArray

  pushl $x
  call readNum
  popl %eax

  movl x, %eax
  movl %eax, (%edi, %ecx, 4)

  inc %ecx
  call readArray

  popl %ebp
  ret

# Reads n, m and the array from stdin
readInput:
  pushl %ebp
  mov %esp, %ebp

  pushl $n # cin >> n;
  call readNum
  popl %eax

  movl n, %eax
  xor %edx, %edx
  movl $3, %ebx
  mull %ebx
  movl %eax, nTimes3

  xor %edx, %edx
  movl n, %ebx
  mull %ebx
  movl %eax, nnTimes3

  pushl $m # cin >> m;
  call readNum
  popl %eax

  xor %ecx, %ecx
  lea array, %edi
  call readArray

  popl %ebp
  ret

# Exits the printArray procedure
exitPrintArray:
  popl %ebp
  ret

# Prints the generated array
printArray:
  pushl %ebp
  mov %esp, %ebp

  cmp nTimes3, %ecx
  je exitPrintArray

  pushl (%edi, %ecx, 4) # cout << v[i]
  call printNum
  popl %eax

  inc %ecx
  call printArray

  popl %ebp
  ret

# Prints the solution to stdout
printSolution:
  pushl %ebp
  mov %esp, %ebp

  xor %ecx, %ecx
  lea array, %edi
  call printArray

  pushl $endlChar # cout << "\n";
  pushl $endlPrintfFormat
  call printf
  popl %eax
  popl %eax

  popl %ebp
  ret

# WIP
exitPrecalcFreq:
  popl %ebp
  ret

# WIP
updateFreq:
  lea freq, %edi
  movl (%edi, %eax, 4), %ebx
  inc %ebx
  movl %ebx, (%edi, %eax, 4)
  lea array, %edi
  jmp returnPrecalcFreq


# WIP
precalcFreq:
  pushl %ebp
  mov %esp, %ebp

  cmp nTimes3, %ecx
  je exitPrecalcFreq

  movl (%edi, %ecx, 4), %eax
  cmp $0, %eax
  jne updateFreq
returnPrecalcFreq:
  inc %ecx
  call precalcFreq

  popl %ebp
  ret

# WIP
exitPrecalcMask:
  popl %ebp
  ret

# WIP
updateMask:
  lea mask, %edi
  movl (%edi, %ecx, 4), %ebx
  inc %ebx
  movl %ebx, (%edi, %ecx, 4)
  lea array, %edi
  jmp returnPrecalcMask

# WIP
precalcMask:
  pushl %ebp
  mov %esp, %ebp

  cmp nTimes3, %ecx
  je exitPrecalcMask

  movl (%edi, %ecx, 4), %eax
  cmp $0, %eax
  jne updateMask
returnPrecalcMask:
  inc %ecx
  call precalcMask

  popl %ebp
  ret

# WIP
exitInitLastPos:
  popl %ebp
  ret

# WIP
initLastPos:
  pushl %ebp
  mov %esp, %ebp

  inc %ecx

  xor %eax, %eax
  subl m, %eax
  subl $1, %eax
  movl %eax, (%edi, %ecx, 4)

  cmp n, %ecx
  je exitInitLastPos

  call initLastPos

  popl %ebp
  ret

# WIP
initNextPos:
  pushl %ebp
  mov %esp, %ebp

  # for (int pos = 3 * n - 1; pos >= 0; pos--)
  #   for (int val = 1; val <= n; val++)
  #     nextPos[pos][val] = 3 * n + m + 1

  movl nTimes3, %ecx
  movl %ecx, pos

  forPos:
    movl pos, %ecx
    dec %ecx
    movl %ecx, pos

    movl $0, %ecx
    movl %ecx, val

    forVal:
      movl val, %ecx
      inc %ecx
      movl %ecx, val

      # pos * (n + 1) + val
      xor %edx, %edx
      movl pos, %eax
      movl n, %ebx
      inc %ebx
      mull %ebx
      movl val, %ebx
      addl %ebx, %eax

      movl nTimes3, %ebx
      movl m, %ecx
      inc %ecx
      addl %ecx, %ebx

      movl %ebx, (%edi, %eax, 4)

      movl val, %ecx
      cmp n, %ecx
      jne forVal

    movl pos, %ecx
    cmp $0, %ecx
    jne forPos

  popl %ebp
  ret

# WIP
precalcNextPos:
  pushl %ebp
  mov %esp, %ebp

  movl nTimes3, %ecx
  movl %ecx, pos

  forPos_precalcNextPos:
    movl pos, %ecx
    dec %ecx
    movl %ecx, pos

    movl $0, %ecx
    movl %ecx, val

    forVal_precalcNextPos:
      movl val, %ecx
      inc %ecx
      movl %ecx, val

      # pos * (n + 1) + val
      xor %edx, %edx
      movl pos, %eax
      movl n, %ebx
      inc %ebx
      mull %ebx
      movl val, %ebx
      addl %ebx, %eax

      # nextPos[pos][val] = nextPos[min(pos + 1, 3 * n - 1)][val];
      movl nTimes3, %ecx
      dec %ecx
      cmp pos, %ecx
      je skip_calcNextPos

      movl %eax, %ebx
      movl n, %ecx
      inc %ecx
      addl %ecx, %ebx

      movl (%edi, %ebx, 4), %ecx
      movl %ecx, (%edi, %eax, 4)

      skip_calcNextPos:

      # if (array[pos] > 0)
      #   nextPos[pos][array[pos]] = pos;

      lea array, %edi
      movl pos, %eax
      movl (%edi, %eax, 4), %ebx
      cmp $0, %ebx
      je skip_updateNextPos

      lea nextPos, %edi
      # pos * (n + 1) + array[pos]
      movl n, %eax
      inc %eax
      movl pos, %ecx
      xor %edx, %edx
      mull %ecx
      addl %ebx, %eax

      movl pos, %ebx
      movl %ebx, (%edi, %eax, 4)

      skip_updateNextPos:

      lea nextPos, %edi

      movl val, %ecx
      cmp n, %ecx
      jne forVal_precalcNextPos

    movl pos, %ecx
    cmp $0, %ecx
    jne forPos_precalcNextPos

  popl %ebp
  ret

# WIP
precalculations:
  pushl %ebp
  mov %esp, %ebp

  lea array, %edi

  xor %ecx, %ecx
  call precalcFreq

  lea array, %edi

  xor %ecx, %ecx
  call precalcMask

  lea lastPos, %edi

  xor %ecx, %ecx
  call initLastPos

  lea nextPos, %edi

  xor %ecx, %ecx
  call initNextPos

  lea nextPos, %edi

  xor %ecx, %ecx
  call precalcNextPos

  popl %ebp
  ret

# WIP
finished:
  call printSolution
  jmp exit

# WIP
failure:
  pushl %ebp
  mov %esp, %ebp

  pushl $printfFailure
  call printf
  popl %eax

  popl %ebp
  ret

# WIP
backtracking:
  pushl %ebp
  mov %esp, %ebp

  movl 8(%ebp), %eax
  movl %eax, step

  # checkMask
  checkMask:
  movl 8(%ebp), %eax
  movl %eax, step

  lea mask, %edi
  movl step, %ecx
  movl (%edi, %ecx, 4), %eax

  cmp $1, %eax
  jne skip_checkMask

  lea array, %edi
  movl step, %ecx
  movl (%edi, %ecx, 4), %eax

  lea lastPos, %edi
  movl (%edi, %eax, 4), %ebx
  pushl %ebx
  pushl %eax
  movl step, %ecx
  movl %ecx, (%edi, %eax, 4)
  inc %ecx
  pushl %ecx
  call backtracking
  popl %ecx
  popl %eax
  popl %ebx
  lea lastPos, %edi
  movl %ebx, (%edi, %eax, 4)
  jmp return

  skip_checkMask:

  # checkFinished
  checkFinished:
  movl 8(%ebp), %eax
  movl %eax, step
  cmp nTimes3, %eax
  je finished

  # for val (checkFreq && checkLast && checkNext)
  movl $0, %ecx
  movl %ecx, val

  forVal_bkt:
    movl val, %ecx
    inc %ecx
    movl %ecx, val

    # checkFreq
    checkFreq:
    lea freq, %edi
    movl val, %eax
    movl (%edi, %eax, 4), %ecx
    cmp $3, %ecx
    je nextVal

    # checkLast
    checkLast:
    lea lastPos, %edi
    movl val, %eax
    movl (%edi, %eax, 4), %ebx

    movl 8(%ebp), %eax
    movl %eax, step

    movl step, %eax
    subl %ebx, %eax
    dec %eax
    movl m, %ebx
    subl %ebx, %eax
    cmp $0, %eax
    jl nextVal

    # checkNext
    checkNext:
    movl 8(%ebp), %eax
    movl %eax, step

    # nextPos[step][val] - step * (n + 1) + val
    lea nextPos, %edi
    movl step, %eax
    movl n, %ebx
    inc %ebx
    xor %edx, %edx
    mull %ebx
    movl val, %ebx
    addl %ebx, %eax
    movl (%edi, %eax, 4), %ecx

    movl step, %eax
    subl %eax, %ecx
    movl m, %eax
    subl %eax, %ecx
    dec %ecx

    cmp $0, %ecx
    jl nextVal

    # update array
    update_array:
    movl 8(%ebp), %eax
    movl %eax, step

    # array[step] = val
    lea array, %edi
    movl step, %ecx
    movl val, %eax
    movl %eax, (%edi, %ecx, 4)

    # freq[val]++
    lea freq, %edi
    movl val, %eax
    movl (%edi, %eax, 4), %ebx

    pushl %ebx

    inc %ebx
    movl %ebx, (%edi, %eax, 4)

    # lastPos[val] = step
    lea lastPos, %edi
    movl val, %eax
    movl step, %ebx

    movl (%edi, %eax, 4), %ecx
    pushl %ecx

    movl %ebx, (%edi, %eax, 4)

    # save val
    movl val, %eax
    pushl %eax

    # call bkt(step + 1)
    movl step, %eax
    inc %eax
    pushl %eax
    call backtracking
    popl %eax

    movl 8(%ebp), %eax
    movl %eax, step

    # restore val
    popl %eax
    movl %eax, val

    # restore lastPos
    popl %eax
    lea lastPos, %edi
    movl val, %ebx
    movl %eax, (%edi, %ebx, 4)

    # restore freq
    lea freq, %edi
    movl val, %eax
    popl %ebx
    movl %ebx, (%edi, %eax, 4)

    nextVal:

    movl val, %ecx
    cmp n, %ecx
    jne forVal_bkt

  return:

  popl %ebp
  ret

.global main

main:
  call readInput
  call precalculations

  pushl $0
  call backtracking
  popl %ebx

  call failure

# System call to end the process
exit:
  movl $1, %eax
  xor %ebx, %ebx
  int $0x80
