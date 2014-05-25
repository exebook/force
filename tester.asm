macro addc fu, dat {
	mov [B + NEXT], A
	mov [A + PREV], B
	mov C, 0
	if ~ dat eq
		mov C, dat
	end if
	mov [A + DATA], C
	mov [A + FUNC], INTTYPE fu
	mov [A + STRING], INTTYPE 0
	mov B, A
	add A, CODE_SIZE
}

func test_adder
	chars 'hello!'
	mov D, A
	global CODE
	mov B, A
	addc func_num, 100
	addc func_num, 200
	addc func_num, 345
	addc func_num, 123
	addc func_add
	addc func_prn
	addc func_prn
	addc func_num, D
	addc func_prns
	
	addc func_prn
	addc func_quit
	gset CODE
exi

