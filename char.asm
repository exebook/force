_str_len:
	mov	SI, A
	mov	A, 0
@@:
	cmp	byte [SI], 0
	jz	@f
	inc	SI
	inc	A
	jmp	@b
@@:
	ret
	
_prn_str:
	mov C, A
	mov A, B
	@@:
	mov B, [A]
	push C
	push A
	cinvoke putchar, B
	pop A
	inc A
	pop C
	loop @b
	ret

macro chars str, [s] {
common
	jmp @f
	local .x
	.x db str
forward
	if ~ s eq
		db s
	end if
common
	db 0
@@:
	mov A, .x
}

macro puts str, [s] {
common
	pushall
	jmp @f
	local .x
	.x db str
forward
	if ~ s eq
		db s
	end if
common
	db 0
@@:
	mov A, .x
	call _str_len
	mov B, .x
	call _prn_str
	popall
}

_prn_int:
	pushall
	mov BP, SP
	sub SP, 10
@@:
	mov B, 10
	mov D, 0h ; high dword
	div B
	push A
		mov B, D
		add B, 48
		dec BP
		mov byte [BP], bl
	pop A

	cmp A, 0
	jnz @b

	mov A, BP
	sub A, SP
	mov B, 10
	sub B, A
	mov A, B
	mov B, BP
	call _prn_str

	add SP, 10
	puts ' '
	popall
	ret

