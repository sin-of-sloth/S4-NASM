section .bss

string : resb 100
temp : resb 1
num : resw 1
noOfDigits : resw 1

section .data

vowelCount : dw 0
stringLength : dw 0
prompt1 : db 0Ah, "Enter your string : "
len1 : equ $- prompt1
msg2 : db 0Ah, "Number of vowels in your given string is : "
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

        cmp byte[temp], 10
        je _endStringReading

        inc word[stringLength]
        mov al, byte[temp]
        mov byte[ebx], al
        inc ebx
        jmp _stringReader

    _endStringReading:

    mov byte[ebx], 0
    mov ebx, string
    
    _theAccountant:

        mov al, byte[ebx]
        cmp al, 0
        je _doneAccounting

        cmp al, 'a'
        je _incVowels
        cmp al, 'A'
        je _incVowels
        cmp al, 'e'
        je _incVowels
        cmp al, 'E'
        je _incVowels
        cmp al, 'i'
        je _incVowels
        cmp al, 'I'
        je _incVowels
        cmp al, 'o'
        je _incVowels
        cmp al, 'O'
        je _incVowels
        cmp al, 'u'
        je _incVowels
        cmp al, 'U'
        je _incVowels

        next:
            inc ebx
            jmp _theAccountant

    _doneAccounting:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 80h

    mov ax, word[vowelCount]
    mov word[num], ax
    call _printTheNumber
    call _newLinePrinter
    call _newLinePrinter

    mov eax, 1
    mov ebx, 0
    int 80h


    _incVowels:
        inc word[vowelCount]
        jmp next

    _newLinePrinter:

        pusha
        mov eax, 4
        mov ebx, 1
        mov ecx, newl
        mov edx, 1
        int 80h
        popa
        ret

    _printTheNumber:
	
		pusha
		
		mov byte[noOfDigits], 0
		
		cmp word[num], 0
		jne _printer
		
		add word[num], 30h
		
		mov eax, 4
		mov ebx, 1
		mov ecx, num
		mov edx, 1
		int 80h
		
		jmp _endPrinting
		
		_printer:
		
			cmp word[num], 0
			je _startPrinting
			
			inc byte[noOfDigits]
			mov dx, 0
			mov ax, word[num]
			mov bx, 10
			div bx
			push dx
			mov word[num], ax
			jmp _printer
			
		_startPrinting:
		
			cmp byte[noOfDigits], 0
			je _endPrinting
			
			dec byte[noOfDigits]
			pop dx
			mov word[temp], dx
			add word[temp], 30h
			
			mov eax, 4
			mov ebx, 1
			mov ecx, temp
			mov edx, 1
			int 80h
			
			jmp _startPrinting
		
		_endPrinting:
		
	popa
			
	ret