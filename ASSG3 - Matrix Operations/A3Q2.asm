section .bss

row1 : resb 1
col1 : resb 1
row2 : resb 1
col2 : resb 1
row : resb 1
col : resb 1
matrix1 : resw 100
matrix2 : resw 100
matrix : resw 100
temp : resb 1
temp1 : resw 1
temp2 : resw 1
num : resw 1
noOfElements : resb 1
rowCounter : resb 1
colCounter : resb 1
i : resw 1
j : resw 1
k : resw 1
digit : resb 1
noOfDigits : resb 1
pointer : resb 1

section .data

msg1 : db 0Ah, "Enter the number of rows of the first matrix : "
len1 : equ $- msg1
msg2 : db 0Ah, "Enter the number of columns of the first matrix : "
len2 : equ $- msg2
msg3 : db 0Ah, "Enter the number of rows of the second matrix : "
len3 : equ $- msg3
msg4 : db 0Ah, "Enter the number of columns of the second matrix : "
len4 : equ $- msg4
errormsg : db 0Ah, "Number of columns of first matrix & number of rows of second matrix should be equa!!ABORTING", 0Ah
errlen : equ $- errormsg
msg5 : db 0Ah, "Enter the elements of the first matrix : ", 0Ah
len5 : equ $- msg5
msg6 : db 0Ah, "Enter the elements of the second matrix : ", 0Ah
len6 : equ $ - msg6
msg7 : db 0Ah, "The first matrix is : ", 0Ah
len7 : equ $- msg7
msg8 : db 0Ah, "The second matrix is : ", 0Ah
len8 : equ $- msg8
msg9 : db 0Ah, "The product of the two matrices is : ", 0Ah
len9 : equ $- msg9
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
	mov byte[row1], al

    mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h
	
	call _getTheNumber
	mov ax, word[num]
	mov byte[col1], al

    mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, len3
	int 80h
	
	call _getTheNumber
	mov ax, word[num]
	mov byte[row2], al

    mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, len4
	int 80h
	
	call _getTheNumber
	mov ax, word[num]
	mov byte[col2], al

    mov al, byte[col1]
    mov bl, byte[row2]
    cmp al, bl
    je _continueTheProgram

    mov eax, 4
    mov ebx, 1
    mov ecx, errormsg
    mov edx, errlen
    int 80h

    jmp _exit

    _continueTheProgram:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg5
    mov edx, len5
    int 80h

	mov ah, 0
    mov al, byte[row1]
	mov bl, byte[col1]
	mul bl
	mov word[noOfElements], ax
	
	mov ebx, matrix1
	
	_matrixReader1:
	
        push ebx
		cmp word[noOfElements], 0
		je endMatrixReading1
		
		call _getTheNumber
		mov ax, word[num]
		pop ebx
		mov word[ebx], ax
		add ebx, 2
		
		dec word[noOfElements]
		jmp _matrixReader1
		
	endMatrixReading1:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg6
    mov edx, len6
    int 80h

	mov ah, 0
    mov al, byte[row2]
	mov bl, byte[col2]
	mul bl
	mov word[noOfElements], ax
	
	mov ebx, matrix2
	
	_matrixReader2:
	
        push ebx
		cmp word[noOfElements], 0
		je endMatrixReading2
		
		call _getTheNumber
		mov ax, word[num]
		pop ebx
		mov word[ebx], ax
		add ebx, 2
		
		dec word[noOfElements]
		jmp _matrixReader2
		
	endMatrixReading2:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg7
    mov edx, len7
    int 80h

	mov word[i], 0

	_matrix1ILoop:

		mov word[j], 0

		_matrix1JLoop:

			mov ax, word[i]
			mov bl, byte[col1]
			mul bl
			add ax, word[j]
			mov bx, word[matrix1 + 2 * eax]
			mov word[num], bx

			call _printTheNumber
			call _spacePrinter

			inc word[j]
			mov bx, word[j]
			cmp byte[col1], bl
			jne _matrix1JLoop

			call _newLinePrinter
			inc word[i]
			mov bx, word[i]
			cmp byte[row1], bl
			jne _matrix1ILoop


	mov eax, 4
    mov ebx, 1
    mov ecx, msg8
    mov edx, len8
    int 80h

	mov word[i], 0

	_matrix2ILoop:

		mov word[j], 0

		_matrix2JLoop:

			mov ax, word[i]
			mov bl, byte[col2]
			mul bl
			add ax, word[j]
			mov bx, word[matrix2 + 2 * eax]
			mov word[num], bx

			call _printTheNumber
			call _spacePrinter

			inc word[j]
			mov bx, word[j]
			cmp byte[col2], bl
			jne _matrix2JLoop

			call _newLinePrinter
			inc word[i]
			mov bx, word[i]
			cmp byte[row2], bl
			jne _matrix2ILoop

	mov ebx, matrix
	mov ah, 0
	mov al, byte[row1]
	mov bl, byte[col2]
	mul bl
	mov word[noOfElements], ax

	_initializer:

		mov word[ebx], 0
		add ebx, 2
		dec word[noOfElements]
		cmp word[noOfElements], 0
		jnl _initializer

	mov eax, 4
	mov ebx, 1
	mov ecx, msg9
	mov edx, len9
	int 80h


    mov word[i], 0
    mov word[j], 0
    mov word[k], 0

    _iLoop:
    mov word[j], 0

    _jLoop:
    mov word[k], 0

    _kLoop:

                        ;getting A[i][k]
        pusha
        mov ax, word[i]
        mov cl, byte[col1]
        mul cl
        add ax, word[k]
        mov bx, word[matrix1 + 2 * eax]
        mov word[temp1], bx
        popa

                        ;getting B[k][j]
        pusha
        mov ax, word[k]
        mov cl, byte[col2]
        mul cl
        add ax, word[j]
        mov bx, word[matrix2 + 2 * eax]
        mov word[temp2], bx
		popa

                        ; A[i][k] * B[k][j]
        mov ax, word[temp1]
        mov cx, word[temp2]
        mul cx
        mov word[temp], ax

                        ;getting C[i][j]
        mov ax, word[i]
        mov cl, byte[col2]
        mul cl
        add ax, word[j]
        mov cx, word[temp]
        add word[matrix + 2 * eax], cx
		mov bx, word[matrix + 2 * eax]
       
	    inc word[k]
        mov cx, word[k]
        cmp byte[col1], cl
        jne _kLoop

        inc word[j]
        mov cx, word[j]
        cmp byte[col2], cl
        jne _jLoop

		inc word[i]
        mov cx, word[i]
        cmp byte[row1], cl
        jne _iLoop


	mov bl, byte[row1]
	mov byte[row], bl

	mov bl, byte[col2]
	mov byte[col], bl

    call _matrixPrinter

    _exit:

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

	
		
	_matrixPrinter:
	
		pusha
		
		mov ebx, matrix
		movzx ax, byte[row]
		mov word[rowCounter], ax
		
		_rowLooper:
			
			cmp word[rowCounter], 0
			je _endMatrixPrinting
			movzx ax, byte[col]
			mov word[colCounter], ax
			
			_colLooper:
			
				mov ax, word[colCounter]
				cmp ax, 0
				je _rowDone
				
				mov ax, word[ebx]
				push ebx
				mov word[num], ax
				
				call _printTheNumber
				
				call _spacePrinter
				
				pop ebx
				add ebx, 2
				dec word[colCounter]
				jmp _colLooper
				
			_rowDone:
				
				call _newLinePrinter
				
				dec word[rowCounter]
				jmp _rowLooper
			
	_endMatrixPrinting:
	
	popa
		
	ret
