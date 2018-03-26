section .data:

prompt1     : db 0Ah, "Enter the number of elements in the array : "
len1        : equ $- prompt1
prompt2     : db 0Ah, "Enter the elements of the array : ", 0Ah
len2        : equ $- prompt2
msg3        : db 0Ah, "The elements in sorted order is : ", 0Ah
len3        : equ $- msg3
format1     : db "%lf", 0
format2     : db "%lf ", 10,  0

section .bss
array           : resq 50
d           : resw 1
num         : resw 1
temp        : resw 1
n           : resw 1
i           : resw 1
j           : resw 1
t           : resd 1


section .text
global main
extern scanf
extern printf

_printFloat:
    push ebp
    mov ebp,esp
    sub esp,8

    fst qword[ebp-8]
    push format2
    call printf

    mov esp,ebp
    pop ebp
    ret

_readFloat:
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

mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, len1
int 80h

call _readNum
mov ax, word[num]
mov word[n], ax

mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, len2
int 80h

call _readArray

mov word[i], 0
mov word[j], 0
mov ax, word[n]
sub ax, 1
mov word[temp], ax

sort:
mov ax, word[i]
cmp ax, word[temp]
je _exitSort
_sorter:
    FFREE ST0
    FFREE ST1
    mov ax, word[temp]
    sub ax, word[i]
    cmp ax, word[j]
    je _nextI

    call _indexJ
    
    mov ebx, array
    add ebx, dword[t]
    FLD qword[ebx]

    add ebx, 8
    FLD qword[ebx]
    
    FCOMI ST1
    ja _nextJ
    
    sub ebx, 8
    FSTP qword[ebx]
    add ebx, 8
    FSTP qword[ebx]

    _nextJ:
    inc word[j]
    jmp _sorter

    _nextI:
    inc word[i]
    mov word[j], 0
    jmp sort

_exitSort:
mov eax, 4
mov ebx, 1
mov ecx, msg3
mov edx, len3
int 80h

call _arrayPrint

_exit:
mov eax, 1
mov ebx, 0
int 80h

_readNum:
pusha
mov word[num], 0
_reader:
    mov eax, 3
    mov ebx, 0
    mov ecx, d
    mov edx, 1
    int 80h

    cmp word[d], 10
    je _exitRead
    cmp word[d], 20h
    je _exitRead
    
    sub word[d], 30h
    mov ax, word[num]
    mov cx, 10
    mul cx
    add ax, word[d]
    mov word[num], ax
    jmp _reader
_exitRead:
popa
ret


_readArray:
pusha
mov ax, word[n]
mov word[temp], ax
mov ebx, array

_loopify:
    cmp word[temp], 0
    je _exitloopify
    call _readFloat
    FSTP qword[ebx]
    add ebx, 8
    dec word[temp]
    jmp _loopify
_exitloopify:
popa
ret



_indexJ:
pusha
mov ax, word[j]
mov cx,8
mul cx
mov word[t], ax
popa
ret



_arrayPrint:
pusha
mov ax, word[n]
mov word[temp], ax
mov ebx, array

_loopPrint:
    cmp word[temp], 0
    je _exitLoopPrint
    FLD qword[ebx]
    call _printFloat
    add ebx, 8
    dec word[temp]
    jmp _loopPrint
_exitLoopPrint:
popa
ret







