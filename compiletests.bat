ECHO OFF
cls
echo Compilando bootloader
nasm -f bin boot/bootloader.asm -o bin/bootloader.bin
echo Compilando o kernel
nasm -f bin tests/kernel/kernel.asm -o bin/kernel.bin
echo COMPILACAOO CONCLUIDA
pause