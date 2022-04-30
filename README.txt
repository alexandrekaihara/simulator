Disciplina: Software Básico
Código: CIC104
Turma: B
Docente: Bruno Luiggi Macchiavello Espinoza
Discente: Alexandre Mitsuru Kaihara

TRABALHO 2

1. Dependências
As dependencias são:    
	Executado em uma máquina virtual Debian GNU/Linux 11 (bullseye) 32 bits (Linux debian 5.10.0-13-686 #1 SMP Debian 5.10.106-1 (2022-03-17) i686 GNU/Linux)
	gcc versão (Debian 10.2.1-6) 10.2.1 20210110
	nasm versão (2.15.05)

Para instalar o g++ na versão utilizada no Linux, use o seguinte comnado:
    	sudo apt install gcc=4:10.2.1-1
    	sudo apt install nasm=2.15.05-1

2. Instruções de uso
    Para compilar, acesse o diretório raiz e execute:
	nasm -f elf implementation.asm
	nasm -f elf file_handler.asm
	nasm -f elf instructions.asm
	nasm -f elf print.asm
	nasm -f elf convert.asm
	gcc simulator.c implementation.o file_handler.o instructions.o print.o convert.o -o simulator

3. Para executar:
	./simulator [path to the object file]

