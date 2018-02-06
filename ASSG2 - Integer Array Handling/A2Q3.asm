section .bss
digit : resb 1
array : resw 50
asize : resb 1
bubbleCount : resb 1
elemCount : resb 1
counter : resb 1
count : resb 1
num : resw 1
div1 : resb 1
div2 : resb 1
noOfDigs : resb 1
temp : resw 1

section .data
msg1 : db 0Ah,"Enter the size of the array : "
len1 : equ $- msg1
msg2 : db 0Ah,"Enter the elements of the array :",0Ah
len2 : equ $- msg2
msg3 : db 0Ah,"The elements of the array in sorted order is :",0Ah
len3 : equ $- msg3
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
	
	mov byte[num],0
	
	reader:
		mov eax, 3
		mov ebx, 0
		mov ecx, digit
		mov edx, 1
		int 80h
		
		cmp byte[digit],10
		je end_read
		
		mov ax, word[num]
		mov bx, 10
		mul bx
		sub byte[digit],30h
		mov bl, byte[digit]
		mov bh, 0
		add ax, bx
		mov word[num], ax
		jmp reader
		
	end_read:
	
	mov ax, word[num]
	mov byte[asize],al
	mov byte[counter],al
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h

	mov ebx, array
	
	array_read:
		mov byte[num],0
		push ebx
		
		reading:
			mov eax, 3
			mov ebx, 0
			mov ecx, digit
			mov edx, 1
			int 80h
				
			cmp byte[digit],10
			je end_reading
			
			mov ax, word[num]
			mov bx, 10
			mul bx
			sub byte[digit],30h
			mov bl, byte[digit]
			mov bh, 0
			add ax, bx
			mov word[num], ax
			jmp reading
		
		end_reading:
		pop ebx
		mov ax, word[num]
		mov byte[ebx], al
		add ebx, 2
		dec byte[counter]
		cmp byte[counter],0
		jg array_read
		
		mov al, byte[asize]
		mov byte[bubbleCount], al
		mov byte [elemCount], al
		mov ebx, array
		
	bubbleGum:
		
		mov ax, word[ebx]
		add ebx, 2
		mov cx, word[ebx]
		sub ebx, 2
		cmp ax, cx
		jg chewAgain
		mov word[ebx], cx
		add ebx, 2
		mov word[ebx], ax
		sub ebx, 2
		
		chewAgain:
			add ebx, 2
			dec byte[elemCount]
			cmp byte[elemCount], 1
			jg nextBubbleGum
		
		mov al, byte[asize]
		mov byte[elemCount], al
		dec byte[bubbleCount]
		mov ebx, array
		
		nextBubbleGum:
			cmp byte[bubbleCount], 1
			jg bubbleGum
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, len3
	int 80h
	
	mov al, byte[asize]
	mov byte[counter], al
	
	mov ecx, array
	Printer:
		mov ax, word[ecx]
		mov word[num], ax
		push ecx
		mov byte[noOfDigs], 0
		cmp word[num], 0
		je zeroPrinter
		printee:
		cmp word[num], 0
		je print_no
		inc byte[noOfDigs]
		mov dx, 0
		mov ax, word[num]
		mov bx, 10
		div bx
		push dx
		mov word[num], ax
		jmp printee

		print_no:
		cmp byte[noOfDigs], 0
		je end_print
		dec byte[noOfDigs]
		pop dx
		mov byte[temp], dl
		add byte[temp], 30h

		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h

		jmp print_no
		
		zeroPrinter:
			mov byte[num], 0
			add byte[num], 30h
			mov eax, 4
			mov ebx, 1
			mov ecx, num
			mov edx, 1
			int 80h

		end_print:
		
		mov eax, 4
		mov ebx, 1
		mov ecx, space
		mov edx, 1
		int 80h
		
		pop ecx
		add ecx, 2
		dec byte[counter]
		cmp byte[counter],0
		jne Printer
	
	mov eax, 4
	mov ebx, 1
	mov ecx, newl
	mov edx, 1
	int 80h
	
	mov eax, 1
	mov ebx, 0
	int 80h