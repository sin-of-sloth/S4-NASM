section .bss

string : resw 100
temp : resw 1


section .data

stringLength : dw 0
prompt1 : db 0Ah, "Enter your string : "
len1 : equ $- prompt1
msg2 : db 0Ah, "The string after encrypting it is : "
len2 : equ $- msg2
newl : db 0Ah



section .text

global _start:
_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, len1
    int 80h

    mov ebx, string

    _stringReader:

        push ebx
        mov eax, 3
        mov ebx, 0
        mov ecx, temp
        mov edx, 1
        int 80h
        pop ebx

        cmp word[temp], 10
        je _endStringReading
        cmp word[temp], 32
        je _nexter

        mov ax, word[temp]
        cmp ax, 'z'
        je _zCame
        cmp ax, 'Z'
        je _ZCame
        cmp ax, 65
        jl _nexter
        cmp ax,122
        jg _nexter
        cmp ax, 90
        jl _incer
        cmp ax, 97
        jl _nexter
        
        jmp _incer

        _zCame:
        mov ax, 'a'
        mov word[temp], ax
        jmp _nexter

        _ZCame:
        mov ax, 'A'
        mov word[temp], ax
        jmp _nexter

        _incer:
        inc ax
        mov word[temp], ax

        _nexter:
        inc word[stringLength]
        mov ax, word[temp]
        mov word[ebx], ax
        inc ebx
        inc ebx
        jmp _stringReader

    _endStringReading:

    mov word[ebx], 0

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 80h

    mov ebx, string

    _printString:

        cmp word[ebx], 0
        je _exit

        mov ax, word[ebx]
        mov word[temp], ax

        push ebx
        mov eax, 4
        mov ebx, 1
        mov ecx, temp
        mov edx, 1
        int 80h
        pop ebx

        inc ebx
        inc ebx
        jmp _printString

    _exit:

    call _newLinePrinter

    mov eax, 1
    mov ebx, 0
    int 80h

    _newLinePrinter:

        pusha
        mov eax, 4
        mov ebx, 1
        mov ecx, newl
        mov edx, 1
        int 80h
        popa
        ret