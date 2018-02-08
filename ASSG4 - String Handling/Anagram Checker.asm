section .bss

string1 : resb 100
string2 : resb 100
string : resb 100
temp : resb 1
key : resb 1
num : resw 1
digit : resb 1
i : resw 1
j : resw 1
string1Length : resw 1
string2Length : resw 1


section .data

checker1 : times 200 db 0
checker2 : times 200 db 0
prompt1 : db 0Ah, "Enter your first string : "
len1 : equ $- prompt1
prompt2 : db 0Ah, "Enter your second string : "
len2 : equ $- prompt2
msg3 : db 0Ah, "Yes, they are anagrams.", 0Ah
len3 : equ $- msg3
msg4 : db 0Ah, "No, they are not anagrams.", 0Ah
len4 : equ $- msg4
newl : db 0Ah



section .text

global _start:
_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, len1
    int 80h

    call _inputString
    mov byte[string1Length], 0
    mov esi, string
    mov edi, string1
    _movingToOrigString1:
        movzx eax, byte[esi]
        inc byte[checker1 + eax]
        MOVSB
        inc byte[string1Length]
        mov ebx, esi
        inc ebx
        cmp byte[ebx], 10
        jne _movingToOrigString1
    _endMovingToOrigString1:

    mov eax, 4
	mov ebx, 1
	mov ecx, prompt2
	mov edx, len2
	int 80h

    call _inputString
    mov byte[string2Length], 0
    mov esi, string
    mov edi, string2
    _movingToOrigString2:
        movzx eax, byte[esi]
        inc byte[checker2 + eax]
        MOVSB
        inc byte[string1Length]
        mov ebx, esi
        inc ebx
        cmp byte[ebx], 10
        jne _movingToOrigString2
    _endMovingToOrigString2:

    mov ax, word[string1Length]
    cmp ax, word[string2Length]
    jne _notAnagram

    mov esi, checker1
    mov edi, checker2
    mov ecx, 200
   
    _comparer:
		CMPSB
		jne _notAnagram
	loop _comparer

    _endComparison:
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg4
    mov edx, len4
    int 80h
    jmp _exit


    _notAnagram:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg4
    mov edx, len4
    int 80h

    _exit:

    mov eax, 1
    mov ebx, 0
    int 80h


    _inputChar:
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

    
    _inputString:

    pusha
    mov ebx, string
        _arrayLoad:
            call _inputChar
            
            cmp byte[temp], 10
            je _moveToArray
            cmp byte[temp], 65
            jl _arrayLoad
            cmp byte[temp], 122
            jg _arrayLoad
            cmp byte[temp], 91
            jl _moveToArray
            cmp byte[temp], 97
            jl _arrayLoad

            mov al, byte[temp]
            mov cl, 32
            sub al, cl
            mov byte[temp], al

            _moveToArray:

            mov al, byte[temp]
            mov byte[ebx], al
            cmp byte[temp], 10
            je _endArrayLoad
            inc ebx
            jmp _arrayLoad

        _endArrayLoad:
        popa
        ret
