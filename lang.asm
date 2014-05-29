LOCAL_MEM = 10
FUNC_NAME equ 'undefined '
COUNT_MAX = 0

macro func name, x {
	FUNC_NAME equ `name
	COUNT_MAX = LOCAL_MEM
name:
	if x eq
		mov A, LOCAL_MEM * INTSIZE
	else
		mov A, x * INTSIZE
		COUNT_MAX = x
	end if
	push BP
	mov BP, SP
	sub SP, A
	push A
	_count equ 0
}

macro var [_arg] {
	forward
		_arg equ _count
		_count equ _count + 1
}

macro use [_arg] {
	forward
	_arg equ _count
	_count equ _count + 1
	arg _arg
	set _arg
}

macro display_num n {
	display '0'+ n/100, '0'+ (n - (n/100)*100) / 10, '0'+ n - (n/10)*10
	display ' '
}

macro exi n {
	if _count > COUNT_MAX
		display 10,'    Error: in function "'
		display FUNC_NAME, '" '
		display_num (_count)
		display 'arguments defined, but only '
		display_num (COUNT_MAX)
		display 'reserved ', 10,10
		success = 1
	end if

	pop B
	add SP, B
	pop BP
	if ~ n eq
		mov A, n
	end if
	ret
}

macro popvoid x { add SP, INTSIZE }

macro exe f, [a] {
	if a eq
		push A
		call f
		popvoid
	else
		reverse
			;mov A, a
			;push A
			push INTTYPE a
		common
			call f
		reverse 
			popvoid a
	end if
}

macro pass f, [a] {
	reverse
		get a
		push A
	common
		call f
	reverse 
		popvoid a
}

;macro unpush z { pop B }

macro arg a, b {
	if b eq
		mov B, a
		imul B, INTSIZE
		mov A, [BP + B + INTSIZE * 2]
	else
		mov B, b
		imul B, INTSIZE
		mov a, [BP + B + INTSIZE * 2]
	end if
}

macro get n, dest { ; we lose only A
	push B
	mov B, n
	inc B
	imul B, INTSIZE
	mov A, BP
	sub A, B
	pop B
	if dest eq
		mov A, [A]
	else
		mov dest, [A]
	end if
}

macro pet n, dest {
	mov B, n
	inc B
	imul B, INTSIZE
	mov A, BP
	sub A, B
	if ~ dest eq
		mov dest, A
	end if
}

macro set n, v {
	mov C, n
	inc C
	imul C, INTSIZE
	mov B, BP
	sub B, C
	if ~ v eq
		mov [B], INTTYPE v
	else
		mov [B], A
	end if
}

macro pair a, b { ; a->ax, b->bx
	get a
	push A
	get b
	mov B, A
	pop A
}

macro copy dest, src {
	get src
	set dest
}

; op A, A, inc, B
macro op dest, src1, operation, src2 {
	pair src1, src2
	operation A, B
	set dest
}



