section .bss

num         : resw 1
upperLimit  : resw 1
sum         : resw 1
fibTerm1    : resw 1 
fibTerm2    : resw 1
digit       : resb 1
temp        : resw 1
noOfDigits  : resw 1



section .data

prompt1 : db 0Ah, "Print fibonacci series upto what number? : "
len1    : equ $- prompt1
msg2    : db 0Ah, "The fibonacci series is : ", 0Ah
len2    : equ $- msg2
space   : db ' '
newl    : db 0Ah


section .text
global _start:
_start:

mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, len1
int 80h

call _readTheNumber
mov ax, word[num]
mov word[upperLimit], ax

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h

mov word[fibTerm1], 0
mov word[fibTerm2], 1

mov word[num], 0
call _printTheNumber
cmp word[upperLimit], 0
je _exit

call _spacePrinter
mov word[num], 1
call _printTheNumber
call _spacePrinter

call _printFibonacciTerms

_exit:

call _newLinePrinter
call _newLinePrinter

mov eax, 1
mov ebx, 0
int 80h



_spacePrinter:
    pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h
    popa
    ret

_newLinePrinter:
    pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, newl
    mov edx, 1
    int 80h
    popa
    ret

_readTheNumber:
    pusha
    mov word[num], 0

    _reader:

        mov eax, 3
        mov ebx, 0
        mov ecx, digit
        mov edx, 1
        int 80h
        
        cmp byte[digit], 10
        je _endReading

        mov ax, word[num]
        mov bx, 10
        mul bx
        sub byte[digit], 30h
        movzx bx, byte[digit]
        add ax, bx
        mov word[num], ax
        jmp _reader
    
    _endReading:
    popa
    ret


_printTheNumber:
    pusha

    mov word[noOfDigits], 0

    cmp word[num], 0
    jne _breakingItDown

    add word[num], 30h
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 80h

    jmp _endPrinting

    _breakingItDown:
        cmp word[num], 0
        je _puttingItBack

        inc word[noOfDigits]
        mov dx, 0
        mov ax, word[num]
        mov bx, 10
        div bx
        push dx
        mov word[num], ax
        jmp _breakingItDown

    _puttingItBack:
        cmp word[noOfDigits], 0
        je _endPrinting

        dec word[noOfDigits]
        pop dx
        mov byte[digit], dl
        add byte[digit], 30h
        mov eax, 4
        mov ebx, 1
        mov ecx, digit
        mov edx, 1
        int 80h

        jmp _puttingItBack
    
    _endPrinting:
    popa
    ret


_printFibonacciTerms:

    mov ax, word[fibTerm1]
    mov bx, word[fibTerm2]
    add ax, bx

    cmp ax, word[upperLimit]
    jg _endFibonacci

    _continueToPrint:

    mov word[sum], ax
    mov word[num], ax
    call _printTheNumber
    call _spacePrinter

    mov ax, word[fibTerm2]
    mov word[fibTerm1], ax
    mov ax, word[sum]
    mov word[fibTerm2], ax
    call _printFibonacciTerms

    _endFibonacci:
    ret
