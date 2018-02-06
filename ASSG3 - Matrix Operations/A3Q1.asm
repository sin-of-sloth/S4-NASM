section .bss

row : resb 1
col : resb 1
matrix : resw 100
temp : resb 1
num : resw 1
noOfElements : resb 1
rowCounter : resb 1
colCounter : resb 1
digit : resb 1
noOfDigits : resb 1
pointer : resb 1


section .data

msg1 : db 0Ah, "Enter the order of the matrix : "
len1 : equ $- msg1
msg3 : db 0Ah, "Enter the elements of the matrix : ", 0Ah
len3 : equ $- msg3
msg4 : db 0Ah, "The original matrix is : ", 0Ah
len4 : equ $- msg4
msg5 : db 0Ah, "Matrix with diagonals interchanged is : ", 0Ah
len5 : equ $-msg5
newl : db 0Ah
space : db " "


section .text

global _start:
_start:
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, len1
	int 80h
	
	call _getTheNumber
	mov ax, word[num]
	mov byte[row], al
	mov byte[col], al
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, len3
	int 80h
	
	mov al, byte[row]
	mov bl, byte[col]
	mul bl
	mov byte[noOfElements], al
	
	mov ebx, matrix
	push ebx
	
	matrixReader:
	
		cmp byte[noOfElements], 0
		je endMatrixReading
		
		call _getTheNumber
		mov ax, word[num]
		pop ebx
		mov word[ebx], ax
		add ebx, 2
		push ebx
		
		dec byte[noOfElements]
		jmp matrixReader
		
	endMatrixReading:
		
	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, len4
	int 80h
		
	call _matrixPrinter
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg5
	mov edx, len5
	int 80h
	
	mov al, byte[row]
	mov byte[rowCounter], al
	mov ebx, matrix
	mov byte[pointer], 0
	
	exchangeDiagonals:
		
		push ebx
		;jmp endExchange
		cmp byte[rowCounter], 0
		je endExchange

		mov al, byte[pointer]
		mov cl, 2
		mul cl
		movzx ecx, ax
		
		pop ebx
		add ecx, ebx
		push ebx
		mov dx, word[ecx]
		
		mov al, byte[pointer]
		mov bl, 2
		mul bl
		mov dx, ax 					;i*2
		
		mov al, byte[col]
		mov bl, 2
		mul bl 						;col*2
		sub ax, dx 					;(col*2)-(i*2)
		sub ax, 2  					;(col*2)-(i*2)-2
		movzx eax, ax
		
		pop ebx
		add eax, ebx
		push ebx
		mov dx, word[eax]
		
		mov bx, word[ecx]
		mov word[eax], bx
		mov word[ecx], dx
		
		mov al, byte[row]
		mov cl, 2
		mul cl
		movzx ecx, ax
		
		pop ebx
		add ebx, ecx
		
		dec byte[rowCounter]
		inc byte[pointer]
		jmp exchangeDiagonals
		
	endExchange:
	
	call _matrixPrinter
	
	
	mov eax, 1
	mov ebx, 0
	int 80h
	
	
	
	
	
	
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
			mov byte[temp], dl
			add byte[temp], 30h
			
			mov eax, 4
			mov ebx, 1
			mov ecx, temp
			mov edx, 1
			int 80h
			
			jmp _startPrinting
		
		_endPrinting:
		
	popa
			
	ret

	
		
	_matrix_printer:
	
		pusha
		
		mov ebx, matrix
		mov al, byte[row]
		mov byte[rowCounter], al
		
		_rowLooper:
			
			cmp byte[rowCounter], 0
			je _endMatrixPrinting
			mov al, byte[col]
			mov byte[colCounter], al
			
			_colLooper:
			
				mov al, byte[colCounter]
				cmp al, 0
				je _rowDone
				
				mov ax, word[ebx]
				push ebx
				mov word[num], ax
				
				call _printTheNumber
				
				pusha
				mov eax, 4
				mov ebx, 1
				mov ecx, space
				mov edx, 1
				int 80h
				popa
				
				pop ebx
				add ebx, 2
				dec byte[colCounter]
				jmp _colLooper
				
			_rowDone:
				
				pusha
				mov eax, 4
				mov ebx, 1
				mov ecx, newl
				mov edx, 1
				int 80h
				popa
				
				dec byte[rowCounter]
				jmp _rowLooper
			
	_endMatrixPrinting:
	
	popa
		
	ret