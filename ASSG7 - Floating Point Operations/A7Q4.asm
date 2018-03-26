section .data:

zero        : dq 0.000001
prompt1     : db 0Ah, "Enter the number of elements : "
len1        : equ $- prompt1
prompt2     : db 0Ah, "Enter the elements of the array :", 0Ah
len2        : equ $- prompt2
prompt3     : db 0Ah, "Enter the value of'k' : "
len3        : equ $- prompt3
msg4        : db 0Ah, "The required pairs are :", 0Ah
len4        : equ $- msg4
format1     : db "%lf", 0
format2     : db "%lf", 10, 0
format3     : db "(%lf, %lf)", 10, 0

section .bss
a           : resq 50
d           : resw 1
sum         : resw 1
temp        : resw 1
n           : resw 1
i           : resw 1
j           : resw 1
t           : resd 1
k           : resq 1
b           : resq 1


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

_printFloatPair:
    push ebp
    mov ebp,esp
    sub esp,16

    fstp qword[ebp-16]
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

mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, len1
int 80h 

call _readNum
mov ax,word[sum]
mov word[n],ax

mov eax, 4
mov ebx, 1
mov ecx, prompt2
mov edx, len2
int 80h

call _readArray

mov eax, 4
mov ebx, 1
mov ecx, prompt3
mov edx, len3
int 80h

call _read
FSTP qword[k]

mov eax, 4
mov ebx, 1
mov ecx, msg4
mov edx, len4
int 80h

mov word[i], 0
mov word[j], 0
mov ax, word[n]
sub ax, 1
mov word[temp], ax

__iLoop:

    FFREE ST0
    mov ax, word[i]
    cmp ax, word[temp]
    je _exit
    call _indexI

    mov ebx, a
    add ebx, dword[t]
    FLD qword[ebx]
    FSTP qword[b]

    mov ax, word[i]
    add ax, 1
    mov word[j], ax

    __jLoop:
        call _free
        mov ax, word[j]
        cmp ax, word[n]
        je _nextI
        call _indexJ
        mov ebx, a
        add ebx, dword[t]
        FLD qword[ebx]
        FLD qword[b]
        FADD ST1
        FLD qword[k]
        FSUB ST1
        FABS
        FLD qword[zero]
        FCOMI ST1
        ja _swap
        jmp _nextJ
         _swap:
            call _free
            FLD qword[b]
            FLD qword[ebx]
            call _printFloatPair
        _nextJ:
            call _free
            inc word[j]
            jmp __jLoop

    _nextI:
    inc word[i]
    jmp __iLoop

_exit:
mov eax,1
mov ebx,0
int 80h

_readNum:
pusha
mov word[sum],0
_reader:
    mov eax,3
    mov ebx,0
    mov ecx,d
    mov edx,1
    int 80h

    cmp word[d],10
    je _exitRead
    cmp word[d],20h
    je _exitRead

    sub word[d],30h
    mov ax,word[sum]
    mov cx,10
    mul cx
    add ax,word[d]
    mov word[sum],ax
    jmp _reader
_exitRead:
popa
ret


_readArray:
pusha
mov ax,word[n]
mov word[temp],ax
mov ebx,a

_loopify:
    cmp word[temp],0
    je _exitLoopify
    call _read
    FSTP qword[ebx]
    add ebx,8
    dec word[temp]
    jmp _loopify
_exitLoopify:
popa
ret



_indexJ:
pusha
mov ax,word[j]
mov cx,8
mul cx
mov word[t],ax
popa
ret

_indexI:
pusha
mov ax,word[i]
mov cx,8
mul cx
mov word[t],ax
popa
ret



_arrayPrint:
pusha
mov ax,word[n]
mov word[temp],ax
mov ebx,a

_loopPrint:
    cmp word[temp],0
    je _exitLoopPrint
    FLD qword[ebx]
    call _printFloat
    add ebx,8
    dec word[temp]
    jmp _loopPrint
_exitLoopPrint:
popa
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

