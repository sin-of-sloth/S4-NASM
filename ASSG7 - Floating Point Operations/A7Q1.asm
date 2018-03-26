section .bss
radius      : resq 1
temp        : resd 1



section .data

prompt1     : db 0Ah, "Enter the radius of the circle : "
len1        : equ $- prompt1
msg2        : db 0Ah, "The perimeter of the circle is : "
len2        : equ $- msg2
format1     : db "%lf", 0
format2     : db "%lf", 10
newl        : db 0Ah


section .text

global main:
extern scanf
extern printf

main:

mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, len1
int 80h

call _readFloat

fstp qword[radius]

fld qword[radius]
mov dword[temp], 44
fimul dword[temp]
mov dword[temp], 7
fidiv dword[temp]


mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h

call _printFloat

_exit:
call _newLinePrinter
call _newLinePrinter
mov eax, 1
mov ebx, 0
int 80h


_readFloat:

    push ebp
    mov ebp, esp
    sub esp, 8

    lea eax, [esp]
    push eax
    push format1
    call scanf
    fld qword[ebp - 8]

    mov esp, ebp
    pop ebp
    ret


_printFloat:
    push ebp
    mov ebp, esp
    sub esp, 8

    fst qword[ebp - 8]
    push format2
    call printf
    mov esp, ebp
    pop ebp
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
