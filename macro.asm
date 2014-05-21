macro Bye {
	mov	edi, 1
	mov	eax, 60
	syscall
}

macro prn_reg {
	push rbp
	push rdx
	push rcx
	push rbx
	push rax
	log ''
	pop rax
	call _prn_hex32
	log ' <- rax '
	pop rax
	call _prn_hex32
	log ' <- rbx '
	pop rax
	call _prn_hex32
	log ' <- rcx '
	pop rax
	call _prn_hex32
	log ' <- rdx '
	pop rax
	call _prn_hex32
	log ' <- rbp '
}

macro log str {
	puts str, 10
}

macro pushall {
	push BP
	push D
	push C
	push B
	push A
	push SI
	push DI
}

macro popall {
	pop DI
	pop SI
	pop A
	pop B
	pop C
	pop D
	pop BP
}

macro pchar_cmp a, b  {
	get a
	call _str_len
	mov C, A
	pair a, b
	mov SI, B
	mov DI, A
	cld
	mov A, 0
	repe cmpsb
	je @f
	mov A, 1
	@@:
}

