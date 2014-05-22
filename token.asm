NONE equ 99999

func token_init
	global TOKEN
	mov B, 0
	mov [A], B
exi

func token_add
	use tok, fun, data
	var count, table, last, tmp
	; store current count
	global TOKEN
	mov D, [A]
	set count, D

	; store first token addr
	global TOKEN
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
	global TOKEN
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

	global TOKEN
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
	global TOKEN
	mov D, [A]
	set table, D
	set count, 0
	lab c
		get count
		exe token_show
	cycle count, table, c
	puts '[==========================]', 10
exi

func token_get
	use n
	arg n
	imul A, INTSIZE * 4
	set n

	global TOKEN
	add A, INTSIZE

	mov D, A
	get n
	add A, D
exi A



func token_find
	use name
	var count, table, len, R, curr
	get name
	call _str_len
	set len
	set R, NONE

	global TOKEN
	mov D, [A]
	set table, D
	set count, 0
	token_find_loop:
		get count
		exe token_get
		mov A, [A]
		set curr
		str_cmp name, curr
		mov D, 48
		cmp A, 0
		jne @f
			mov D, 49
			get count
			set R
		@@:
		mov A, D
		get count
		inc A
		set count
		pair count, table
		sub A, B
	jne token_find_loop
	log ''
	get R
exi
