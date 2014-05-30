func_find:
	vmpop R1
	mov R0, [RSTACK]
	pushvm
	exe token_find, R0, R1
	exe token_get, R0
	popvm
	mov [RSTACK], R0
	STEP
	
func_create:
	vmpop R0
	vmpop R1
	pushvm
	exe token_add, R1, R0, func_add, 777
	popvm
	vmpush R0
	STEP

func_const_do:
	STEP

func_const:
	global CURTOK
	mov R0, [R0 + TAB_DATA * INTSIZE]
	mov [REXE + DATA], R0
	mov [REXE + FUNC], INTTYPE func_num
	jmp INTTYPE [REXE + FUNC]
;
;func_make:
;	global CURTOK
;	mov R1, [R0 + TAB_DATA * INTSIZE]
;	mov [REXE + DATA], R1
;	mov R1, [R0 + TAB_FUNC * INTSIZE]
;	mov [REXE + FUNC], R1
;	jmp INTTYPE [REXE + FUNC]
;
	