[BITS 16]
[ORG 7C00h]         ; origem do endereço do boot da bios

call LoadSystem
jmp 0800h:0000h     ; vamos saltar para o endereço do kernel

LoadSystem:
    mov ah, 02h     ; vamos escrever
    mov al, 1       ; no primeiro setor do disco
    mov ch, 0       ; trilha 0
    mov cl, 2       ; setor 2 cargara o kernel
    mov dh, 0       ; cabeçote 0
    mov dl, 80h     ; primeira ordem de boot
    mov bx, 0800h   ; endereço que vai guarda codigo do kernel, (segmento de dados)
    mov es, bx      ; segmenting extra
    mov bx, 0000h
    int 13h         ; interrupção de disco
ret



times 510 - ($-$$) db 0      ; vai incrementar 512 bytes até 0
dw 0xAA55                    ; + 12 bytes