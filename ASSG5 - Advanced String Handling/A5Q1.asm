section .data
msg1 :db "Enter the string : "
size1 :equ $ -msg1
msg2 :db "The maximum number of distinct lowercase letters between two uppercase letters is : "
size2 : equ $-msg2
enter : db 0Ah


section .bss

string : resb 50
char   : resb 1
i      : resw 1
max    : resw 1
j      : resw 1
num    : resw 1
digi   : resw 1
nod    : resw 1
count  : resw 1
min_i  : resw 1
max_i  : resw 1
k      : resw 1
l      : resw 1


section .text


global _start
_start:

mov word[max],0

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,size1
int 80h

mov ebx,string

call _inputString

mov eax,4
mov ebx,1
mov ecx,enter
mov edx,1
int 80h

;the function to check maximum no small letters between capital letters


mov word[i],0

_traversal: 

    mov ax,word[i]
    mov bl,byte[string+eax]
    mov byte[char],bl

    cmp byte[char],0
    je _endNextUpper

    cmp byte[char],95
    jl _firstUpper

    inc word[i]
    jmp _traversal


_firstUpper:
    mov ax,word[i]
    mov word[min_i],ax
    mov word[j],ax


_nextUpper:

    inc word[j]
    mov ax,word[j]
    mov bl,byte[string+eax]

    cmp bl,0
    je _endNextUpper

    cmp bl,95
    jg _nextUpper

    mov ax,word[j]
    mov word[max_i],ax

    call _distinctCount

    mov ax,word[max_i]
    mov word[i],ax
    jmp _traversal

_endNextUpper:



mov ax,word[max]
mov word[num],ax

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,size2
int 80h

call _output
mov eax,4
mov ebx,1
mov ecx,enter
mov edx,1
int 80h

mov eax ,1
mov ebx ,0
int 80h


;functions used

;the function used to _output a string

_inputString:

pusha

mov word[i],0


_inputStringLoop:

pusha

mov eax,3
mov ebx,0
mov ecx,char
mov edx,1
int 80h

popa

cmp byte[char],0Ah
je _inputStringEnd

mov ax,word[i]
mov cl,byte[char]
mov byte[ebx+eax],cl
inc word[i]

jmp _inputStringLoop

_inputStringEnd:

mov cl,0
mov ax,word[i]
mov byte[ebx+eax],cl


popa

ret


;the function used to _output a string


_outputString:

pusha

mov word[i],0

_outputStringLoop:

mov ax,word[i]
mov cl,byte[ebx+eax]
cmp cl,0
je _outputStringEnd

mov byte[char],cl

pusha

mov eax,4
mov ebx,1
mov ecx,char
mov edx,1
int 80h

popa

inc word[i]
jmp _outputStringLoop

_outputStringEnd:


popa

ret




_output:

pusha


cmp word[num],0
je _zeroPrint


mov word[nod],0


_digitSplitter:

cmp word[num],0
je _printDigit
inc word[nod]

mov ax,word[num]
mov dx,0
mov bx,10
div bx
push dx
mov word[num],ax

jmp _digitSplitter

_printDigit:

cmp word[nod],0
je _printEnd

dec word[nod]

pop dx
mov word[digi],dx
add word[digi],30h

pusha
mov eax,4
mov ebx,1
mov ecx,digi
mov edx,1
int 80h
popa

jmp _printDigit

_printEnd:


popa

ret


_zeroPrint:


add word[num],30h

mov eax,4
mov ebx,1
mov ecx,num
mov edx,1
int 80h

jmp _printEnd



;the function used to count distinct number of smaller case numbers between two indices


_distinctCount:


mov ax,word[min_i]
mov word[k],ax
inc word[k]
mov word[count],0
k_loop:
     mov ax,word[max_i]
     cmp word[k],ax
     jnl   end_of_distinct
    
     mov ax,word[k]
     mov bl,byte[string+eax]
     mov byte[char],bl

     mov ax,word[k]
     mov word[l],ax
     inc word[l]
    
  l_loop:
     
     mov ax,word[max_i]
     cmp word[l],ax
     jnl end_of_l_loop
     



mov ax,word[l]
mov bl,byte[string+eax]
cmp byte[char],bl
je next_k_loop

inc word[l]
jmp l_loop

end_of_l_loop:

inc word[count]
inc word[k]
jmp k_loop


next_k_loop:

inc word[k]
jmp k_loop

end_of_distinct:

mov ax,word[count]
cmp ax,word[max]
jl the_begining_of_the_end

mov word[max],ax

the_begining_of_the_end:

ret
































