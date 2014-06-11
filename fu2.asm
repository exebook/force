
func_get:
	mov R0, [RSTACK]
	mov R0, [R0]
	mov [RSTACK], R0
	STEP

func_set:
	vmpop R1
	vmpop R0
	mov [R1], R0
	STEP

func_getb:
	mov R0, [RSTACK]
	mov R0, [R0]
	and R0, 255
	mov [RSTACK], R0
	STEP

func_setb:
	mov R1, [RSTACK]
	add RSTACK, INTSIZE
	mov R0, [RSTACK]
	add RSTACK, INTSIZE
	mov [R1], R0b
	STEP

func_sysvar:
	mov R0, [RSTACK]
	imul R0, INTSIZE
	add R0, memory
	mov [RSTACK], R0
	STEP

func_balloc:
	cinvoke malloc, [RSTACK]
	mov [RSTACK], R0
	STEP

func_alloc:
	mov R0, INTTYPE [RSTACK]
	imul R0, INTSIZE
	pushvm
	cinvoke malloc, R0
	popvm
	mov [RSTACK], R0
	STEP

func_ttoken: ; put next token name and name length on stack
	need 1
	mov REXE, [REXE] ; *token abc quit -> [abc 3] *quit
	mov R0, [REXE + STRING]
	mov R1, [REXE + DATA]
	vmpush R0
	vmpush R1
	STEP

func_token: ; put next token name and name length on stack
	mov REXE, [REXE] ; *token abc quit -> [abc 3] *quit
	mov R0, [REXE + STRING]
	mov R1, [REXE + DATA]
	vmpush R0
	vmpush R1
	STEP

func_sput:
	pushall
	mov A, [RSTACK]
	mov B, [RSTACK + INTSIZE]
	call _prn_str
	popall
	add RSTACK, INTSIZE * 2
	STEP
func_scmp:
	cmp_two_strings_on_stack
	vmpush A
	STEP
func_depth:
	global STACK_BASE
	mov R2, RSTACK
	sub R0, R2
	mov R2, INTSIZE
	mov R1, 0
	idiv R2
 	vmpush R0
	STEP
func_rdepth:
	global RETSTACK
	mov R2, R0
	global RETSTACK_BASE
	sub R0, R2
	mov R2, INTSIZE
	mov R1, 0
	idiv R2
	vmpush R0
	STEP
