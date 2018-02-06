section .bss
digit : resb 1
array : resw 50
asize : resb 1
counter : resb 1
num : resw 1
odder : resb 1
evener : resb 1
noOfDigs : resb 1
temp : resb 1

section .data
msg1 : db 0Ah,"Enter the size of the array : "
len1 : equ $- msg1
msg2 : db 0Ah,"Enter the elements of the array :",0Ah
len2 : equ $- msg2
msg3 : db 0Ah,"The number of even elements in the array is : "
len3 : equ $- msg3
msg4 : db 0Ah,"The number of odd elements in the array is : "
len4 : equ $- msg4
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
	mov byte[odder], 0
	mov byte[evener], 0
	
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
		mov dx, 0
		mov cx, 2
		div cx
		cmp dx, 0
		je evenNo
		
		add byte[odder], 1
		jmp nexter
		
		evenNo:
		add byte[evener],1
		
		nexter:
		dec byte[counter]
		cmp byte[counter],0
		jg array_read
		
	
		mov eax, 4
		mov ebx, 1
		mov ecx, msg3
		mov edx, len3
		int 80h
		
		mov al, byte[evener]
		mov byte[num], al
		mov byte[noOfDigs], 0
		cmp al, 0
		jne printEven
		
		add byte[num], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, num
		mov edx, 1
		int 80h
		jmp endEvenPrint
		
		
		printEven:
		cmp word[num], 0
		je printEvenNo
		inc byte[noOfDigs]
		mov dx, 0
		mov ax, word[num]
		mov bx, 10
		div bx
		push dx
		mov word[num], ax
		jmp printEven

		printEvenNo:
		cmp byte[noOfDigs], 0
		je endEvenPrint
		dec byte[noOfDigs]
		pop dx
		mov byte[temp], dl
		add byte[temp], 30h

		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h

		jmp printEvenNo

		endEvenPrint:
		
		mov eax, 4
		mov ebx, 1
		mov ecx, msg4
		mov edx, len4
		int 80h
		
		mov byte[noOfDigs], 0
		mov al, byte[odder]
		mov byte[num], al
		cmp al, 0
		jne printOdd
		
		add byte[num], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, num
		mov edx, 1
		int 80h
		jmp endOddPrint
		
		printOdd:
		inc byte[noOfDigs]
		cmp word[num], 0
		je printOddNo
		mov dx, 0
		mov ax, word[num]
		mov bx, 10
		div bx
		push dx
		mov word[num], ax
		jmp printOdd

		printOddNo:
		cmp byte[noOfDigs], 0
		je endOddPrint
		dec byte[noOfDigs]
		pop dx
		mov byte[temp], dl
		add byte[temp], 30h

		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h

		jmp printOddNo

		endOddPrint:
		
		mov eax, 4
		mov ebx, 1
		mov ecx, newl
		mov edx, 1
		int 80h
		
		mov eax, 1
		mov ebx, 0
		int 80h