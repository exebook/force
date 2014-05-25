NONE equ 99999

TAB_NAME equ 0
TAB_LENGTH equ 1
TAB_DATA equ 2
TAB_FUNC equ 3

TAB_ITEM_SIZE equ 4 * INTSIZE

func token_init
	global TOKEN
	mov B, 0
	mov [A], B
exi

func token_add
	use tok, fun, data
	var count, table, last, len
	; store current count
	global TOKEN
	mov D, [A]
	set count, D

	; store first token addr
	global TOKEN
	add A, INTSIZE
	set table

	; calculate count * item_size
	get count
	imul A, TAB_ITEM_SIZE

	; calculate last item
	mov B, A
	get table
	add A, B
	; store last item offset
	set last

	; calc length
	get tok
	call _str_len
	set len

	; store token
	get last, D
	get tok
	mov [D + TAB_NAME * INTSIZE], A
	get len
	mov [D + TAB_LENGTH * INTSIZE], A
	get data
	mov [D + TAB_DATA * INTSIZE], A
	get fun
	mov [D + TAB_FUNC * INTSIZE], A

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
	imul A, TAB_ITEM_SIZE
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
	imul A, TAB_ITEM_SIZE
	set n

	global TOKEN
	add A, INTSIZE

	mov D, A
	get n
	add A, D
exi A



func token_find
	use name, len
	var id, table, R, curr, curr_len
	get name
	set R, NONE

	global TOKEN
	mov D, [A]
	set table, D
	set id, 0
	token_find_loop:
		get id
		exe token_get
		mov D, A
		mov A, [D + TAB_NAME * INTSIZE]
		set curr
		mov A, [D + TAB_LENGTH * INTSIZE]
		set curr_len
		str_cmp name, len, curr, curr_len
		cmp A, 0
		jne @f
			get id
			set R
		@@:
		get id
		inc A
		set id
		pair id, table
		sub A, B
	jne token_find_loop
	get R
exi
