macro get_TOKENS r {
	if r eq
		mov rax, memory
	else
		mov r, memory
	end if
}

token_init: ent
	get_TOKENS
	mov qword [rax], 0
	exi

token_add: ent
	arg_tok   equ 0
	arg_func  equ 1
	arg_data  equ 2
	
	count equ 0
	table equ 1
	tok   equ 2
	last  equ 3
	tmp   equ 4
	arg arg_tok
	set tok ; store token

	; store current count
	get_TOKENS
	mov rdx, [rax]
	set count, rdx

	; store first token addr
	get_TOKENS
	add rax, 8
	set table

	; calculate count * 32
	get count
	shl rax, 5
	mov rcx, rax
	set tmp

	; calculate last item
	get table
	mov rcx, rax
	get tmp
	add rax, rcx
	; store last item offset
	set last

	; store token
	get last
	mov rdx, rax
	get tok
	mov [rdx], rax

	; store token length address
	add rdx, 8
	set tmp, rdx

	; calc length
	get tok
	call _str_len
	mov rdx, rax
	get tmp

	; store length
	mov [rax], rdx

	; store func & data
	mov rdx, rax	
	add rdx, 8
	arg arg_func
	mov [rdx], rax
	add rdx, 8
	arg arg_data
	mov [rdx], rax

	; increment count of tokens
	get_TOKENS
	mov rbx, [rax]
	inc rbx
	mov [rax], rbx

	exi

token_get: ent
	n equ 0
	arg 0
	shl rax, 5
	set n

	get_TOKENS
	add rax, 8

	mov rdx, rax
	get n
	add rax, rdx
	exi rax

token_name:
	mov rbx, [rax]
	add rax, 8
	mov rax, [rax]
	ret

token_show: ent
	n equ 0
	arg 0
	shl rax, 5
	set n

	get_TOKENS
	add rax, 8

	mov rdx, rax
	get n
	add rax, rdx
	set 1 ; store item pointer

	get 1
	mov rbx, [rax]
	add rax, 8
	mov rax, [rax]
	call _prn_str
	call _prn_space

	get 1
	add rax, 16
	mov rdx, rax
	mov rax, [rdx]
	call _prn_int
	add rdx, 8
	mov rax, [rdx]
	call _prn_int
	log ''

	exi

token_list: ent
	count equ 1
	table equ 0
	get_TOKENS
	mov rdx, [rax]
	set table, rdx
	set count, 0
	@@:
		get count
		exe token_show
		get count
		inc rax
		set count
		pair count, table
		sub rax, rbx
	jne @b
	exi

token_find: ent
	count equ 0
	table equ 1
	name  equ 2
	len   equ 3
	R     equ 4
	curr  equ 5
	arg 0
	set name
	call _str_len
	set len
	set R, NONE

	get_TOKENS
	mov rdx, [rax]
	set table, rdx
	set count, 0
	token_find_loop:
		get count
		exe token_get
		mov rax, [rax]
		set curr
		str_cmp name, curr
		mov rdx, 48
		cmp rax, 0
		jne @f
			mov rdx, 49
			get count
			set R
		@@:
		mov rax, rdx
		get count
		inc rax
		set count
		pair count, table
		sub rax, rbx
	jne token_find_loop
	log ''
	get R
	exi

