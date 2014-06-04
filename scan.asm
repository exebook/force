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
	; put label to here->next->next
	mov R0, [REXE]
	vmpush R0
	;
	put_token_on_stack
	gset CUTMODE, func_token_cmp
	STEP

func_token_dcmp:
	mov R0, func_token_dispatch
	mov [REXE + FUNC], R0
	put_token_on_stack
	cmp_two_strings_on_stack
	cmp A, 0
	jne .cont
		gset CUTMODE, func_token_dispatch
		add RSTACK, 2*INTSIZE
		mov R0, REXE ; finish address
		rpop REXE
;		rpop R1
;		rpush R0 ; return to the finish address after all the tokens we skipped
		vmpush R0
		mov REXE, [REXE] ; skip dscan's name
	.cont:
	STEP

func_token_dscan:
	rpeek R0
	rpush REXE
	mov R2, REXE
	mov REXE, [R0]
	act act_txtcut ; only uses REXE
	; put label to caller->next
	vmpush REXE
	; push 'end' string on stack
	sub RSTACK, INTSIZE * 2
	rpeek R2
	mov R2, [R2]
	mov R1, [R2 + DATA]
	mov [RSTACK], R1
	mov R0, [R2 + STRING]
	mov [RSTACK + INTSIZE], R0
	
	gset CUTMODE, func_token_dcmp
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
