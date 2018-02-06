section .bss

row : resb 1
col : resb 1
matrix : resw 50
temp : resb 1
num : resw 1
noOfElements : resb 1
rowCounter : resb 1
colCounter : resb 1
digit : resb 1
noOfDigits : resb 1
pointer : resb 1
exc1 : resw 1
exc2 : resw 1


section .data

msg1 : db 0Ah, "'sup bitch?"
len1 : equ $- msg1
msg2 : db 0Ah, "'sup?"
len2 : equ $- msg2
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
	
	
	mov word[num], 300

	movzx ecx, word[num]

	looper:
	dec ecx
	loop

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, len2
	int 80h
	
	
	mov eax, 1
	mov ebx, 0
	int 80h
