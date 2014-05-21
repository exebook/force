LOCAL_MEM equ 10

macro func name, x {
name:
	if x eq
		mov A, LOCAL_MEM * INTSIZE
	else
		mov A, x * INTSIZE
	end if
	push BP
	mov BP, SP
	sub SP, A
	push A
}

macro exi n {
	pop B
	add SP, B
	pop BP
	if ~ n eq
		mov A, n
	end if
	ret
}

macro popvoid x { pop B }

macro spush x {
	mov A, x
	push A
}

macro exe f, [a] {
	if a eq
		push A
		call f
		popvoid
	else
		reverse
			mov A, a
			push A
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

macro unpush z { pop B }

macro arg a, b {
	if b eq
		mov B, a
		shl B, 3
		mov A, [BP + B + 16]
	else
		mov B, b
		shl B, 3
		mov a, [BP + B + 16]
	end if
}

macro get n, dest {
	mov B, n
	inc B
	shl B, 3
	mov A, BP
	sub A, B
	if dest eq
		mov A, [A]
	else
		mov dest, [A]
	end if
}

macro pet n, dest {
	mov B, n
	inc B
	shl B, 3
	mov A, BP
	sub A, B
	if ~ dest eq
		mov dest, A
	end if
}

macro set n, v {
	mov C, n
	inc C
	shl C, 3
	mov B, BP
	sub B, C
	if ~ v eq
		mov A, v
	end if
	mov [B], A
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



