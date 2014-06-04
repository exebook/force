func_if:
	vmpop R0
	cmp R0, 0
	jne .l
	mov REXE, [REXE]
	.l:
	STEP
func_if_make:
	need 1
	mov [REXE + FUNC], INTTYPE func_if
	jmp INTTYPE [REXE + FUNC]
func_if_else:
	vmpop R0
	cmp R0, 0
	jne .l
	mov REXE, [REXE + DATA]
	jmp INTTYPE [REXE + FUNC]
	.l:
	STEP
func_if_else_make: ; (n) *ifelse a b quit -> () ifelse ?a->quit ?b->quit
	need 2
	mov [REXE + FUNC], INTTYPE func_if_else
	mov R0, [REXE] ;a
	mov R1, [R0] ;b
	mov R2, [R1] ;quit
	mov [R0 + NEXT], R2
	mov [REXE + DATA], R1
	jmp INTTYPE [REXE + FUNC]
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
	rpop A
	vmpush A
	STEP	
func_rpeek:
	rpeek A
	vmpush A
	STEP
func_jump:
	vmpop REXE
;	STEP
	jmp INTTYPE [REXE + FUNC]
