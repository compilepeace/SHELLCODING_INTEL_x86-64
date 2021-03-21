; Author: Abhinav Thakur
; Email : compilepeace@gmail.com
; 
; Description: cheetsheet for majorly used instructions.
; Syscall convention for x86-64 System V ABI: RDI, RSI, RDX, RCX, R8, R9 
;
; Compile: 
;   yasm -f elf64 -g dwarf2 -l cheetsheet.lst ./cheetsheet.asm
;   ld cheetsheet.o  -o cheetsheet

segment .data
quot    dq 0
rem     dq 0
var1    dd  1998                ; after assembling 'var1' will be replaced with an address
var2    dq  4097
name    db  "Abhinav", 0x0
arr1    times 10 dq 1           ; array of 10 quad words initialized by with value 1
arr2    times 5 dw  7           ; array of 5 words (2 bytes) initialized with value 7


segment .bss
arr3    times 5 dw  7           ; array of 5 words (2 bytes) (.bss is zero initialized)


segment .text
global _start

_start:
    ; RDI, RSI, RDX, RCX, R8, R9 
    ; ssize_t write (int fd, const void *buf, size_t count)
    xor rax, rax
    mov rdi, rax
    mov dil, 0x2        ; fd = stderr
    mov rsi, name       ; buf = name
    xor rdx, rdx
    add rdx, 8          ; count = 8
    mov rax, 1          ; syscall number = 1
    syscall

;----------------------------------------------------------------------------------------------------
    ; MATHEMATICAL INSTRUCTIONS
    ; neg instruction (performs 2's complement on its operand) setting the sign flag (SF) and
    ; zero flag (ZF) to make it possible to perform conditional operations.
    mov rbx, 0x2        ; moving 0010 to rbx
    neg rbx
    neg dword [var1]
    neg dword  [var1]

    ; add/sub instruction - takes either a memory or a register as operand
    ;                       only one of the operands can be a memory reference.
    ; sets up multiple flags in rflags register -
    ;   > OF (overflow flag sets if addtion overflows)
    ;   > SF (sign flag is set as per the sign bit of addition result)
    ;   > ZF (zero flag is set if addition result is 0)
    xor rax, rax
    add rax, 0xe        ; rax += 0xe
    inc rax             ; adds 1 to a register/memory operand
    sub rax, 0xe        ; rax -= 0xe
    dec rax             ; subtracts 1 to a register/memory operand

    ; imul/mul instruction - for signed/unsigned operations.
    ; 
    ; imul has 3 forms - 
    ;   > 1 operand     :   imul qword [var1]       (stores rdx:rax = rax * var1)
    ;                       imul [high], rdx        (get the higher order bits of the result from rdx)
    ;                       imul [low], rax         (get the lower order bits of the result from rax)
    ;
    ; NOTE: result here in 1 operand type is stored in rdx:rax (where rdx stores the most/least 
    ;       significant bits of the result)   
    ;
    ;
    ;   > 2 operands    :   imul rcx, 100           (rcx = rcx*100)
    ;                       imul rcx, [x]           (rcx = rcx*x)
    ;              
    ;   > 3 operands    :   imul rbx, [x], 100      (stores rbx = x*100)
    ;                       imul rdx, rbx, 50       (stores rdx = rbx*50)
    ;
    mov     ecx, 0x3
    mov     dword [var1], ecx
    mov     eax, ecx
    imul    ecx         ; edx:eax = ecx*eax = 3*3 = 9
    imul    ecx, eax    ; ecx = ecx*eax = 9*3 = 27
    imul    ecx, eax, 2 ; ecx = eax*2   = 3*2 = 6

    ; idiv/div instruction - for signed/unsigned operations. 
    ;                        for stores result in rdx:rax 
    ; 
    ; NOTE: before using div/idiv, remember to set rdx too (as rdx:rax is the dividend).
    ;       For signed division use cdq and for unsigned division, suggested zero out rdx.
    ;
    ; - signed division of RDX:RAX by r/m32. 
    ; - Always sign extend into RDX with the value inside RAX.
    ; - The 'cdq/cqo' (convert dword to qword) copies the sign (bit 31) of the
    ;   value in eax to every bit position in the edx.
    ;
    mov     eax, dword [var1]
    imul    eax, eax, 19        ; eax = eax*19
    cdq     ; sign extend rax to rdx:rax | edx = signbit(eax) | edx:eax = signbit(eax)
    idiv    dword [var1]        ; rax = rax/var1
    mov     [quot], rax         ; rax is set to quotient
    mov     [rem], rdx          ; rdx is set to remainder


 ;----------------------------------------------------------------------------------------------------


;----------------------------------------------------------------------------------------------------
    ; mov instruction
    mov rax, 0xaaaaaaaaaaaaaaaa
    mov [var2], rax             ; moving into memory (var2 = 0xaaaaaaaaaaaaaaaa)
    mov rax, var1               ; load an immediate value
    mov eax, [var1]             ; load from memory

    ; moving a constant/immediate value
    ; If you specify a 8-bit register such as al or a 160bit register
    ; such as ax, the remaining bits of the register are unaffected.
    ; However, if you specify a 32-bit register such as eax, the 
    ; remaining bits (upper 32-bits) are cleared out (set to 0).
    mov rax, 0xaaaaaaaaaaaaaaaa
    mov rax, 0x64
    mov rax, 0xaaaaaaaaaaaaaaaa
    mov eax, 0x64               ; same as- mov rax, 0x64 (clearing off upper 32 bits of rax)


    ; mov'ing with zero/sign extension (movsx, movzx, movsxd)
    ; extension instructions seems to work only on byte & word sizes
    ; in case you want to move a dword, use special instruction movsxd.
    mov     rax, 0xbbbbbbbbbbbbbbbb
    movsx   rax, byte [name + 3]        ; access 4th byte starting from label/address 'name'
    movzx   rbx, word [arr2]
    movsxd  rcx, dword [var1]
    nop

    ; conditional mov - better than 'branching' instructions. For branching instructions CPU needs to 
    ;                   perform 'branch pridiction' (inside CPU instruction pipeline) which is 
    ;                   sometimes is a correct guess and sometimes not (which interrupts the
    ;                   CPU instruction pipeline and slows down the process).
    ; 
    ; NOTE: These conditional instructions doesn't work with operands of immediate value.
    ;
    ; Important Instructions - 
    ;   cmovz   - move if zero flag is set
    ;   cmovg   - move if greater than 0
    ;   cmovl   - move if result was 'l'ess than 0
    ;   cmovle  - move if result is 'l'ess than or 'e'qual to 0
    ;   cmovnz  - move if zero flag not set
    ;   cmovge  - move if result was 'g'reater than or 'e'qual to 0
    ; 
    ;   src : mem or r16/r32/r64
    ;   dest: mem or r16/r32/r64
    ;
    mov     ecx, 0xdeadbeef   
    mov     eax, 0x5            ; rax = 0x5
    neg     eax                 ; rax = -0x5
    cmovl   eax, ecx            ; if (result < 0) rax = 0xdeadbeef; move performed

    mov     dword [var2], 0x10  ; var2 = 16
    mov     eax, dword [var2]   ; eax = var2
    sub     eax, 0x2            ; eax -= 2
    cmovle  rax, rcx            ; (eax > 0): no move performed     

 ;----------------------------------------------------------------------------------------------------

    ; void _exit(int status);
    xor rax, rax
    add rax, 60
    mov rdi, 0x10
    syscall
