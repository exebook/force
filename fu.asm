
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
	mov A, REXE
	mov A, [A + DATA]
	sub RSTACK, INTSIZE
	mov R0, [REXE + DATA]
	mov [RSTACK], R0
	STEP

func_add:
	mov R0, [RSTACK]
	add RSTACK, INTSIZE
	add [RSTACK], R0
	STEP
	
func_sub:
	mov R0, [RSTACK]
	add RSTACK, INTSIZE
	sub [RSTACK], R0
	STEP
	
func_swap:
	mov R0, [RSTACK]
	mov R1, [RSTACK + INTSIZE]
	mov [RSTACK], R1
	mov [RSTACK + INTSIZE], R0
	STEP
	
func_dup:
	mov R0, [RSTACK]
	sub RSTACK, INTSIZE
	mov [RSTACK], R0
	STEP
	
func_over:
	mov R0, [RSTACK + INTSIZE]
	sub RSTACK, INTSIZE
	mov [RSTACK], R0
	STEP
	
func_drop:
	add RSTACK, INTSIZE
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

