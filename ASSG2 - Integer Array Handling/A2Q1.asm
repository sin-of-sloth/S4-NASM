section .bss
digit : resb 1
array : resw 50
asize : resb 1
counter : resb 1
num : resw 1
div1 : resb 1
div2 : resb 1
noOfDigs : resb 1
temp : resb 1

section .data
msg1 : db 0Ah,"Enter the size of the array : "
len1 : equ $- msg1
msg2 : db 0Ah,"Enter the elements of the array :",0Ah
len2 : equ $- msg2
msg3 : db 0Ah,"Enter the number 'a' : "
len3 : equ $- msg3
msg4 : db 0Ah,"Enter the number 'b' : "
len4 : equ $- msg4
msg5 : db 0Ah,"The numbers divisible by 'a' and 'b' in the array are : ",0Ah
len5 : equ $- msg5
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
		
		mov eax, 4
		mov ebx, 1
		mov ecx, msg3
		mov edx, len3
		int 80h
		
		mov byte[num],0
		num1_reader:
			mov eax, 3
			mov ebx, 0
			mov ecx, digit
			mov edx, 1
			int 80h
			
			cmp byte[digit],10
			je end_num1read
			
			mov ax, word[num]
			mov dx, 0
			mov bx, 10
			mul bx
			sub byte[digit],30h
			mov bl, byte[digit]
			mov bh, 0
			add ax, bx
			mov word[num], ax
			jmp num1_reader
			
		end_num1read:
		
		mov ax, word[num]
		mov byte[div1], al
		
		mov byte[num], 0
		mov eax, 4
		mov ebx, 1
		mov ecx, msg4
		mov edx, len4
		int 80h
		
		num2_reader:
			mov eax, 3
			mov ebx, 0
			mov ecx, digit
			mov edx, 1
			int 80h
			
			cmp byte[digit],10
			je end_num2read
			
			mov ax, word[num]
			mov dx, 0
			mov bx, 10
			mul bx
			sub byte[digit],30h
			mov bl, byte[digit]
			mov bh, 0
			add ax, bx
			mov word[num], ax
			jmp num2_reader
			
		end_num2read:
		
		mov ax, word[num]
		mov byte[div2], al
		
		mov eax, 4
		mov ebx, 1
		mov ecx, msg5
		mov edx, len5
		int 80h
		
		mov al, byte[asize]
		mov byte[counter], al
		mov ecx, array
		
		finding:
			mov ax, word[ecx]
			mov word[num], ax
			push ecx
			mov dx, 0
			movzx bx, byte[div1]
			div bx
			cmp dx, 0
			je divisibleByDIV1
			jmp endDeComp
			
			divisibleByDIV1:
				mov ax, word[num]
				mov dx, 0
				movzx bx, byte[div2]
				div bx
				cmp dx, 0
				je divisibleByBoth
				jmp endDeComp
			
			divisibleByBoth:
				cmp word[num], 0
				je endDeComp
				printer:
					cmp word[num], 0
					je print_no
					inc byte[noOfDigs]
					mov dx, 0
					mov ax, word[num]
					mov bx, 10
					div bx
					push dx
					mov word[num], ax
					jmp printer

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

				end_print:
					mov eax, 4
					mov ebx, 1
					mov ecx, space
					mov edx, 1
					int 80h
				
		endDeComp:
					
			pop ecx
			add ecx, 2
			dec byte[counter]
			cmp byte[counter],0
			jg finding
				
		
		mov eax, 4
		mov ebx, 1
		mov ecx, newl
		mov edx, 1
		int 80h
		
		mov eax, 1
		mov ebx, 0
		int 80h