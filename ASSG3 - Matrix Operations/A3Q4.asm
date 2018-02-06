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

msg1 : db 0Ah, "Enter the number of rows : "
len1 : equ $- msg1
msg2 : db 0Ah, "Enter the number of columns : "
len2 : equ $- msg2
msg3 : db 0Ah, "Enter the elements of the matrix : ", 0Ah
len3 : equ $- msg3
msg4 : db 0Ah, "The original matrix is : ", 0Ah
len4 : equ $- msg4
msg5 : db 0Ah, "The required output is : ", 0Ah
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
	
	call getTheNumber
	mov ax, word[num]
	mov byte[row], al
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h
	
	call getTheNumber
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
	
	matrixReader:
	
		cmp byte[noOfElements], 0
		je endMatrixReading
		
		call getTheNumber
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
		
	call matrixPrinter
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg5
	mov edx, len5
	int 80h
	
	
	mov ebx,matrix
	mov al, byte[row]
	mov byte[rowCounter], al
	dec byte[rowCounter]
	
	mov al, byte[col]
	mov cl, 2
	mul cl
	movzx ecx, al
	add ebx, ecx
	
	reverseAlternateRows:
	
		movzx ax, byte[col]
		mov cl, 2
		div cl
		mov byte[colCounter], al
		
		mov byte[pointer], 0
		cmp byte[rowCounter], 0
		jng endReversing
		
		reverser:
			
			push ebx
			mov al, byte[pointer]
			mov bl, 2
			mul bl
			movzx edx, al
			
			pop ebx
			add edx, ebx
			push ebx
			
			mov al, byte[col]
			mov cl, 2
			mul cl							;no of cols*2
			sub ax, 2						;(no of cols*2) - 2
			mov cx, ax
			mov al, byte[pointer]
			mov bl, 2						;i*2
			mul bl
			sub cx, ax						;((no of cols-1)*2)-(i*2)
			movzx ecx, cx
			
			pop ebx
			add ecx, ebx
			push ebx
			mov ax, word[edx]
			mov bx, word[ecx]
			mov word[edx], bx
			mov word[ecx], ax
			pop ebx
			inc byte[pointer]
			dec byte[colCounter]
			cmp byte[colCounter], 0
			je oneRowReversed
			jmp reverser
			
		oneRowReversed:
			
			mov al, byte[col]
			mov cl, 2
			mul cl
			movzx ecx, al
			add ebx, ecx
			add ebx, ecx
			dec byte[rowCounter]
			dec byte[rowCounter]
			jmp reverseAlternateRows
			
	endReversing:
			
	call matrixPrinterInALine
	
	exit:
	
	mov eax, 1
	mov ebx, 0
	int 80h
	
	
	
	
	getTheNumber:
	
		pusha
		
		mov word[num], 0
		
		reader:
			
			mov eax, 3
			mov ebx, 1
			mov ecx, digit
			mov edx, 1
			int 80h
			
			cmp byte[digit], 10
			je endReading
			
			mov ax, word[num]
			mov bx, 10
			mul bx
			sub byte[digit], 30h
			mov bl, byte[digit]
			mov bh, 0
			add ax, bx
			mov word[num], ax
			jmp reader
		
		endReading:
		
		popa
		
		ret
	

	printTheNumber:
	
		pusha
		
		mov byte[noOfDigits], 0
		
		cmp word[num], 0
		jne printer
		
		add word[num], 30h
		
		mov eax, 4
		mov ebx, 1
		mov ecx, num
		mov edx, 1
		int 80h
		
		jmp endPrinting
		
		printer:
		
			cmp word[num], 0
			je startPrinting
			
			inc byte[noOfDigits]
			mov dx, 0
			mov ax, word[num]
			mov bx, 10
			div bx
			push dx
			mov word[num], ax
			jmp printer
			
		startPrinting:
		
			cmp byte[noOfDigits], 0
			je endPrinting
			
			dec byte[noOfDigits]
			pop dx
			mov byte[temp], dl
			add byte[temp], 30h
			
			mov eax, 4
			mov ebx, 1
			mov ecx, temp
			mov edx, 1
			int 80h
			
			jmp startPrinting
		
		endPrinting:
		
		popa
			
		ret

	
		
	matrixPrinter:
	
		pusha
		
		mov ebx, matrix
		mov al, byte[row]
		mov byte[rowCounter], al
		
		rowLooper:
			
			cmp byte[rowCounter], 0
			je endMatrixPrinting
			mov al, byte[col]
			mov byte[colCounter], al
			
			colLooper:
			
				mov al, byte[colCounter]
				cmp al, 0
				je rowDone
				
				mov ax, word[ebx]
				push ebx
				mov word[num], ax
				
				call printTheNumber
				
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
				jmp colLooper
				
			rowDone:
				
				pusha
				mov eax, 4
				mov ebx, 1
				mov ecx, newl
				mov edx, 1
				int 80h
				popa
				
				dec byte[rowCounter]
				jmp rowLooper
			
		endMatrixPrinting:
		
		popa
		
		ret
		
		
	matrixPrinterInALine:
		
		pusha
		
		mov ebx, matrix
		mov al, byte[row]
		mov byte[rowCounter], al
		
		rowInALineLooper:
			
			cmp byte[rowCounter], 0
			je endMatrixPrintingInALine
			mov al, byte[col]
			mov byte[colCounter], al
			
			colInALineLooper:
			
				mov al, byte[colCounter]
				cmp al, 0
				je rowInALineDone
				
				mov ax, word[ebx]
				push ebx
				mov word[num], ax
				
				call printTheNumber
				
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
				jmp colInALineLooper
				
			rowInALineDone:
				
				dec byte[rowCounter]
				jmp rowInALineLooper
			
		endMatrixPrintingInALine:
		
			pusha
			mov eax, 4
			mov ebx, 1
			mov ecx, newl
			mov edx, 1
			int 80h
			popa
		
		popa
		
		ret
