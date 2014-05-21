format ELF64 executable at 0000000100000000h

segment readable writeable
memory rq 1024 * 1024
input_buffer_size	=	1024 * 1024
input_buffer		rb	input_buffer_size
input_size		rq	1
NONE equ 99999

segment readable executable

_read_stdin:
	mov	edx, input_buffer_size
	lea	rsi, [input_buffer]
	mov	edi, 0 ; stdin
	mov	eax, 0; sysread
	syscall
	
	mov	qword [input_size], rax
	or 	rax, rax
	js  	message_and_exit
	ret
