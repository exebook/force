func_djump:
	mov REXE, [REXE + DATA]
	jmp INTTYPE [REXE + FUNC]
func_dataif:
	vmpop R0
	cmp R0, 0
	jne .l
		mov REXE, [REXE + DATA]
		jmp INTTYPE [REXE + FUNC]
	.l:
	STEP
func_if:
	vmpop R0
	cmp R0, 0
	jne .l
		mov REXE, [REXE]
	.l:
	STEP
func_call:
	rpush REXE
	vmpop REXE
	jmp INTTYPE [REXE + FUNC]
func_dcall:
	rpush REXE
	mov REXE, [REXE + DATA]
	jmp INTTYPE [REXE + FUNC]
func_ret:
	rpop REXE
	STEP
func_rpush:
	vmpop A
	rpush A
	STEP
func_rpop:
	rpop R0
	vmpush R0
	STEP	
func_rpeek:
	rpeek A
	vmpush A
	STEP
func_label:
	rpush REXE
	STEP
func_jz:
	vmpop R0
	vmpop R1
	cmp R0, 0
	jne .zero
		mov REXE, R1
		jmp INTTYPE [REXE + FUNC]
	.zero:
	STEP
func_jnz:
	vmpop R0
	vmpop R1
	cmp R0, 0
	je .zero
		mov REXE, R1
		jmp INTTYPE [REXE + FUNC]
	.zero:
	STEP
func_jump:
	vmpop REXE
	jmp INTTYPE [REXE + FUNC]
