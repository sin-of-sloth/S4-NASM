section .bss

string : resb 100
temp : resb 1
key : resb 1
num : resw 1
digit : resb 1


section .data

stringLength : dw 0
prompt1 : db 0Ah, "Enter your string : "
len1 : equ $- prompt1
prompt2 : db 0Ah, "Enter the key : "
len2 : equ $- prompt2
msg3 : db 0Ah, "The string after encrypting it is : "
len3 : equ $- msg3
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

        cmp byte[temp], 10
        je _endStringReading

        _nexter:
        inc word[stringLength]
        mov al, byte[temp]
        mov byte[ebx], al
        inc ebx
        jmp _stringReader

    _endStringReading:

    mov byte[ebx], 0

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len2
    int 80h

    mov word[num], 0
    call _getTheNumber
    mov ax, word[num]
    mov byte[key], al

    mov edx, string
    
    _caesarCipher:

        cmp byte[edx], 0
        je _endCipher

        _incer:

        mov al, byte[edx]

        cmp al, 32
        je _nextCipher
        cmp al, 65
        jl _nextCipher
        cmp al,122
        jg _nextCipher

        cmp al, 91
        jl _caps

        mov bl, byte[key]
        add al, bl
        cmp al, 123
        jl _nextCipher
        sub al, 122
        add al, 96
        jmp _nextCipher

        _caps:

        mov bl, byte[key]
        add al, bl
        cmp al, 91
        jl _nextCipher
        sub al, 90
        add al, 64

     _nextCipher:

        mov byte[edx], al
        inc edx
        jmp _caesarCipher


    _endCipher:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, len3
    int 80h

    mov ebx, string

    _printString:

        cmp byte[ebx], 0
        je _exit

        mov al, byte[ebx]
        mov byte[temp], al

        push ebx
        mov eax, 4
        mov ebx, 1
        mov ecx, temp
        mov edx, 1
        int 80h
        pop ebx

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

    
    
    _getTheNumber:
	
		pusha
		
		mov word[num], 0
		
		_reader:
			
			mov eax, 3
			mov ebx, 1
			mov ecx, digit
			mov edx, 1
			int 80h
			
			cmp byte[digit], 10
			je _endReading
			
			mov ax, word[num]
			mov bx, 10
			mul bx
			sub byte[digit], 30h
			mov bl, byte[digit]
            mov bh, 0
			add ax, bx
			mov word[num], ax
			jmp _reader
		
		_endReading:
		
		popa
		
		ret