
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

func_nop:
	pushall
	puts 'nop '
	popall
	STEP

func act_prn
	use info
	get info
	mov B, [A + STACK_OFF]
	add [A + STACK_OFF], INTTYPE INTSIZE
	mov A, [B]
	call _prn_int
	exi
	
func act_prns
	use info, s
	get info
	mov B, [A + STACK_OFF]
	add [A + STACK_OFF], INTTYPE INTSIZE
	mov A, [B]
	set s
	draw s
	puts ' '
	exi

func_num:
	sub RSTACK, INTSIZE
	mov R0, [REXE + DATA]
	mov [RSTACK], R0
	STEP

func_add:
	mov R0, [RSTACK]
	add RSTACK, INTSIZE
	add [RSTACK], R0
	STEP
	
func_prn:
	act act_prn, R0
	STEP

func_prns:
	act act_prns, R0
	STEP

func_555:
	sub RSTACK, INTSIZE
	mov R0, 555
	mov [RSTACK], R0
	STEP
	
func_777:
	sub RSTACK, INTSIZE
	mov R0, 777
	mov [RSTACK], R0
	STEP
	
func_quit:
	puts 'quit',10
	Bye

func ontxt
exi

func_ontxt:
	act ontxt
	STEP


