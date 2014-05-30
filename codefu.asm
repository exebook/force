func_label:
	sub RSTACK, INTSIZE
	mov R0, [REXE]
	mov [RSTACK], R0
	STEP

func_get_exe:
	STEP

func_fforth:
	mov R0, [RSTACK]
	add RSTACK, INTSIZE
	.l:
		cmp R0, 0
		je .o
		mov REXE, [REXE + NEXT]
		dec R0
		jmp .l
	.o:
	STEP

func_fback:
	STEP

func act_lex
	use info
	var n, x
	get info, D
	mov A, [D + EXE_OFF]
	set x
	mov A, [D + STACK_OFF]
	add [D + STACK_OFF], INTTYPE INTSIZE
	mov A, [A]
	set n
	.l:
		get x
		mov A, [A + NEXT] ; EXE->NEXT
		mov REXE, A
		act act_txtcut ; only uses REXE
		get x
		mov A, [A + NEXT] ; EXE->NEXT
		set x
		get n
		dec A
		set n
		cmp A, 0
		je .o
		jmp .l
	.o:
exi 0

func_lex:
	act act_lex
	STEP

func codefu
	token_ins '%', func_get_exe, 0
	token_ins '>>', func_fforth, 0
	token_ins 'fwd', func_fforth, 0
	exi

;	x nscan tokenize x tokens forward
;	x >> jump x forward
;	x << jump x back
;	% get exe
;	x %+ create new code after x
;	x +% create new code before x
	
;	% %+ +%
