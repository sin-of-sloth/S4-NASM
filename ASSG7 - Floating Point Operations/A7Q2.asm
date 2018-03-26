section .bss

temp        : resd 1
float1      : resq 1
a           : resq 1
b           : resq 1
c           : resq 1
root1       : resq 1
root2       : resq 1

section .data

format1     : db "%lf", 0
msg         : db 0Ah, "Quadratic equation of the form ax² + bx + c = 0"
len         : equ $- msg
prompt1     : db 0Ah, "Enter the value of a : "
len1        : equ $- prompt1
prompt2     : db 0Ah, "Enter the value of b : "
len2        : equ $- prompt2
prompt3     : db 0Ah, "Enter the value of c : "
len3        : equ $- prompt3
msg4        : db 0Ah, "The equation has no real roots."
len4        : equ $- msg4
msg5        : db 0Ah, "The real roots are : ", 0Ah
len5        : equ $- msg5
newl        : db 0Ah
space       : db " "
format2     : db "%lf", 10

section .text

global main:
extern scanf
extern printf

main:

mov eax, 4
mov ebx, 1
mov ecx, msg
mov edx, len
int 80h

mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, len1
int 80h

call _readFloat
fstp qword[a]

mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, len2
int 80h

call _readFloat
fstp qword[b]

mov eax, 4
mov ebx, 1
mov ecx, prompt3
mov edx, len3
int 80h

call _readFloat
fstp qword[c]

;;;;;;;;;;;;;;;;;;;;;;;b²
fld qword[b]
fmul st0
fstp qword[float1]

;;;;;;;;;;;;;;;;;;;;;;;4ac
fld qword[a]
fld qword[c]
mov dword[temp], 4
fimul dword[temp]
fmul st1

;;;;;;;;;;;;;;;;;;;;;;;b²-4ac
fld qword[float1]
fsub st1
fstp qword[float1]
ffree st0
ffree st1

fldz
fcom qword[float1]

fstsw ax
sahf

jna _hasRealRoots

mov eax, 4
mov ebx, 1
mov ecx, msg4
mov edx, len4
int 80h

jmp _exit

_hasRealRoots:

fld qword[float1]
fsqrt
fstp qword[float1]

;;;;;;;;;;;;;;;;;;;making b negative
fld qword[b]
fchs

;;;;;;;;;;;;;;;;;;-b + D
fld qword[float1]
fadd st1


;;;;;;;;;;;;;;;;;;(-b + D)/ 2a
mov dword[temp], 2
fidiv dword[temp]
fdiv qword[a]
fstp qword[root1]
ffree st0

;;;;;;;;;;;;;;;;;;making b negative
fld qword[b]
fchs 

;;;;;;;;;;;;;;;;;;-b - D
fld qword[float1]
fchs
fadd st1

;;;;;;;;;;;;;;;;;;(-b - D)/ 2a
mov dword[temp], 2
fidiv dword[temp]
fdiv qword[a]
fstp qword[root2]
ffree st0


mov eax, 4
mov ebx, 1
mov ecx, msg5
mov edx, len5
int 80h

fld qword[root1]
call _printFloat

fld qword[root2]
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

_spacePrinter:
pusha
mov eax, 4
mov ebx, 1
mov ecx, space
mov edx, 1
int 80h
popa
ret
