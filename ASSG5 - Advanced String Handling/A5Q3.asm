section .bss

array : resb 100
temp : resb 1
arrayLength : resb 1
start : resb 1
stop : resb 1
i : resb 1

section .data

prompt1 : db 0Ah, "Enter the string : "
len1 : equ $- prompt1
msg2 : db 0Ah, "The string with it's words reversed are :", 0Ah
len2 : equ $- msg2
newl : db 0Ah
space : db " "


section .text

global _start:
_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, len1
    int 80h

    call _readArray

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 80h

    mov byte[start], 0
    mov al, byte[arrayLength]
    dec al
    dec al
    mov byte[stop], al
    ;call _printSubString
    ;jmp _exit
        

    mov al, byte[arrayLength]
    dec al
    dec al
    mov byte[stop], al
    mov byte[i], al
    mov esi, array

    _stringReverser:
        cmp byte[i], 0
        jl _exit

        movzx eax, byte[i]
        cmp byte[esi + eax], 32
        je _printFromStartToStop
        dec byte[i]
        jmp _stringReverser

        _printFromStartToStop:

            mov byte[i], al
            inc al
            mov byte[start], al
            call _printSubString
            dec byte[i]
            mov al, byte[i]
            mov byte[stop], al
            jmp _stringReverser


    _exit:
    
    ;printing the first word
    mov byte[i], al
    mov byte[start], al
    call _printSubString
    call _newLinePrinter

    mov eax, 1
    mov ebx, 0
    int 80h


_readArray:

    pusha

    mov edi, array
    mov byte[arrayLength], 0
    mov eax, 0
    _reader:
        call _readChar
        mov al, byte[temp]
        STOSB
        inc byte[arrayLength]
        cmp byte[temp], 10
        jne _reader
    _endReader:

    popa
    ret

_printSubString:

    pusha
    mov esi, array
    
    _printer:
        mov al, byte[start]
        cmp byte[stop], al
        jl _endPrinting
        
        movzx eax, byte[start]
        mov bl, byte[esi + eax]
        mov byte[temp], bl
        call _printChar
        inc byte[start]
        jmp _printer

    _endPrinting:
    call _spacePrinter
    popa
    ret



_readChar:
    pusha
        mov eax, 3
        mov ebx, 0
        mov ecx, temp
        mov edx, 1
        int 80h
    popa
    ret

_printChar:
    pusha
        mov eax, 4
        mov ebx, 1
        mov ecx, temp
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

_spacePrinter:
    pusha
        mov eax, 4
        mov ebx, 1
        mov ecx, space
        mov edx, 1
        int 80h
    popa
    ret
    