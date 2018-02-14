section .bss

array : resb 100
temp : resb 1
arrayLength : resb 1
start : resb 1
stop : resb 1
i : resb 1
j : resb 1
k : resb 1

section .data

prompt1 : db 0Ah, "Enter the string : "
len1 : equ $- prompt1
msg2 : db "YES", 0Ah
len2 : equ $- msg2
msg3 : db "NO", 0Ah
len3 : equ $- msg3
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

    mov al, byte[arrayLength]
    dec al
    dec al
    cmp al, 0
    je _noSubStringPalindrome

    mov byte[i], 0
    mov esi, array

    _findingSubStringPalindrome:

    	_iLoop:
	    mov al, byte[arrayLength]
	    dec al
	    dec al
	    mov byte[j], al

	    _jLoop:
	    mov al, byte[i]
		mov byte[start], al
		mov al, byte[j]
		mov byte[stop], al

		_checkFromStartToStop:

		    movzx eax, byte[start]
		    mov cl, byte[esi + eax]
		    movzx eax, byte[stop]
		    cmp cl, byte[esi + eax]
		    jne _notPalindromeFromStartToStop

		    mov al, byte[start]
		    cmp al, byte[stop]
		    jnl _yesSubStringPalindrome

		    inc byte[start]
		    dec byte[stop]
		    jmp _checkFromStartToStop

		_notPalindromeFromStartToStop:

		    dec byte[j]
		    mov al, byte[j]
		    cmp al, byte[i]
		    je _nextILoop
		    jmp _jLoop

	    _nextILoop:
	    	
		inc byte[i]
		mov al, byte[arrayLength]
		dec al
		dec al
		cmp byte[i], al
		je _noSubStringPalindrome
		jmp _iLoop

       _yesSubStringPalindrome:

        mov eax, 4
        mov ebx, 1
        mov ecx, msg2
        mov edx, len2
        int 80h
	
	_printFromStartToStop:
    mov al, byte[i]
	mov byte[start], al
	mov al, byte[j]
	mov byte[stop], al

	call _printSubString
    call _newLinePrinter
    jmp _exit

    _noSubStringPalindrome:

        mov eax, 4
        mov ebx, 1
        mov ecx, msg3
        mov edx, len3
        int 80h    

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
