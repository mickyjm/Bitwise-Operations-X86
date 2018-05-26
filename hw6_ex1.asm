; Assignment 6: Bit Operations
; Exercise 1: Bitwise Operations for Big Data
; Author: Michael (Micky) Mangrobang

%include "asm_io.inc"

segment .data
    msg1    db      "Enter an integer: ", 0
    msg2    db      "Binary representation: ", 0
    msg3    db      "Semantic: ", 0
    msg4    db      "YNGR/IPHN/HULU/SWRS count: ", 0
    msg5    db      "*/ANDR/*/STRK count: ", 0
    codes   db      "YNGR", 0, "OLDR", 0, "ANDR", 0, "IPHN", 0, "NFLX", 0, "HULU", 0, "SWRS", 0, "STRK", 0
    four_spaces db  "    ",0

segment .bss
	input	resd  1

segment .text
    global      asm_main

asm_main:
    enter	0,0                         ; setup
    pusha                               ; setup

    mov     eax, msg1
    call    print_string
    call    read_int
    mov     [input], eax
    mov     eax, msg2
    call    print_string
    mov     ebx, [input]
    mov     ecx, 020h
    mov     edx, 004h

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; Question #1: Printing binary representation of input integer ;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printBit:
    shl     ebx, 1
    setc    al
    movzx   eax, al
    call    print_int
    dec     edx
    cmp     edx, 0
    jg      nextBit
    mov     edx, 004h
    mov     eax, 020h
    call    print_char

nextBit:
    loop    printBit
    call    print_nl

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; Question #2: Printing semantics of input integer ;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov     eax, msg3
    call    print_string
    call    print_nl
    mov     ebx, [input]
    mov     ecx, 008h

Q2START:
    mov     eax, four_spaces
    call    print_string
    shl     ebx, 1
    setc    al
    cmp     al, 1
    je      b1OLDR
    mov     eax, codes
    jmp     b2

b1OLDR:
    mov     eax, codes + 5

b2:
    call    print_string
    mov     eax, 020h
    call    print_char
    shl     ebx, 1
    setc    al
    cmp     al, 1
    je      b2IPHN
    mov     eax, codes + 10
    jmp     b3

b2IPHN:
    mov     eax, codes + 15

b3:
    call    print_string
    mov     eax, 020h
    call    print_char
    shl     ebx, 1
    setc    al
    cmp     al, 1
    je      b3HULU
    mov     eax, codes + 20
    jmp     b4

b3HULU:
    mov     eax, codes + 25

b4:
    call    print_string
    mov     eax, 020h
    call    print_char
    shl     ebx, 1
    setc    al
    cmp     al, 1
    je      b4STRK
    mov     eax, codes + 30
    jmp     Q2CONT

b4STRK:
    mov     eax, codes + 35

Q2CONT:
    call    print_string
    call    print_nl
    dec     ecx
    cmp     ecx, 0
    je      Q3BEGIN
    jmp     Q2START

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; Question #3: Counting particular persons ;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Q3BEGIN:
    mov     ebx, [input]
    mov     ecx, 008h
    mov     edx, 000h

Q3START:
    mov     eax, 00Fh
    and     eax, ebx
    cmp     eax, 006h
    jne     Q3SHIFT
    inc     edx

Q3SHIFT:
    shr     ebx, 4
    loop    Q3START
    mov     eax, msg4
    call    print_string
    mov     eax, edx
    call    print_int
    call    print_nl

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; Question #4: Counting less specific persons ;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov     eax, msg5
    call    print_string
    mov     ebx, [input]
    mov     ecx, 008h
    mov     edx, 000h

Q4START:
    mov     eax, 005h
    and     eax, ebx
    cmp     eax, 001h
    jne     Q4SHIFT
    inc     edx

Q4SHIFT:
    shr     ebx, 4
    loop    Q4START
    mov     eax, edx
    call    print_int
    call    print_nl


    popa                    ; cleanup
    mov	    eax, 0          ; cleanup
    leave                   ; cleanup
    ret                     ; cleanup
