;memory equ 1024 * 1024
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
	use tok, fun, data
	var count, table, last, tmp
;	draw tok
;	show fun, data
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
	imul A, INTSIZE*4
	set tmp

	; calculate last item
	pair table, tmp
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
	get fun
	mov [D], A
	add D, INTSIZE
	get data
	mov [D], A

	; increment count of tokens
	get_TOKENS
	mov B, [A]
	inc B
	mov [A], B
exi


func token_show
	use n
	var item
	get n
	imul A, INTSIZE * 4
	set n

	get_TOKENS
	add A, INTSIZE
	mov D, A
	get n
	add A, D
	set item ; store item pointer
	puts '[                          ]', 13, '[      '
	get item
	mov B, [A]
	add A, INTSIZE
	mov A, [A]
	call _prn_str
	puts ' '

	get item
	add A, INTSIZE * 2
	mov D, A
	mov A, [D]
	call _prn_int
	add D, INTSIZE
	mov A, [D]
	call _prn_int
	log ''
exi

func token_list
	puts '[==========================]', 10
	var count, table
	get_TOKENS
	mov D, [A]
	set table, D
	set count, 0
	lab c
		get count
		exe token_show
	cycle count, table, c
	puts '[==========================]', 10
	exi

func tokens
	exe token_init
	chars 'hello'
	exe token_add, A, 100, 111
	chars 'world'
	exe token_add, A, 200, 222
	chars 'of'
	exe token_add, A, 300, 333
	chars 'force'
	exe token_add, A, 400, 444
	exe token_list
	
;	chars 'world'
;	exe token_find, rax
;	call _prn_int
;	exe token_list
	exi

