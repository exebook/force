macro vm_over {
	mov R0, [RSTACK + INTSIZE]
	sub RSTACK, INTSIZE
	mov [RSTACK], R0
}

macro act fu, a, b, c {
	push REXE
	push RSTACK
	push RBASE
	mov A, SP
	push A
	exe fu, A
	mov R1, A
	pop A
	pop RBASE
	pop RSTACK
	pop REXE
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
	gset CURTOK
	mov SI, [A + TAB_FUNC * INTSIZE]
	mov C, [A + TAB_DATA * INTSIZE]
	get info, D
	mov D, [D + EXE_OFF]
	mov [D + FUNC], SI
	mov [D + DATA], C
exi SI

func_token_dispatch:
	act act_tok ; return FUNC or 0
	cmp A, 0
	je .skip
	jmp A
	.skip:
	STEP

macro put_token_on_stack {
	mov R0, [REXE + STRING]
	mov R1, [REXE + DATA]
	sub RSTACK, INTSIZE
	mov [RSTACK], R0
	sub RSTACK, INTSIZE
	mov [RSTACK], R1
}

macro cmp_two_strings_on_stack {
	pushvm
	mov SI, [RSTACK+INTSIZE]
	mov C, [RSTACK]
	mov B, [RSTACK+2*INTSIZE]
	mov DI, [RSTACK+3*INTSIZE]
	mov A, 1
	cmp C, B
	jne @f
	cld
	mov A, 0
	repe cmpsb
	je @f
	mov A, 1
	@@:
	popvm
	add RSTACK, 2*INTSIZE
}

func_token_cmp:
	mov R0, func_token_dispatch
	mov [REXE + FUNC], R0
	put_token_on_stack
	cmp_two_strings_on_stack
	cmp A, 0
	jne .cont
	gset CUTMODE, func_token_dispatch
	add RSTACK, 2*INTSIZE
	.cont:
	STEP
	
func_token_scan:
	mov REXE, [REXE] ; *token abc quit -> [abc 3] *quit
	act act_txtcut ; only uses REXE
	; put label
	mov R0, [REXE]
	sub RSTACK, INTSIZE
	mov [RSTACK], R0
	;
	put_token_on_stack
	gset CUTMODE, func_token_cmp
	STEP

func_token_cmp_at:
	mov R0, func_token_dispatch
	mov [REXE + FUNC], R0
	put_token_on_stack
	cmp_two_strings_on_stack
	cmp A, 0
	jne .cont
	gset CUTMODE, func_token_dispatch
	add RSTACK, 2*INTSIZE
	.cont:
	STEP

func_token_scanat:
	mov REXE, [RSTACK] ; *token abc quit -> [abc 3] *quit
	act act_txtcut ; only uses REXE
	; put label
	mov R0, [REXE]
	sub RSTACK, INTSIZE
	mov [RSTACK], R0
	;
	put_token_on_stack
	gset CUTMODE, func_token_cmp
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
		global CUTMODE
		mov [C + FUNC], A
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
	; check mode
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
