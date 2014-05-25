macro act fu, a, b, c {
	push REXE
	push RSTACK
	push RBASE
	mov A, SP
	push A
	exe fu, A
	mov R1, A
	pop A
	mov RBASE, [A + BASE_OFF]
	mov RSTACK, [A + STACK_OFF]
	mov REXE, [A + EXE_OFF]
	mov A, R1
}

func act_tok ; return FUNC or 0
	use info
	
	var s, n
	get info, D
	mov D, [D + EXE_OFF]
	mov A, [D + STRING]
	set s
	mov A, [D + DATA]
	set n
	
	get s, B
	mov A, 0
	mov al, [B]
	cmp al, '0'
	jl .no
	cmp al, '9'
	jg .no
		; NUMBER
		var x, z
		set z, 0
		set x, 0
		.l1:	
			get x
			imul A, 10
			set x
			pair s, z
			mov al, byte [A + B]
			and A, 0xff
			sub al, '0'
			mov D, A
			change x, D
			change z, 1
			pair z, n
			cmp A, B
		jne .l1
		get info, D
		mov D, [D + DATA]
		get x
		mov [D + DATA], A
		mov A, func_num
		mov [D + FUNC], A
		exi A
	.no:
	
	pair s, n
	exe token_find, A, B
	cmp A, NONE
	jne .ok
		puts '*token "'
		pair n, s
		call _prn_str
		puts '" not_found '
		exi 0
	.ok:
	exe token_get
	mov A, [A + TAB_FUNC * INTSIZE]
	push A
	get info, D
	mov D, [D + EXE_OFF]
	pop A
	mov [D + FUNC], A
	

exi A

func_token_dispatch:
	act act_tok ; return FUNC or 0
	cmp A, 0
	je .skip
	jmp A
	.skip:
	STEP

func act_txtcut ; [*txtcut, quit] -> [*token, txtcut, quit]
	use info
	var x, s, ret_t, ret_n, new_s, next
	get info, D ; SET X
		mov A, [D + EXE_OFF]
		set x
	get x ; SET NEXT
		mov A, [A + NEXT]
		set next
	get x ; SET S
		mov A, [A + STRING]
		set s
	pet s ; TOKENIZE
		exe tokenize
		cmp A, 0
		je .zero
	pair ret_t, ret_n ; SET NEW_S
		add A, B
		set new_s
	; SET CURRENT TO TOKEN-DISPATCH	
		get x, C
		mov [C + FUNC], INTTYPE func_token_dispatch
		get ret_n
		mov [C + DATA], A ; token length
		global CODE
		mov [C + NEXT], A
		get ret_t
		mov [C + STRING], A ; token start after spaces
	; MAKE NEW TXT-CUT
		global CODE
		mov D, A
		mov [D + FUNC], INTTYPE func_txtcut
		get next
		mov [D + NEXT], A
		get new_s
		mov [D + STRING], A
		add D, CODE_SIZE
		gset CODE, D
		exi 1
	.zero:
		puts 'zero-terminated', 10
exi 0

func_txtcut:
	act act_txtcut
	cmp R0, 0
	je .next
	jmp dword [REXE + FUNC]
	.next:
	STEP

func_boot: ; [*boot] -> [*txtcut, quit]
	global CODE
	mov [A + PREV], REXE
	mov [A + FUNC], INTTYPE func_quit
	mov [REXE + NEXT], A
	mov [REXE + FUNC], INTTYPE func_txtcut
	add A, CODE_SIZE
	gset CODE
	jmp func_txtcut
