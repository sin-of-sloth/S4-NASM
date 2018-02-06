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

msg1 : db 0Ah, "Enter the number of rows of the matrix : "
len1 : equ $- msg1
msg2 : db 0Ah, "Enter the number of columns of the matrix : "
len2 : equ $- msg2
msg3 : db 0Ah, "Enter the elements of the matrix : ", 0Ah
len3 : equ $- msg3
msg4 : db 0Ah, "The original matrix is : ", 0Ah
len4 : equ $- msg4
msg5 : db 0Ah, "The matrix rotated by 90° is : ", 0Ah
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


	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h
	
	call _getTheNumber
	mov ax, word[num]
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
	
	matrix_reader:
	
		cmp byte[noOfElements], 0
		je endMatrixReading
		
		call _getTheNumber
		mov ax, word[num]
		pop ebx
		mov word[ebx], ax
		add ebx, 2
		push ebx
		
		dec byte[noOfElements]
		jmp matrix_reader
		
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


	mov ecx, matrix

	mov al, byte[col]
	mov byte[colCounter], al


	_jumpToLastRow:

		mov al, byte[colCounter]
		cmp al, 0
		je _donePrintingNewMatrix

		mov al, byte[row]
		mov byte[rowCounter], al
		sub al, 1
		mov bl, byte[col]
		mul bl
		mov bl, 2
		mul bl
		movzx eax, al
		add ecx, eax

			_whereItHappens:

				cmp byte[rowCounter], 0
				je _oneColumnDone

				mov ax, word[ecx]

				mov word[num], ax
				call _printTheNumber
				call _spacePrinter

				mov al, byte[col]
				mov bl, 2
				mul bl
				movzx ebx, ax
				sub ecx, ebx
				dec byte[rowCounter]
				jmp _whereItHappens


			_oneColumnDone:

				call _newLinePrinter
				mov al, byte[col]
				mov bl, 2
				mul bl
				movzx eax, ax
				add ecx, eax
				add ecx, 2
				dec byte[colCounter]
				jmp _jumpToLastRow

		_donePrintingNewMatrix:

	mov eax, 1
	mov ebx, 0
	int 80h
	
	
	

	_spacePrinter:

		pusha

		mov eax, 4
		mov ebx, 1
		mov ecx, space
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

	
		
	_matrixPrinter:
	
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
				
				call _spacePrinter
				
				pop ebx
				add ebx, 2
				dec byte[colCounter]
				jmp _colLooper
				
			_rowDone:
				
				call _newLinePrinter
				
				dec byte[rowCounter]
				jmp _rowLooper
			
	_endMatrixPrinting:
	
	popa
		
	ret