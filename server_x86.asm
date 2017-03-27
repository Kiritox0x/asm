section .data
    msg1 db "Socket opened", 0xa
    len1 equ $-msg1
    msg2 db "Socket binded", 0xa
    len2 equ $-msg2
    msg3 db "Socket listening on 127.0.0.1:9000", 0xa
    len3 equ $-msg3
    msg4 db "Hello guyz", 0xa
    len4 equ $-msg4
    
section .bss
    sockaddr    resd 2
    sock    resd 1

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

_start:
    ; socket(AF_INET, SOCK_STREAM, 0)
    push 0  ; 0
    push 1  ; SOCK_STREAM
    push 2  ; AF_INET
    
    mov eax, 102
    mov ebx, 1
    mov ecx, esp
    int 80h

    mov [sock], eax    

    mov ecx, msg1
    mov edx, len1
    call print

    ; bind(socket_desc,(struct sockaddr *)&server, sizeof(server))
    push dword 0x0  ;sockaddr_in.sin_addr.s_addr
    push dword 0x672b ;sockaddr_in.sin_port
    push dword 2 ; AF_INET

    mov [sockaddr], esp
    push dword 16  ;sizeof(server)
    push dword [sockaddr]
    push dword [sock]

    mov eax, 102
    mov ebx, 2
    mov ecx, esp
    int 80h

    mov ecx, msg2
    mov edx, len2
    call print
    
    ; listen(sockfd, backlog) 

    push 0 
    push dword [sock]
    
    mov eax, 102
    mov ebx, 4
    mov ecx, esp
    int 80h

    ; accept(socket_desc,(struct sockaddr *)&client, (socklen_t*)&c)
    
    mov ecx, msg3
    mov edx, len3
    call print

    push 0
    push 0
    push dword [sock]

    mov eax, 102
    mov ebx, 5
    mov ecx, esp
    int 80h

    ;write(int fd, void *buf, size_t)
    push eax
    push msg3
    push len3
    mov eax, 102
    mov ebx, 9
    mov ecx, esp
    int 80h

    mov eax, 1
    int 80h
