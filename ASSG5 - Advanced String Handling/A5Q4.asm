section .bss

array : resb 100
temp : resb 1
arrayLength : resb 1
maxIndex : resb 1
minIndex : resb 1
maxCount : resb 1
minCount : resb 1
start : resb 1
i : resb 1
j : resb 1


section .data

prompt1 : db "Enter a string: ", 0Ah
len1 : equ $-prompt1
largest : db "The largest word is: "
lenLarge : equ $-largest
smallest : db "The smallest word is: "
lenSmall : equ $-smallest
newl : db 0Ah
space : db " "



section .text

global _start
_start:

mov eax, 4
mov ebx, 1
mov ecx, prompt1
mov edx, len1
int 80h

call _readArray
mov byte[maxIndex], 0
mov byte[minIndex], 0
mov byte[maxCount], 0
mov byte[minCount], 100
mov byte[i], 0
mov byte[j], 0                  ; keeps index of start of each word
mov byte[temp], 0               ; keeps count of each word's length
mov esi, array

_findMaxAndMin:
    mov al, byte[arrayLength]
    cmp byte[i], al
    jg _endFindingMaxAndMin
    movzx eax, byte[i]
    cmp byte[esi + eax], 32
    je _couldBeNewMaxOrMin
    cmp byte[esi + eax], 10
    je _couldBeNewMaxOrMin

    inc byte[i]
    inc byte[temp]
    jmp _findMaxAndMin

    _couldBeNewMaxOrMin:
        _isItNewMax:
            mov al, byte[temp]
            cmp al, byte[maxCount]
            jng _isItNewMin

            call _setNewMax
            jmp _nexter

        _isItNewMin:
            mov al, byte[temp]
            cmp al, byte[minCount]
            jnl _nexter

            call _setNewMin

    _nexter:
        inc byte[i]
        mov al, byte[i]
        mov byte[j], al
        mov byte[temp], 0
        jmp _findMaxAndMin 


_endFindingMaxAndMin:

call _newLinePrinter
mov eax, 4
mov ebx, 1
mov ecx, largest
mov edx, lenLarge
int 80h

mov al, byte[maxIndex]
mov byte[start], al
call _printAWord
call _newLinePrinter

mov eax, 4
mov ebx, 1
mov ecx, smallest
mov edx, lenSmall
int 80h

mov al, byte[minIndex]
mov byte[start], al
call _printAWord
call _newLinePrinter


_exit:

mov eax, 1
mov ebx, 0
int 80h


_setNewMax:
    pusha
    mov al, byte[temp]
    mov byte[maxCount], al
    mov al, byte[j]
    mov byte[maxIndex], al
    popa
    ret

_setNewMin:
    pusha
    mov al, byte[temp]
    mov byte[minCount], al
    mov al, byte[j]
    mov byte[minIndex], al
    popa
    ret


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

_printAWord:

    pusha
    mov esi, array
    
    _printer:
        movzx eax, byte[start]
        cmp byte[esi + eax], 32
        jng _endPrinting
        
        movzx eax, byte[start]
        mov bl, byte[esi + eax]
        mov byte[temp], bl
        call _printChar
        inc byte[start]
        jmp _printer

    _endPrinting:
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
    