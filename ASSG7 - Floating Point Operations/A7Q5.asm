section .data:

two         : dq 2.000000
format1     : db "%lf", 0
format2     : db "Value using formula : %lf", 10, 0
format3     : db "Value using FSIN : %lf", 10, 0

section .bss

d           : resw 1
sum         : resw 1
temp        : resw 1
n           : resd 1
i           : resw 1
j           : resw 1
t           : resd 1
a           : resq 1
x           : resq 1
e           : resq 1
f           : resq 1
y           : resq 1
val         : resq 1

section .text

global main
extern scanf
extern printf

_print:
    push ebp
    mov ebp,esp
    sub esp,8

    fst qword[ebp-8]
    push format2
    call printf

    mov esp,ebp
    pop ebp
    ret

_print11:
    push ebp
    mov ebp,esp
    sub esp,8

    fst qword[ebp-8]
    push format3
    call printf

    mov esp,ebp
    pop ebp
    ret

_read:
    push ebp
    mov ebp,esp
    sub esp,8

    lea eax,[esp]
    push eax
    push format1
    call scanf
    fld qword[ebp-8]

    mov esp,ebp
    pop ebp
    ret


main:
fldpi
fmul qword[two]

call _read
fprem
FST qword[x]
FSIN

call _print11
call _free

mov dword[n], 1
call _free

FLD1
FSTP qword[a]
fldz
fstp qword[val]
call _free

loopu:
FILD dword[n]
fstp qword[f]
call _factorial

call _exponent

fld qword[e]
fdiv qword[f]
fmul qword[a]

fld qword[val]
fadd st1
fstp qword[val]
fldz

fcomip st1
je endu

call _free
fld qword[a]
fchs
fstp qword[a]
add dword[n], 2
jmp loopu

endu:
fld qword[val]
call _print

_exit:
mov eax, 1
mov ebx, 0
int 80h


_factorial:
call _free
fld qword[f]
_startI:
    fld qword[f]
    fld1
    fsubr st1
    fld1
    fcomip st1
    jnb _endFactorial

    fst qword[f]
    fmul st2
    ffree st2
    ffree st1
    jmp _startI
_endFactorial:
fstp qword[f]
fstp qword[f]
fstp qword[f]
ret


_exponent:
    call _free
    fld qword[x]
    mov ecx,dword[n]
    cmp ecx,1
    je _endPower

    dec ecx
    _power:
    fmul qword[x]
    loop _power
    fstp qword[e]
    ret

_endPower:
fstp qword[e]
ret


_free:
pusha
FFREE ST0
FFREE ST1
FFREE ST2
FFREE ST3
FFREE ST4
FFREE ST5
FFREE ST6
FFREE ST7
popa
ret

