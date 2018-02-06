section .bss

string : resw 100
temp : resw 1
i : resw 1
j : resw 1


section .data

stringLength : dw 0
prompt1 : db 0Ah, "Enter your string : "
len1 : equ $- prompt1
true : db 0Ah, "Yes, it is a palindrome.", 0Ah
truelen : equ $- true
false : db 0Ah, "No, it is not a palindrome.", 0Ah
falselen : equ $- false
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
        cmp word[temp], 65
        jl _stringReader
        cmp word[temp], 122
        jg _stringReader
        cmp word[temp], 91
        jl _adder
        cmp word[temp], 97
        jl _stringReader

        mov ax, word[temp]
        mov cx, 32
        sub ax, cx
        mov word[temp], ax


        _adder:
        inc word[stringLength]
        mov ax, word[temp]
        mov word[ebx], ax
        inc ebx
        inc ebx
        jmp _stringReader

    _endStringReading:

    mov word[i], 0
    dec word[stringLength]
    mov ax, word[stringLength]
    mov word[j], ax

    _ijLoop:

        movzx eax, word[i]
        movzx ebx, word[j]
        cmp ax, bx
        jnb _palindrome
        mov cx, word[string + eax*2]
        mov dx, word[string + ebx*2]
        cmp cx, dx
        jne _notPalindrome
        
        inc word[i]
        dec word[j]
        jmp _ijLoop

    _palindrome:

        mov eax, 4
        mov ebx, 1
        mov ecx, true
        mov edx, truelen
        int 80h
        jmp _exit

    _notPalindrome:

        mov eax, 4
        mov ebx, 1
        mov ecx, false
        mov edx, falselen
        int 80h

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