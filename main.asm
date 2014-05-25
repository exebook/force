include 'core.asm'
include 'table.asm'
include 'lex.asm'
include 'fu.asm'

func show_codef
	use a
	get a, B
	global CODEBASE
	xchg A, B
	sub A, B
	call _prn_int
	puts 10
exi

macro show_code msg {
	pushall
	puts msg, ': '
	exe show_codef, A
	popall
}

func act_tok
	use info
	var s, n
	get info, D
	mov D, [D + EXE_OFF]
	mov A, [D + STRING]
	set s
	mov A, [D + DATA]
	set n
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
	mov D, A
	mov A, [D + FUNC]
exi A

func_token_dispatch:
	act act_tok
	cmp A, 0
	je .skip
;	call _prn_int
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

func process
	global CODEBASE
	mov REXE, A
	global STACK
	mov RSTACK, A
	jmp INTTYPE [REXE + FUNC]
exi

func main
	exe initmem
	exe tokens
	global CODE
	show_code 'code base'

	var s, t, n
	chars '555 777 + .',0
	set s

	global CODE
	mov D, A
	mov [D + NEXT], INTTYPE 0
	mov [D + PREV], INTTYPE 0
	mov [D + DATA], INTTYPE 0
	mov [D + FUNC], INTTYPE func_boot
	get s
	mov [D + STRING], A
	add D, CODE_SIZE
	gset CODE, D
	
	exe process
	puts 10
exi

macro token_ins name, fu, dat {
	chars name
	exe token_add, A, fu, dat
}

func tokens
	exe token_init
	token_ins '555', func_555, 111
	token_ins '777', func_777, 222
	token_ins '.', func_prn, 222
	token_ins '+', func_add, 222
	token_ins 'quit', func_quit, 333
	exe token_list
exi

