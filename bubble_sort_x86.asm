section .data
    msg1 db "Input array length"
    len1 equ $-msg1
    msg2 db "Input arrays"
    len2 equ $-msg2
    msg3 db "Sorted arrays"
    len3 equ $-msg3

section .bss
    arr resd 64
    in_str resb 4

section .text
    global _start

print:
    push eax
    push ebx
    mov eax, 4
    mov ebx, 1
    int 80h

    pop ebx
    pop eax 
    ret

input:
    push eax
    push ebx
    mov eax, 3
    mov ebx, 0
    int 80h
    
    pop ebx
    pop eax
    ret

mul10:
    push edx
    mov edx, eax
    shl eax, 3
    shl edx, 1
    add eax, edx
    pop edx
    ret

div10:
    push edx
    push ecx
    xor edx, edx
    mov ecx, 10
    div ecx
    mov ebx, edx
    pop ecx
    pop edx
    ret

bubble_sort:
    push eax
    push edi
    push esi
    
    mov edi, ecx
    shl edi, 2
.B1:
    sub edi, 4
    mov eax, dword[ebx+edi]
    mov esi, edi
.B2:
    sub esi, 4
    cmp eax, dword[ebx+esi]
    jg .swap
    jmp .continue

.swap:
    push    dword[ebx+esi]
    push    dword[ebx+edi]
    pop     dword[ebx+esi]
    pop     dword[ebx+edi]
    mov     eax, dword[ebx+edi]
.continue:
    cmp esi,    0
    jg  .B2
    cmp edi,    4
    jg  .B1

    pop eax
    pop edi
    pop esi
    ret

convert_to_int:
    push ebx
    mov eax, 0
    mov ebx, 0
.C1:
    call mul10
    push edx
    xor edx, edx
    mov dl, byte[ecx+ebx]
    sub dl, '0'
    add eax, edx
    pop edx
    inc ebx
    cmp byte[ecx+ebx], 0xa
    jle .C2
    cmp ebx,edx
    jge .C2
    jmp .C1

.C2:
    pop ebx
    ret

convert_to_str:
    push  ebx 
    push  eax 
    mov   ebx,0
    push  0   
.S1:
    call div10
    add  ebx,0x30
    push ebx 
    cmp eax,0
    jg  .S1
    xor ebx, ebx
.S2:
    pop     eax 
    cmp     eax,0
    je      .S3
    cmp     ebx,edx
    je      .S2
    mov     byte[ecx+ebx],al
    inc     ebx 
    jmp     .S2
.S3:
    cmp     ebx,edx
    je      .return
    mov     byte[ecx+ebx],0
    inc     ebx 
    jmp     .S3
.return:
    pop     eax 
    pop     ebx 
    ret

_start:
    mov ecx, msg1
    mov edx, len1
    call    print
    
    mov ecx, in_str
    mov edx, 4
    call    input

    call convert_to_int
    push eax
    mov ebx, eax
    
    mov ecx, msg2
    mov edx, len2
    call    print

.L1:
    dec ebx
    mov ecx, in_str
    mov edx, 4
    call    input
    call    convert_to_int
    mov edx, ebx
    shl edx, 2
    mov dword[arr+edx], eax
    cmp ebx, 0
    jne .L1
    
    mov ebx, arr
    pop ecx
    call bubble_sort
    mov ebx, ecx
    
    mov ecx, msg3
    mov edx, len3
    call    print    

.L2:
    dec ebx
    mov edx, ebx
    shl edx,2
    mov eax, dword[arr+edx]
    mov ecx, in_str
    mov edx, 4
    call convert_to_str
    mov byte[in_str+3], 0x20
    call print
    cmp ebx,0
    jne .L2

    mov eax, 1
    mov ebx, 0
    int 80h
