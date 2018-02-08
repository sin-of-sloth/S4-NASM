section .bss

array : resb 100
array1 : resb 100
array2 : resb 100
temp : resb 1
array1Length : resb 1
array2Length : resb 1

section .data

counter1 : times 26 db 0
counter2 : times 26 db 0
prompt1 : db 0Ah, "Enter the first string : "
len1 : equ $- prompt1
prompt2 : db 0Ah, "Enter the second string : "
len2 : equ $- prompt2
msg3 : db 0Ah, "The strings are anagrams.", 0Ah, 0Ah
len3 : equ $- msg3
msg4 : db 0Ah, "The strings are not anagrams.", 0Ah, 0Ah
len4 : equ $- msg4


section .text

global _start:
_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, len1
    int 80h

    call _readArray
    mov byte[array1Length], 0
    mov esi, array
    mov edi, array1
    _moveArrayToArray1:
        movzx eax, byte[esi]
        sub eax, 65
        inc byte[counter1 + eax]
        MOVSB
        inc byte[array1Length]
        mov ebx, esi
        dec ebx
        cmp byte[ebx], 10
        jne _moveArrayToArray1
    _endMovingArrayToArray1:

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len2
    int 80h

    call _readArray
    mov byte[array2Length], 0
    mov esi, array
    mov edi, array2
    _moveArrayToArray2:
        movzx eax, byte[esi]
        sub eax, 65
        inc byte[counter2 + eax]
        MOVSB
        inc byte[array2Length]
        mov ebx, esi
        dec ebx
        cmp byte[ebx], 10
        jne _moveArrayToArray2
    _endMovingArrayToArray2:

    mov al, byte[array1Length]
    cmp al, byte[array2Length]
    jne _notAnagrams

    mov esi, counter1
    mov edi, counter2
    mov ecx, 26
    _comparer:
        CMPSB
        jne _notAnagrams
    loop _comparer


    _yesAnagrams:

        mov eax, 4
        mov ebx, 1
        mov ecx, msg3
        mov edx, len3
        int 80h
    
    jmp _exit

    _notAnagrams:

        mov eax, 4
        mov ebx, 1
        mov ecx, msg4
        mov edx, len4
        int 80h


    _exit:

    mov eax, 1
    mov ebx, 0
    int 80h


_readArray:

    pusha

    mov edi, array
    mov eax, 0
    _reader:
        call _readChar
        mov al, byte[temp]
        cmp al, 10
        je _storeIt
        cmp al, 65
        jl _reader
        cmp al, 122
        jg _reader
        cmp al, 90
        jl _storeIt
        cmp al, 97
        jl _reader

        sub al, 32

        _storeIt:
            STOSB
            cmp byte[temp], 10
            jne _reader
    _endReader:
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
    