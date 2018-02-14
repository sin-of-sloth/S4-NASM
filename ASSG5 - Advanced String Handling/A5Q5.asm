section .bss

array : resb 100
origArray : resb 100
wordDeleted : resb 100
wordToReplaceWith : resb 100
temp : resb 1
arrayLength : resb 1
wordLength : resb 1
deleteWordLength : resb 1
start : resb 1
stop : resb 1
i : resb 1
j : resb 1
k : resb 1
flag : resb 1

section .data

prompt1 : db 0Ah, "Enter the string : "
len1 : equ $- prompt1
prompt2 : db 0Ah, "Enter the word to be replaced : "
len2 : equ $- prompt2
prompt3 : db 0Ah, "Enter the word to replace it with : "
len3 : equ $- prompt3
msg4 : db 0Ah, "The modified string is : ", 0Ah
len4 : equ $- msg4
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
    mov esi, array
    mov edi, origArray
    _movingArrayToOrigArray:
        MOVSB
        mov ebx, esi
        dec ebx
        cmp byte[ebx], 10
        jne _movingArrayToOrigArray
    
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len2
    int 80h

    call _readWord
    mov esi, array
    mov edi, wordDeleted
    _movingArrayToWordDeleted:
        MOVSB
        inc byte[deleteWordLength]
        mov ebx, esi
        dec ebx
        cmp byte[ebx], 10
        jne _movingArrayToWordDeleted
    dec byte[deleteWordLength]
    dec byte[deleteWordLength]

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt3
    mov edx, len3
    int 80h

    call _readWord
    mov esi, array
    mov edi, wordToReplaceWith
    _movingArrayToWordToReplaceWith:
        MOVSB
        mov ebx, esi
        dec ebx
        cmp byte[ebx], 10
        jne _movingArrayToWordToReplaceWith

    mov byte[start], 0
    mov byte[i], 0
    mov edi, origArray

    _printingStringWithReplacement:

        mov al, byte[i]
        cmp al, byte[arrayLength]
        je _endPrintingStringWithReplacement

        movzx eax, byte[i]
        cmp byte[edi + eax], 33
        jl _compareWordWithWordDeleted

        inc byte[i]
        jmp _printingStringWithReplacement

        _compareWordWithWordDeleted:
            mov al, byte[i]
            dec al
            mov byte[stop], al
            call _checkIfWordIsWordDeleted
            cmp byte[flag], 1
            je _printTheWordItself

            call _printWordToReplaceWith
            call _spacePrinter
            jmp _nexter
            _printTheWordItself:
            call _printSubString
            _nexter:
            inc byte[i]
            mov al, byte[i]
            mov byte[start], al
            mov byte[flag], 0
            jmp _printingStringWithReplacement


    _endPrintingStringWithReplacement:
        call _newLinePrinter
        
    _exit:

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


_readWord:
    pusha
    mov edi, array
    mov byte[wordLength], 0
    mov eax, 0
    _readerWord:
        call _readChar
        mov al, byte[temp]
        STOSB
        inc byte[wordLength]
        cmp byte[temp], 10
        jne _readerWord
    _endReaderWord:
    popa
    ret

_checkIfWordIsWordDeleted:
    pusha
    mov byte[j], 0
    mov al, byte[start]
    mov byte[k], al
    mov ebx, array
    mov edx, wordDeleted
    mov byte[flag], 0
    mov al, byte[start]
    mov cl, byte[stop]
    sub cl, al
    cmp cl, byte[deleteWordLength]
    jne _setFlagEqualToOne
    _checker:
        movzx eax, byte[j]
        mov cl, byte[edx + eax]
        cmp cl, 10
        je _endCheck
        movzx eax, byte[k]
        cmp byte[ebx + eax], cl
        jne _setFlagEqualToOne
        inc byte[j]
        inc byte[k]
        jmp _checker

        _setFlagEqualToOne:
            mov byte[flag], 1

    _endCheck:
    popa
    ret

_printWordToReplaceWith:
    pusha
    mov esi, wordToReplaceWith
    _printTheWord:
        LODSB
        cmp al, 10
        je _endPrintingTheWord
        mov byte[temp], al
        call _printChar
        jmp _printTheWord
    _endPrintingTheWord:
    popa
    ret



_printSubString:

    pusha
    mov edi, array
    
    _printer:
        mov al, byte[start]
        cmp al, byte[stop]
        jg _endPrinting
        
        movzx eax, byte[start]
        mov bl, byte[edi + eax]
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