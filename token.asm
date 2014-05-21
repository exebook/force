memory equ 1024 * 1024
macro get_TOKENS r {
	if r eq
		mov A, memory
	else
		mov r, memory
	end if
}

func token_init
	get_TOKENS
	mov B, 0
	mov [A], B
exi

func token_add
	var arg_tok, arg_func, arg_data
	var count, table, tok, last, tmp
	
	arg arg_tok
	set tok ; store token

	; store current count
	get_TOKENS
	mov D, [A]
	set count, D

	; store first token addr
	get_TOKENS
	add A, INTSIZE
	set table

	; calculate count * 32
	get count
	mul A, INTSIZE*4
	set tmp

	; calculate last item
	get table, tmp
	add A, B
	; store last item offset
	set last

	; store token
	get last
	mov D, A
	get tok
	mov [D], A

	; store token length address
	add D, INTSIZE
	set tmp, D

	; calc length
	get tok
	call _str_len
	mov D, A
	get tmp

	; store length
	mov [A], D

	; store func & data
	mov D, A
	add D, INTSIZE
	arg arg_func
	mov [D], A
	add D, INTSIZE
	arg arg_data
	mov [D], A

	; increment count of tokens
	get_TOKENS
	mov B, [A]
	inc B
	mov [A], B

	exi


