[BITS 16]
[ORG 0000h]                 ; endereço do kernel

jmp Main                    ; vai saltar para a rotina main

BackWidth db 0
BackHeight db 0
Pagination db 0 ; tela 0 

Welcome db "DarkOS ", 0

Caracter db 30

Main:
    call ConfigSegment                 ; codigo e os dados ficaram salvos nesse segmento
    call ConfigStack                   ; confg da pilha
    call TEXT.SetVideoMode             ; modo de texto ativado
    jmp ShowString

ShowString:
    mov dh, 3                ; linha 3 
    mov dl, 2                ; coluna 3
    call MoveCursor          ; vau saltar para mover o cursor
    mov si, Welcome          ; vai pegar a string welcome des da origem dela
    mov di, Caracter
    call DarkString          ; vai mostra na tela
    call ReadString
    jmp END                  ; fim da função

ConfigSegment:
    mov ax, es                ; aqui ficara guardado o segmento do sistema operacional
    mov ds, ax                ; data segment
ret

ConfigStack:
    mov ax, 2D00h               ; endereço da pilha
    mov ss, ax                  ; vai armazena o endereço inicial da pilha
    mov sp, 03FEh               ;2D00h:03FEh vai apontar para o endereço de ax
ret

TEXT.SetVideoMode:
    mov ah, 00h                 ; entra no modo de video
    mov al, 03h                 ;modo de texto 80 colunas e 20 linhas
    int 10h
    mov BYTE[BackWidth], 80     ; tamanho da linha
    mov BYTE[BackHeight], 20    ; tamanho da coluna
ret

DarkString:
    mov ah, 09h                 ; função print da bios
    mov bh, [Pagination]        ; existe 16 paginação no modo de texto
    mov bl, 30                  ; cor de fundo e texto
    mov cx, 1                   ; contador de caracter vai repedir 1 caracter
    mov al, [si]                ; variavel welcome setada em si
    print:                       ; subrotina
        int 10h
        inc si                  ;vai apontar pro proximo endereço/ caracter
        call MoveCursor         ; vai mover o cursor a cada loop
        mov ah, 09h             ; função de imprimir caracter
        mov al, [si]            ; vai pro proximo caracter
        cmp al, 0               ; vai compara al até chega a 0 
        jne print               ; vai pular até chega o ultimo caracter ou igual a 0
ret

MoveCursor:
    mov ah, 02h                 ; funcao de cursor
    mov bh, [Pagination]        ;
    inc dl                      ;vai incrementa o curso na linha
    int 10h                     ; interrupção de vídeo
ret

ReadString:
    mov ah, 08h
    mov al, [di]
    readprint:
    int 10h
    inc di
    call MoveCursor
    mov ah, 09h
    mov al, [di]
    cmp al, 30
    jne readprint
ret

END:
    jmp $


